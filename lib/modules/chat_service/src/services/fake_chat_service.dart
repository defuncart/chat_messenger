import 'dart:io';

import 'package:meta/meta.dart';

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
  Future<void> sendMessage(Map<String, dynamic> messageData, {@required String messageId}) async =>
      await Future.delayed(Duration(milliseconds: 500));

  /// Deletes a message by id
  Future<void> deleteMessage(String messageId) async => await Future.delayed(Duration(milliseconds: 500));

  /// Uploads a file
  Future<String> uploadFile(File file, {@required String fileId}) async {
    await Future.delayed(Duration(seconds: 1));
    return null;
  }
}
