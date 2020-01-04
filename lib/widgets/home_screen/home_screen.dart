import 'package:adaptive_library/adaptive_library.dart';
import 'package:flutter/material.dart';

import 'package:chat_messenger/i18n.dart';
import 'package:chat_messenger/widgets/chat_screen/chat_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AdaptiveScaffold(
      appBar: AppBar(
        title: Text(I18n.appTitle),
      ),
      body: SafeArea(
        child: ChatScreen(),
      ),
    );
  }
}
