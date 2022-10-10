// ignore_for_file: must_be_immutable, non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:instagram_clone/Database%20Services/auth_services.dart';
import 'package:instagram_clone/Database%20Services/database_manager.dart';
import 'package:instagram_clone/Widgets/followbutton.dart';
import 'package:instagram_clone/utils/colors.dart';

class FollowingUserScreen extends StatefulWidget {
  String uid;
  FollowingUserScreen({ required this.uid,
    super.key,
  });

  @override
  State<FollowingUserScreen> createState() => _FollowingUserScreenState();
}

class _FollowingUserScreenState extends State<FollowingUserScreen> {
  var snap = {};
  int postLen = 0;
  int followers = 0;
  int following = 0;
  bool isFollowing = false;
  bool isLoading = false;
  DatabaseManager manager = DatabaseManager();
  AuthServices authServices = AuthServices();
 
  @override
  void initState() {
     
    super.initState();
    
    getUserData();

    
  }

  getUserData() async {
    setState(() {
      isLoading = true;
    });
    try {
      var userSnap = await FirebaseFirestore.instance
          .collection('Users')
          .doc(widget.uid)
          .get();
      var post = await FirebaseFirestore.instance
          .collection('Post')
          .where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .get();
      snap = userSnap.data()!;
      postLen = post.docs.length;
      followers = snap['follower'].length;
      following = snap['following'].length;
      isFollowing = userSnap
          .data()!['follower']
          .contains(FirebaseAuth.instance.currentUser!.uid);

      setState(() {});
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Scaffold(
            appBar: AppBar(
              backgroundColor: CustomColors.mobileBackgroundColor,
              title: Text(snap['userName']),
            ),
            body: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.all(15),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 40.r,
                              backgroundImage: NetworkImage(
                                snap['userProfile'],
                              ),
                            ),
                            Expanded(
                                flex: 1,
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        BuildColum(
                                            num: postLen, title: 'Posts'),
                                        BuildColum(
                                            num: followers, title: 'Followers'),
                                        BuildColum(
                                            num: following,
                                            title: 'Followings'),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                          
                                              isFollowing
                                                ? FollowButton(
                                                    text: 'Unfollow',
                                                    backgroundColor:
                                                        Colors.white,
                                                    textColor: Colors.black,
                                                    borderColor: Colors.grey,
                                                    function: () async {
                                                      await manager
                                                          .followingMethod(
                                                              uid: FirebaseAuth
                                                                  .instance
                                                                  .currentUser!
                                                                  .uid,
                                                              followId:
                                                                  snap['uid']);
                                                      setState(() {
                                                        isFollowing = false;
                                                        followers--;
                                                      });
                                                    },
                                                  )
                                                : FollowButton(
                                                    text: 'Follow',
                                                    backgroundColor:
                                                        Colors.blue,
                                                    textColor: Colors.white,
                                                    borderColor: Colors.blue,
                                                    function: () async {
                                                      await manager
                                                          .followingMethod(
                                                              uid: FirebaseAuth
                                                                  .instance
                                                                  .currentUser!
                                                                  .uid,
                                                              followId:
                                                                  snap['uid']);
                                                      setState(() {
                                                        isFollowing = true;
                                                        followers++;
                                                      });
                                                    },
                                                  ),
                                      ],
                                    )
                                  ],
                                ))
                          ],
                        ),
                        Container(
                          alignment: Alignment.centerLeft,
                          padding: EdgeInsets.only(
                            top: 15.h,
                          ),
                          child: Text(
                            snap['userName'],
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Container(
                          alignment: Alignment.centerLeft,
                          padding: EdgeInsets.only(
                            top: 1.h,
                          ),
                          child: Text(
                            snap['bio'],
                          ),
                        ),
                        const Divider()
                      ]),
                ),
                FutureBuilder(
                  future: FirebaseFirestore.instance
                      .collection('Post')
                      .where('uid',
                          isEqualTo: FirebaseAuth.instance.currentUser!.uid)
                      .get(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    return GridView.builder(
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      physics: const BouncingScrollPhysics(),
                      itemCount: (snapshot.data! as dynamic).docs.length,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 5,
                        mainAxisSpacing: 1.5,
                        childAspectRatio: 1,
                      ),
                      itemBuilder: (context, index) {
                        var snapPost = (snapshot.data! as dynamic).docs[index];
                        return Image(
                          image: NetworkImage(snapPost['postUrl']),
                          fit: BoxFit.cover,
                        );
                      },
                    );
                  },
                )
              ],
            ),
          );
  }

  BuildColum({required int num, required String title}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          num.toString(),
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 4.h),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 15.sp,
              fontWeight: FontWeight.w400,
              color: Colors.grey,
            ),
          ),
        ),
      ],
    );
  }
}
