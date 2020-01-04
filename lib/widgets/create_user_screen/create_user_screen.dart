import 'package:adaptive_library/adaptive_library.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:uuid/uuid.dart';

import 'package:chat_messenger/i18n.dart';
import 'package:chat_messenger/modules/user_preferences/user_preferences.dart';
import 'package:chat_messenger/widgets/login_screen/login_screen.dart';

/// A screen where the user can create an anonymous account
class CreateUserScreen extends StatefulWidget {
  const CreateUserScreen({Key key}) : super(key: key);

  @override
  _CreateUserScreenState createState() => _CreateUserScreenState();
}

class _CreateUserScreenState extends State<CreateUserScreen> {
  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AdaptiveScaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Material(
                // TODO add error handling
                child: TextField(
                  decoration: InputDecoration(
                    hintText: I18n.createUserScreenUsernameTextFieldHint,
                  ),
                  controller: controller,
                ),
              ),
            ),
            Container(height: 16.0),
            AdaptiveButton(
              child: Text(I18n.generalNext),
              onPressed: () async {
                await UserPreferences.setUsername(controller.text);
                await UserPreferences.setUserid(Uuid().v4().toString());
                Navigator.of(context).pushReplacement(
                  // platform adaptive route by default
                  MaterialPageRoute(
                    builder: (context) => LoginScreen(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
