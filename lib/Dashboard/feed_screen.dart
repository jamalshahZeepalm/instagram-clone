import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:instagram_clone/Widgets/custom_post_card.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:instagram_clone/utils/global_variable.dart';
import 'package:instagram_clone/utils/images_path.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  @override
  Widget build(BuildContext context) {
    final wdith = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: wdith > webScreenSize
          ? CustomColors.webBackgroundColor
          : CustomColors.mobileBackgroundColor,
      appBar: wdith > webScreenSize
          ? null
          : AppBar(
              backgroundColor: CustomColors.mobileBackgroundColor,
              title: SvgPicture.asset(
                CustomAssets.kInstagramLogo,
                color: Colors.white,
                height: 32.h,
              ),
              actions: [
                InkWell(
                  onTap: () {},
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SvgPicture.asset(
                      CustomAssets.kMessenger,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('Post').snapshots(),
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
              return Container(
                margin: EdgeInsets.symmetric(
                    horizontal: wdith > webScreenSize ? wdith * 0.3 : 0,
                    vertical: wdith > webScreenSize ? 15 : 0),
                child: CustomPostCards(
                  snap: (snapshot.data as dynamic).docs[index].data(),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
