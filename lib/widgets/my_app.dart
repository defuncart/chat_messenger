import 'package:adaptive_library/adaptive_library.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import 'package:chat_messenger/i18n.dart';
import 'package:chat_messenger/modules/chat_service/chat_service.dart';
import 'package:chat_messenger/modules/user_preferences/user_preferences.dart';
import 'package:chat_messenger/widgets/create_user_screen/create_user_screen.dart';
import 'package:chat_messenger/widgets/login_screen/login_screen.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<IChatService>(
          create: (_) => FirebaseChatService(),
        ),
      ],
      child: AdaptiveInheritance(
        adaptiveState: AdaptiveInheritance.getStateByPlatform(),
        // adaptiveState: AdaptiveState.Cupertino,
        // adaptiveState: AdaptiveState.Material,
        child: AdaptiveApp(
          localizationsDelegates: [
            const I18nDelegate(),
            GlobalCupertinoLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
          ],
          supportedLocales: I18nDelegate.supportedLocals,
          materialTheme: ThemeData.light(),
          cupertinoTheme: CupertinoThemeData(
            brightness: Brightness.light,
          ),
          home: UserPreferences.getUsername() == null ? CreateUserScreen() : LoginScreen(),
        ),
      ),
    );
  }
}
