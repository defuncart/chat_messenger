import 'package:dash_chat/dash_chat.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:chat_messenger/i18n.dart';
import 'package:chat_messenger/modules/chat_service/chat_service.dart';
import 'package:chat_messenger/modules/user_preferences/user_preferences.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key key}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
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
                onSend: (message) => chatService.sendMessage(message.toJson()),
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
}
