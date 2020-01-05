import 'dart:io';

/// A contract for which a chat service must adhere to
abstract class IChatService {
  /// Attempts to log in the user anonymously
  Future<bool> loginUser();

  /// The user's message stream
  ///
  /// Note that each message is a json map
  Stream<List<Map<String, dynamic>>> messageStream();

  /// Sends a chat message
  ///
  /// Note that each message is a json map
  void sendMessage(Map<String, dynamic> messageData);

  /// Uploads a file
  Future<String> uploadFile(File file);
}
