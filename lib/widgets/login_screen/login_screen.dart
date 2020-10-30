import 'package:adaptive_library/adaptive_library.dart';
import 'package:chat_messenger/i18n.dart';
import 'package:chat_messenger/modules/chat_service/chat_service.dart';
import 'package:chat_messenger/widgets/home_screen/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

/// A screen which logs the user in
class LoginScreen extends StatefulWidget {
  LoginScreen({Key key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  Future<bool> loginFuture;
  IChatService chatService;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    chatService = Provider.of<IChatService>(context, listen: false);
    loginFuture = login();
  }

  Future<bool> login() async {
    final success = await chatService.loginUser();

    // if login was not sucessful, display an alert allowing the user to try again
    if (!success) {
      showDialog(
        context: context,
        builder: (context) => AdaptiveAlertDialog(
          title: Text(
            I18n.popupSomethingWentWrongTitle,
          ),
          content: Text(
            I18n.popupSomethingWentWrongDescription,
          ),
          actions: <AdaptiveAlertDialogButton>[
            AdaptiveAlertDialogButton(
              child: Text(
                I18n.popupSomethingWentWrongButton,
              ),
              onPressed: () {
                setState(() {
                  loginFuture = login();
                });
              },
            ),
          ],
        ),
      );
    }

    return success;
  }

  @override
  Widget build(BuildContext context) {
    return AdaptiveScaffold(
      body: FutureBuilder(
        future: loginFuture,
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data == true) {
            return HomeScreen();
          } else if (snapshot.hasError ||
              (snapshot.connectionState == ConnectionState.done && snapshot.data == false)) {
            return Container();
          }

          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
