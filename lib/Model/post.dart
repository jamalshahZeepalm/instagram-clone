// ignore_for_file: prefer_typing_uninitialized_variables

import 'dart:convert';

class Post {
  String description;
  String uid;
  String username;
  List likes;
  String postId;
  final datePublished;
  String postUrl;
  String profImage;
  Post({
    required this.description,
    required this.uid,
    required this.username,
    required this.likes,
    required this.postId,
    required this.datePublished,
    required this.postUrl,
    required this.profImage,
  });

 

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};
  
    result.addAll({'description': description});
    result.addAll({'uid': uid});
    result.addAll({'username': username});
    result.addAll({'likes': likes});
    result.addAll({'postId': postId});
    result.addAll({'datePublished': datePublished});
    result.addAll({'postUrl': postUrl});
    result.addAll({'profImage': profImage});
  
    return result;
  }

  factory Post.fromMap(Map<String, dynamic> map) {
    return Post(
      description: map['description'] ?? '',
      uid: map['uid'] ?? '',
      username: map['username'] ?? '',
      likes: List.from(map['likes']),
      postId: map['postId'] ?? '',
      datePublished: map['datePublished'] ?? '',
      postUrl: map['postUrl'] ?? '',
      profImage: map['profImage'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Post.fromJson(String source) => Post.fromMap(json.decode(source));
}
