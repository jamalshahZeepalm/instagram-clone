import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String uid;
  String userName;
  String email;
  String bio;
  String userProfile;
  List  follower;
  List  following;
  UserModel({
    required this.uid,
    required this.userName,
    required this.email,
    required this.bio,
    required this.userProfile,
    required this.follower,
    required this.following,
  });

   
  static UserModel formSnap(DocumentSnapshot documentSnapshot) {
    var snapshot = (documentSnapshot.data() as Map<String, dynamic>);
    return UserModel(
      uid: snapshot['uid'],
      userName: snapshot['userName'],
      email: snapshot['email'],
      bio: snapshot['bio'],
      userProfile: snapshot['userProfile'],
      follower: snapshot['following'],
      following: snapshot['follower'],
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};
  
    result.addAll({'uid': uid});
    result.addAll({'userName': userName});
    result.addAll({'email': email});
    result.addAll({'bio': bio});
    result.addAll({'userProfile': userProfile});
    result.addAll({'follower': follower});
    result.addAll({'following': following});
  
    return result;
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] ?? '',
      userName: map['userName'] ?? '',
      email: map['email'] ?? '',
      bio: map['bio'] ?? '',
      userProfile: map['userProfile'] ?? '',
      follower: List.from(map['follower']),
      following: List.from(map['following']),
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) => UserModel.fromMap(json.decode(source));
}
