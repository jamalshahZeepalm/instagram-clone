import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:instagram_clone/Database%20Helper/database_helper.dart';
import 'package:instagram_clone/Model/post.dart';
import 'package:uuid/uuid.dart';

class DatabaseManager {
  Future<String> uploadPost(
      {required String description,
      required Uint8List file,
      required String uid,
      required String username,
      required String profImage}) async {
    String res = 'some error occurred';
    try {
      String photoUrl = await imageStorage(
          childName: 'Post', file: file, isprofilePic: false);
      String postId = const Uuid().v1();
      Post post = Post(
        description: description,
        uid: uid,
        username: username,
        postId: postId,
        datePublished: DateTime.now(),
        postUrl: photoUrl,
        profImage: profImage,
        likes: [],
      );
      DatabaseHelper.postCollection.doc(postId).set(post.toMap());
      res = 'success';
    } catch (error) {
      Get.snackbar(error.toString(), '');
    }
    return res;
  }

  static FirebaseAuth auth = FirebaseAuth.instance;
  static Future<String> imageStorage(
      {required String childName,
      required Uint8List file,
      required bool isprofilePic}) async {
    Reference reference = DatabaseHelper.storage
        .ref()
        .child(childName)
        .child(auth.currentUser!.uid);
    if (isprofilePic == false) {
      String uid = const Uuid().v1();
      reference = reference.child(uid);
    }
    UploadTask uploadTask = reference.putData(file);
    TaskSnapshot snapshot = await uploadTask;
    String downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  Future<void> likePost(
      {required String postId,
      required List likes,
      required String uid}) async {
    if (likes.contains(uid)) {
      await DatabaseHelper.postCollection.doc(postId).update({
        'likes': FieldValue.arrayRemove([uid]),
      });
    } else {
      await DatabaseHelper.postCollection.doc(postId).update({
        'likes': FieldValue.arrayUnion([uid]),
      });
    }
  }

  Future<void> commentPost(
      {required postId,
      required String name,
      required String text,
      required String uid,
      required String profilePic}) async {
    try {
      String commentId = const Uuid().v1();
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      firestore
          .collection('Post')
          .doc(postId)
          .collection('Comments')
          .doc(commentId)
          .set(
        {
          'profilePic': profilePic,
          'name': name,
          'uid': uid,
          'text': text,
          'commentId': commentId,
          'datePublished': DateTime.now(),
        },
      );
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> deletePost({required String postId}) async {
    await FirebaseFirestore.instance.collection('Post').doc(postId).delete();
  }

  Future<void> followingMethod(
      {required String uid, required String followId}) async {
    var snap =
        await FirebaseFirestore.instance.collection('Users').doc(uid).get();
    List following = snap['following'];
    if (following.contains(followId)) {
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(followId)
          .update({
        'follower': FieldValue.arrayRemove([uid])
      });
      await FirebaseFirestore.instance.collection('Users').doc(uid).update({
        'following': FieldValue.arrayRemove([followId])
      });
    } else {
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(followId)
          .update({
        'follower': FieldValue.arrayUnion([uid])
      });
      await FirebaseFirestore.instance.collection('Users').doc(uid).update({
        'following': FieldValue.arrayUnion([followId])
      });
    }
  }

  static Future<String> imageStorages({
    required Uint8List file,
  }) async {
    String uid = const Uuid().v1();
    Reference reference =
        DatabaseHelper.storage.ref().child('Teacher').child(uid);

    UploadTask uploadTask = reference.putData(file);
    TaskSnapshot snapshot = await uploadTask;
    String downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }
}
