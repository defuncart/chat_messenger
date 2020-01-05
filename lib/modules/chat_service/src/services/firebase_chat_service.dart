import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as path;

import 'package:chat_messenger/modules/uuid/uuid.dart';

import 'i_chat_service.dart';

/// A chat service using Firebase as the backend
class FirebaseChatService implements IChatService {
  /// A path for the messages collection
  static const _messageCollectionPath = 'messages';

  /// A base path for image storage
  static const _imageStorageBasePath = 'chat_images/';

  /// A list of valid upload file extensions
  static const _validUploadFileExtensions = const ['.jpg', '.png'];

  /// A map of file extension to content type
  static const _contentTypeForFileExtension = const {
    '.jpg': 'image/jpg',
    '.png': 'image/png',
  };

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

  /// Uploads a file
  ///
  /// If the upload was unsuccessful, null is returned
  Future<String> uploadFile(File file) async {
    if (file != null) {
      final fileExtension = path.extension(file.path).toLowerCase();
      if (_isFileExtensionValid(fileExtension)) {
        final storageReferencePath = '$_imageStorageBasePath${UUID.generate()}$fileExtension';
        final storageReference = FirebaseStorage.instance.ref().child(storageReferencePath);
        final uploadTask = storageReference.putFile(
          file,
          StorageMetadata(
            contentType: _contentTypeForFileExtension[fileExtension],
          ),
        );
        final download = await uploadTask.onComplete;
        final url = await download.ref.getDownloadURL();

        return url;
      } else {
        print('Error! File extension $fileExtension is not valid!');
      }
    }

    return null;
  }

  /// Determines if a file extension is valid (for upload)
  bool _isFileExtensionValid(String fileExtension) => _validUploadFileExtensions.contains(fileExtension);
}
