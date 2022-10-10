import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:instagram_clone/Database%20Helper/database_helper.dart';
import 'package:instagram_clone/Database%20Services/database_manager.dart';
import 'package:instagram_clone/Model/test.dart';
import 'package:instagram_clone/Model/user_profile.dart';
import 'package:uuid/uuid.dart';

class AuthServices {
  FirebaseAuth auth = FirebaseAuth.instance;
  Future<String> signUpUser(
      {required UserModel userModel,
      required String password,
      required Uint8List file}) async {
    String res = 'some error occure';
    try {
      if (userModel.userName.isNotEmpty ||
          userModel.bio.isNotEmpty ||
          userModel.email.isNotEmpty ||
          password.isNotEmpty ||
          file != null) {
        UserCredential credential = await auth.createUserWithEmailAndPassword(
            email: userModel.email, password: password);

        String profileUrl = await DatabaseManager.imageStorage(
            childName: 'ProfilePics', file: file, isprofilePic: true);
        userModel.uid = credential.user!.uid;
        userModel.userProfile = profileUrl;
        await storeUserData(userModel: userModel);
        res = 'success';
      } else {
        Get.snackbar('Feild Empty', 'Feild is not be Empty');
      }
    } catch (error) {
      debugPrint(error.toString());
      res = error.toString();
    }
    return res;
  }

  Future<String> loginUser(
      {required String email, required String password}) async {
    String res = 'some error occure';
    try {
      await auth.signInWithEmailAndPassword(email: email, password: password);
      res = 'success';
    } catch (error) {
      res = error.toString();
    }
    return res;
  }

  Future storeUserData({required UserModel userModel}) async {
    await DatabaseHelper.userCollection
        .doc(userModel.uid)
        .set(userModel.toMap());
  }

  Future<UserModel> getUserDetails() async {
    var snap = await DatabaseHelper.userCollection
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
    return UserModel.formSnap(snap);
  }

  Future<void> logOutUser() async {
    FirebaseAuth auth = FirebaseAuth.instance;

    await auth.signOut();
  }
  Future simpleStore({required Test test}) async {
     String uid = const Uuid().v1();
    await DatabaseHelper.firestore.collection('Test').doc(uid)
        .set(test.toMap());
  }
}
