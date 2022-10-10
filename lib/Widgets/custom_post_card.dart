// ignore_for_file: prefer_typing_uninitialized_variables, must_be_immutable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:instagram_clone/Dashboard/comment.dart';
import 'package:instagram_clone/Database%20Services/database_manager.dart';
import 'package:instagram_clone/Model/user_profile.dart';
import 'package:instagram_clone/Providers/user_provider.dart';
import 'package:instagram_clone/Widgets/custom_like_animation.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class CustomPostCards extends StatefulWidget {
  var snap;
  CustomPostCards({Key? key, required this.snap}) : super(key: key);

  @override
  State<CustomPostCards> createState() => _CustomPostCardsState();
}

class _CustomPostCardsState extends State<CustomPostCards> {
  bool isAnimating = false;
  DatabaseManager manager = DatabaseManager();
  int commentlen = 0;

  @override
  void initState() {
    // ignore: todo
    // TODO: implement initState
    super.initState();
    getCommentLenght();
  }

  getCommentLenght() async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('Post')
        .doc(widget.snap['postId'])
        .collection('Comments')
        .get();
    commentlen = snapshot.docs.length;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    UserModel? userModel = Provider.of<UserProvider>(context).getUser;
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 2.w),
      child: Column(children: [
        Container(
          padding: EdgeInsets.symmetric(
            vertical: 4.h,
            horizontal: 6.w,
          ).copyWith(right: 0),
          child: Row(
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(widget.snap['profImage']),
                radius: 16.r,
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(left: 8.w),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.snap['username'],
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              IconButton(
                onPressed: () {
                  showDialog(
                    useRootNavigator: false,
                    context: context,
                    builder: (context) {
                      return Dialog(
                        child: ListView(
                          padding: EdgeInsets.symmetric(
                              vertical: 16.h, horizontal: 16.w),
                          shrinkWrap: true,
                          children: [
                            'Delete',
                          ]
                              .map(
                                (e) => InkWell(
                                  onTap: () {
                                    manager.deletePost(
                                        postId: widget.snap['postId']);
                                    Get.back();
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 12.h, horizontal: 16.w),
                                    child: Text(e),
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                      );
                    },
                  );
                },
                icon: const Icon(
                  Icons.more_vert,
                ),
              )
            ],
          ),
        ),
        GestureDetector(
          onDoubleTap: () {
            manager.likePost(
                postId: widget.snap['postId'],
                likes: widget.snap['likes'],
                uid: userModel!.uid);
            setState(() {
              isAnimating = true;
            });
          },
          child: Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.35,
                width: double.infinity,
                child: Image.network(
                  widget.snap['postUrl'],
                  fit: BoxFit.cover,
                ),
              ),
              AnimatedOpacity(
                opacity: isAnimating ? 1 : 0,
                duration: const Duration(milliseconds: 400),
                child: LikeAnimation(
                  myChild: Icon(
                    Icons.favorite,
                    color: Colors.white,
                    size: 120.sp,
                  ),
                  isAnimating: isAnimating,
                  onEnd: () {
                    setState(() {
                      isAnimating = false;
                    });
                  },
                ),
              )
            ],
          ),
        ),
        Row(
          children: [
            LikeAnimation(
              isAnimating: widget.snap['likes'].contains(userModel!.uid),
              smalLike: true,
              myChild: IconButton(
                onPressed: () {
                  manager.likePost(
                      postId: widget.snap['postId'],
                      likes: widget.snap['likes'],
                      uid: userModel.uid);
                },
                icon: widget.snap['likes'].contains(userModel.uid)
                    ? const Icon(
                        Icons.favorite,
                        color: Colors.red,
                      )
                    : const Icon(
                        Icons.favorite_border,
                        color: Colors.white,
                      ),
              ),
            ),
            IconButton(
              onPressed: () {
                Get.to(() => CommentScreen(
                      snap: widget.snap,
                    ));
              },
              icon: const Icon(
                Icons.comment_outlined,
              ),
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.send,
              ),
            ),
            Expanded(
              child: Align(
                alignment: Alignment.bottomRight,
                child: IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.bookmark_border),
                ),
              ),
            )
          ],
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 15.w),
          child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${widget.snap['likes'].length} Like',
                  style: Theme.of(context).textTheme.bodyText2,
                ),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.only(top: 8.h),
                  child: RichText(
                    text: TextSpan(
                      style: TextStyle(color: CustomColors.primaryColor),
                      children: [
                        TextSpan(
                          text: widget.snap['username'].toString(),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(
                          text: ' ${widget.snap['description']}',
                        ),
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Get.to(
                      () => CommentScreen(snap: widget.snap),
                    );
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 4.h),
                    child: Text(
                      'View all $commentlen comments',
                      style: TextStyle(
                        fontSize: 16,
                        color: CustomColors.secondaryColor,
                      ),
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 4.h),
                  child: Text(
                    DateFormat.yMMMd()
                        .format(widget.snap['datePublished'].toDate()),
                    style: TextStyle(
                      color: CustomColors.secondaryColor,
                    ),
                  ),
                ),
              ]),
        )
      ]),
    );
  }
}
