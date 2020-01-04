import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'i_chat_service.dart';

/// A chat service using Firebase as the backend
class FirebaseChatService implements IChatService {
  static const _messageCollectionPath = 'messages';

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

  /// The user's message stream
  ///
  /// Note that each message is a json map
  Stream<List<Map<String, dynamic>>> messageStream() {
    final stream = Firestore.instance.collection(_messageCollectionPath).snapshots();
    return stream.map((snapshot) => snapshot.documents.map((doc) => doc.data).toList());
  }

  /// Sends a chat message
  ///
  /// Note that each message is a json map
  void sendMessage(Map<String, dynamic> messageData) {
    final documentReference = Firestore.instance
        .collection(_messageCollectionPath)
        .document(DateTime.now().millisecondsSinceEpoch.toString());

    Firestore.instance.runTransaction((transaction) async {
      await transaction.set(
        documentReference,
        messageData,
      );
    });
  }
}
