import 'package:adaptive_library/adaptive_library.dart';
import 'package:dash_chat/dash_chat.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import 'package:chat_messenger/i18n.dart';
import 'package:chat_messenger/modules/chat_service/chat_service.dart';
import 'package:chat_messenger/modules/user_preferences/user_preferences.dart';
import 'package:chat_messenger/modules/uuid/uuid.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key key}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  /// image quality setting when sending images
  static const imageQuality = 80;

  /// image max height setting when sending images
  static const maxHeight = 400.0;

  /// image max width setting when sending images
  static const maxWidth = 400.0;

  ChatUser user = ChatUser();
  IChatService chatService;

  @override
  void initState() {
    super.initState();

    user.name = UserPreferences.getUsername();
    user.uid = UserPreferences.getUserid();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    chatService = Provider.of<IChatService>(context);
  }

  @override
  Widget build(BuildContext context) {
    // TODO figure out issue with AdaptiveScaffold
    return Scaffold(
      appBar: AppBar(
        title: Text(I18n.appTitle),
      ),
      body: SafeArea(
        child: StreamBuilder(
          stream: chatService.messageStream(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final messages = List<ChatMessage>.from(snapshot.data.map((item) => ChatMessage.fromJson(item)));

              return DashChat(
                user: user,
                messages: messages,
                inputDecoration: InputDecoration(
                  hintText: I18n.chatScreenMessageTextFieldHint,
                ),
                onSend: (message) => chatService.sendMessage(message.toJson(), messageId: message.id),
                trailing: <Widget>[
                  IconButton(
                    icon: Icon(Icons.camera_alt),
                    onPressed: () => onSendImage(ImageSource.camera),
                  ),
                  IconButton(
                    icon: Icon(Icons.photo),
                    onPressed: () => onSendImage(ImageSource.gallery),
                  ),
                ],
                onLongPressMessage: onMessageLongPress,
              );
            } else if (snapshot.hasError || !snapshot.hasData) {
              return Center(
                child: Text(I18n.popupSomethingWentWrongTitle),
              );
            }

            return Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
    );
  }

  void onSendImage(ImageSource imageSource) async {
    try {
      final file = await ImagePicker.pickImage(
        source: imageSource,
        imageQuality: imageQuality,
        maxHeight: maxHeight,
        maxWidth: maxWidth,
      );

      if (file != null) {
        final url = await chatService.uploadFile(file, fileId: UUID.generate());
        final message = ChatMessage(text: '', user: user, image: url);
        await chatService.sendMessage(message.toJson(), messageId: message.id);
      }
    } catch (_) {}
  }

  void onMessageLongPress(ChatMessage message) {
    if (message.user.uid == user.uid) {
      showDialog(
        context: context,
        builder: (context) => AdaptiveAlertDialog(
          title: Text(
            I18n.deleteMessagePopupTitle,
          ),
          content: Text(
            I18n.deleteMessagePopupDescription,
          ),
          actions: <AdaptiveAlertDialogButton>[
            AdaptiveAlertDialogButton(
              child: Text(
                I18n.generalCancel,
              ),
            ),
            AdaptiveAlertDialogButton(
              child: Text(
                I18n.generalDelete,
              ),
              onPressed: () async => deleteMessage(message),
              destructive: true,
            ),
          ],
        ),
      );
    }
  }

  void deleteMessage(ChatMessage message) async {
    if (message.image != null) {
      await chatService.deleteFile(message.image);
    }

    await chatService.deleteMessage(message.id);
  }
}
