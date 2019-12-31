import 'package:adaptive_library/adaptive_library.dart';
import 'package:flutter/material.dart';

import 'package:chat_messenger/i18n.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AdaptiveScaffold(
      title: Text(I18n.appTitle),
      appBar: AppBar(
        title: Text(I18n.appTitle),
      ),
      body: Center(
        child: Text(I18n.test),
      ),
    );
  }
}
