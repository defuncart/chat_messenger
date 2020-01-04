import 'i_chat_service.dart';

/// A fake chat service for testing
class FakeChatService implements IChatService {
  /// Attempts to log in the user anonymously
  Future<bool> loginUser() async {
    await Future.delayed(Duration(seconds: 2));
    return true;
  }
}
