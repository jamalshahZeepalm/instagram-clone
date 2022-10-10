// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:instagram_clone/Widgets/custom_like_animation.dart';
import 'package:intl/intl.dart';

class CustomCommentCard extends StatefulWidget {
  final snap;
  const CustomCommentCard({Key? key, required this.snap}) : super(key: key);

  @override
  State<CustomCommentCard> createState() => _CustomCommentCardState();
}

class _CustomCommentCardState extends State<CustomCommentCard> {
  bool isAnimating = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 13.h, horizontal: 16.w),
      child: Row(
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage(
              widget.snap['profilePic'],
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: 16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: '${widget.snap['name']} ',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(text: widget.snap['text'])
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 4.h),
                    child: Text(
                      DateFormat.yMMMd()
                          .format(widget.snap['datePublished'].toDate()),
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8),
            child: LikeAnimation(
              myChild: IconButton(
                onPressed: () {
                  setState(() {
                    isAnimating = true;
                  });
                },
                icon: const Icon(
                  Icons.favorite,
                  size: 16,
                ),
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
    );
  }
}
