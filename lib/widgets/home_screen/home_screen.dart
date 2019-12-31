import 'package:flutter/material.dart';

import 'package:chat_messenger/i18n.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat Messenger'),
      ),
      body: Center(
        child: Text(I18n.test),
      ),
    );
  }
}
