import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:meta/meta.dart';
import 'package:path/path.dart' as path;

import 'i_chat_service.dart';

/// A chat service using Firebase as the backend
class FirebaseChatService implements IChatService {
  /// A path for the messages collection
  static const _messageCollectionPath = 'messages';

  /// A base path for image storage
  static const _imageStorageBasePath = 'chat_images/';

  /// The createdBy key used to order by date
  static const _createdAtKey = 'createdAt';

  /// How many messages are returned per request
  static const _limitMessagesPerRequest = 5;

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

  /// Attempts to log out the user anonymously
  @override
  Future<void> logoutUser() async => await FirebaseAuth.instance.signOut();

  /// The user's message stream
  ///
  /// Note that each message is a json map and that the list is sent in order when sent (oldest first)
  Stream<List<Map<String, dynamic>>> messageStream() {
    final query = FirebaseFirestore.instance
        .collection(_messageCollectionPath)
        .orderBy(_createdAtKey, descending: true)
        .limit(_limitMessagesPerRequest);
    return query.snapshots().map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());
  }

  /// Sends a chat message
  ///
  /// Note that each message is a json map
  Future<void> sendMessage(Map<String, dynamic> messageData, {@required String messageId}) async {
    final documentReference = FirebaseFirestore.instance.collection(_messageCollectionPath).doc(messageId);
    await FirebaseFirestore.instance.runTransaction((transaction) async {
      transaction.set(
        documentReference,
        messageData,
      );
    });
  }

  /// Deletes a message by id
  Future<void> deleteMessage(String messageId) async {
    final documentReference = FirebaseFirestore.instance.collection(_messageCollectionPath).doc(messageId);
    await FirebaseFirestore.instance.runTransaction((transaction) async {
      transaction.delete(documentReference);
    });
  }

  /// Uploads a file
  ///
  /// If the upload was unsuccessful, null is returned
  Future<String> uploadFile(File file, {@required String fileId}) async {
    if (file != null) {
      final fileExtension = path.extension(file.path).toLowerCase();
      if (_isFileExtensionValid(fileExtension)) {
        final storageReferencePath = '$_imageStorageBasePath$fileId$fileExtension';
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

  /// Deletes a file by url
  Future<void> deleteFile(String url) async {
    final storageReference = await FirebaseStorage.instance.getReferenceFromUrl(url);
    await storageReference.delete();
  }
}
