import 'dart:io';

import 'package:adaptive_library/adaptive_library.dart';
import 'package:chat_messenger/configs/giphy_config.dart';
import 'package:chat_messenger/i18n.dart';
import 'package:chat_messenger/modules/chat_service/chat_service.dart';
import 'package:chat_messenger/modules/user_preferences/user_preferences.dart';
import 'package:chat_messenger/modules/uuid/uuid.dart';
import 'package:chat_messenger/widgets/create_user_screen/create_user_screen.dart';
import 'package:dash_chat/dash_chat.dart';
import 'package:flutter/material.dart';
import 'package:giphy_picker/giphy_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

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

  bool get isMobile => Platform.isIOS || Platform.isAndroid;

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
        actions: [
          PopupMenuButton<int>(
            onSelected: (index) async {
              await context.read<IChatService>().logoutUser();
              await UserPreferences.clear();
              Navigator.of(context).pushReplacement(
                // platform adaptive route by default
                MaterialPageRoute(
                  builder: (context) => CreateUserScreen(),
                ),
              );
            },
            color: Theme.of(context).scaffoldBackgroundColor,
            itemBuilder: (_) => [
              PopupMenuItem<int>(
                value: 0,
                child: Text(I18n.generalLogout),
              )
            ],
          ),
        ],
      ),
      body: SafeArea(
        child: StreamBuilder(
          stream: chatService.messageStream(),
          builder: (_, snapshot) {
            if (snapshot.hasData) {
              final messages = List<ChatMessage>.from(snapshot.data.map((item) => ChatMessage.fromJson(item)));
              messages.sort((a, b) => a.createdAt.compareTo(b.createdAt));

              return DashChat(
                user: user,
                messages: messages,
                inputDecoration: InputDecoration(
                  hintText: I18n.chatScreenMessageTextFieldHint,
                ),
                onSend: (message) => chatService.sendMessage(message.toJson(), messageId: message.id),
                trailing: <Widget>[
                  IconButton(
                    icon: Icon(Icons.gif),
                    onPressed: () async {
                      final gif = await GiphyPicker.pickGif(
                        context: context,
                        apiKey: GiphyConfig.apiKey,
                        showPreviewPage: false,
                        searchText: I18n.gifSearchTextHint,
                      );

                      if (gif != null) {
                        final gifUrl = gif.images.original.url;
                        final message = ChatMessage(text: '', user: user, image: gifUrl);
                        chatService.sendMessage(message.toJson(), messageId: message.id);
                      }
                    },
                  ),
                  if (isMobile)
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(Icons.camera_alt),
                          onPressed: () => onSendImage(ImageSource.camera),
                        ),
                        IconButton(
                          icon: Icon(Icons.photo),
                          onPressed: () => onSendImage(ImageSource.gallery),
                        ),
                      ],
                    ),
                ],
                onLongPressMessage: onMessageLongPress,
              );
            } else if (snapshot.hasError) {
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
      final pickedFile = await ImagePicker().getImage(
        source: imageSource,
        imageQuality: imageQuality,
        maxHeight: maxHeight,
        maxWidth: maxWidth,
      );

      if (pickedFile != null) {
        final url = await chatService.uploadFile(
          File(pickedFile.path),
          fileId: UUID.generate(),
        );
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
    // HACK to avoid trying to delete images from giphy which are not stored on firebase
    if (message.image != null && !message.image.contains('giphy')) {
      await chatService.deleteFile(message.image);
    }

    await chatService.deleteMessage(message.id);
  }
}
