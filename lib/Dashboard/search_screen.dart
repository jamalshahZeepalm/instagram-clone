import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:instagram_clone/Dashboard/user_screen.dart';
import 'package:instagram_clone/Widgets/custom_title.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController controller = TextEditingController();
  bool isShowingUser = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Padding(
          padding: const EdgeInsets.all(8.0).copyWith(bottom: 0),
          child: TextFormField(
            controller: controller,
            decoration: const InputDecoration(
                border: InputBorder.none, hintText: 'Search for a user'),
            onFieldSubmitted: (String value) {
              if (kDebugMode) {
                print(value);
              }
              setState(() {
                isShowingUser = true;
              });
            },
          ),
        ),
      ),
      body: isShowingUser
          ? FutureBuilder(
              future: FirebaseFirestore.instance
                  .collection('Users')
                  .where(
                    'userName',
                    isEqualTo: controller.text,
                  )
                  .get(),
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
                    return CustomListTile(
                      snap: snapshot.data!.docs[index].data(),
                      tab: () {
                        Get.to(() => FollowingUserScreen(
                            uid: (snapshot.data! as dynamic).docs[index]
                                ['uid']));
                      },
                    );
                  },
                );
              },
            )
          : FutureBuilder(
              future: FirebaseFirestore.instance.collection('Post').get(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return GridView.custom(
                  physics: const BouncingScrollPhysics(),
                  gridDelegate: SliverWovenGridDelegate.count(
                    crossAxisCount: 3,
                    mainAxisSpacing: 7,
                    crossAxisSpacing: 8,
                    pattern: [
                      const WovenGridTile(1),
                      const WovenGridTile(
                        5 / 7,
                      ),
                    ],
                  ),
                  childrenDelegate: SliverChildBuilderDelegate(
                      childCount: snapshot.data!.docs.length, (context, index) {
                    return Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                            image: NetworkImage(
                              snapshot.data!.docs[index]['postUrl'],
                            ),
                            fit: BoxFit.cover),
                      ),
                    );
                  }),
                );
              },
            ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }
}

