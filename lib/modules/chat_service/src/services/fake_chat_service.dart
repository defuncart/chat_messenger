import 'i_chat_service.dart';

/// A fake chat service for testing
class FakeChatService implements IChatService {
  /// Attempts to log in the user anonymously
  Future<bool> loginUser() async {
    await Future.delayed(Duration(seconds: 2));
    return true;
  }

  /// The user's message stream
  ///
  /// Note that each message is a json map
  Stream<List<Map<String, dynamic>>> messageStream() => null;

  /// Sends a chat message
  ///
  /// Note that each message is a json map
  void sendMessage(Map<String, dynamic> messageData) {}
}
