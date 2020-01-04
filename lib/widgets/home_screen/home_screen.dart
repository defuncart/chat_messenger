import 'package:flutter/material.dart';

import 'package:chat_messenger/widgets/chat_screen/chat_screen.dart';

/// Presently the HomeScreen is simply the chat screen
class HomeScreen extends StatelessWidget {
  const HomeScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) => ChatScreen();
}
