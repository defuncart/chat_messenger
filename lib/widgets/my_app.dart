import 'package:adaptive_library/adaptive_library.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:chat_messenger/i18n.dart';
import 'package:chat_messenger/widgets/home_screen/home_screen.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AdaptiveInheritance(
      adaptiveState: AdaptiveInheritance.getStateByPlatform(),
      // adaptiveState: AdaptiveState.Cupertino,
      // adaptiveState: AdaptiveState.Material,
      child: AdaptiveApp(
        localizationsDelegates: [
          const I18nDelegate(),
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        supportedLocales: I18nDelegate.supportedLocals,
        materialTheme: ThemeData.light(),
        cupertinoTheme: CupertinoThemeData(
          brightness: Brightness.light,
        ),
        home: HomeScreen(),
      ),
    );
  }
}
