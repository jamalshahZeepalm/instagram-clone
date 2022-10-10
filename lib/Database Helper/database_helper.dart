import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class DatabaseHelper {
 
  static FirebaseStorage storage = FirebaseStorage.instance;
  static FirebaseFirestore firestore = FirebaseFirestore.instance;

  static CollectionReference userCollection = firestore.collection('Users');
  static CollectionReference postCollection = firestore.collection('Post');
}
