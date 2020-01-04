import 'package:firebase_auth/firebase_auth.dart';

import 'i_chat_service.dart';

/// A chat service using Firebase as the backend
class FirebaseChatService implements IChatService {
  /// Attempts to log in the user anonymously
  Future<bool> loginUser() async {
    try {
      final result = await FirebaseAuth.instance.signInAnonymously();
      if (result != null) {
        return true;
      }
    } catch (e) {
      print(e);
    }

    return false;
  }
}
