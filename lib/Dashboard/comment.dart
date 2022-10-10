// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:instagram_clone/Database%20Services/database_manager.dart';
import 'package:instagram_clone/Widgets/custom_comment_card.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:provider/provider.dart';

import '../Model/user_profile.dart';
import '../Providers/user_provider.dart';

class CommentScreen extends StatefulWidget {
  final snap;
  const CommentScreen({super.key, required this.snap});

  @override
  State<CommentScreen> createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  TextEditingController controller = TextEditingController();
  DatabaseManager manager = DatabaseManager();
  @override
  void dispose() {
    // ignore: todo
    // TODO: implement dispose
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    UserModel? userModel = Provider.of<UserProvider>(context).getUser;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              onPressed: () {
                Get.back();
              },
              icon: const Icon(
                Icons.arrow_back_ios,
              ),
            ),
            const Text('Comments'),
            const Expanded(child: SizedBox())
          ],
        ),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('Post')
            .doc(widget.snap['postId'])
            .collection('Comments')
            .orderBy('datePublished', descending: true)
            .snapshots(),
        builder: (context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              return CustomCommentCard(
                snap: snapshot.data!.docs[index].data(),
              );
            },
          );
        },
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          height: kToolbarHeight,
          margin:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          padding: EdgeInsets.only(left: 16.w, right: 8.w),
          child: Row(
            children: [
              CircleAvatar(
                  backgroundImage: NetworkImage(
                    userModel!.userProfile,
                  ),
                  radius: 18.r),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(left: 16.w, right: 8.w),
                  child: TextField(
                    controller: controller,
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Comment as ${userModel.userName}'),
                  ),
                ),
              ),
              TextButton(
                onPressed: () async {
                  await manager.commentPost(
                    postId: widget.snap['postId'],
                    name: userModel.userName,
                    text: controller.text,
                    uid: userModel.uid,
                    profilePic: userModel.userProfile,
                  );
                  Get.back();
                },
                child: Text(
                  'Post',
                  style: TextStyle(
                    fontSize: 15.sp,
                    color: CustomColors.blueColor,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
