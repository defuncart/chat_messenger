import 'dart:io';

import 'package:meta/meta.dart';

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
  Future<void> sendMessage(Map<String, dynamic> messageData, {@required String messageId});

  /// Deletes a message by id
  Future<void> deleteMessage(String messageId);

  /// Uploads a file
  Future<String> uploadFile(File file, {@required String fileId});

  /// Deletes a file by url
  Future<void> deleteFile(String url);
}
