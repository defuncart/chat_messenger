import 'package:chat_messenger/modules/user_preferences/user_preferences.dart';
import 'package:chat_messenger/widgets/my_app.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  // TODO move to an initialization widget
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await UserPreferences.init();
  // await UserPreferences.clear();

  runApp(MyApp());
}
