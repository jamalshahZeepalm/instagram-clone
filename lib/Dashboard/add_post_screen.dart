import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_clone/Database%20Services/database_manager.dart';
import 'package:instagram_clone/Model/user_profile.dart';
import 'package:instagram_clone/Providers/user_provider.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:instagram_clone/utils/utils.dart';
import 'package:provider/provider.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({super.key});

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  Uint8List? _file;
  UserModel? user;
  bool isLoading = false;
  TextEditingController discription = TextEditingController();
  DatabaseManager databaseManager = DatabaseManager();

  @override
  Widget build(BuildContext context) {
    user = Provider.of<UserProvider>(context).getUser;
    return _file == null
        ? Center(
            child: Container(
              decoration: ShapeDecoration(
                  color: CustomColors.primaryColor,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(45))),
              child: IconButton(
                onPressed: () => showSimpleDailogs(context),
                icon: Icon(
                  Icons.upload_rounded,
                  color: CustomColors.secondaryColor,
                ),
              ),
            ),
          )
        : Scaffold(
            appBar: AppBar(
              elevation: 0,
              backgroundColor: Colors.transparent,
              leading: IconButton(
                onPressed: () => clearImage(),
                icon: const Icon(
                  Icons.arrow_back,
                ),
              ),
              title: const Text('Post to'),
              actions: [
                Padding(
                  padding: EdgeInsets.only(right: 20.w),
                  child: TextButton(
                      onPressed: () => addPost(),
                      child: Text(
                        'Post',
                        style: TextStyle(
                          fontSize: 15.sp,
                          color: CustomColors.blueColor,
                        ),
                      )),
                )
              ],
            ),
            body: Column(children: [
              isLoading
                  ? LinearProgressIndicator(
                      color: CustomColors.blueColor,
                    )
                  : Padding(
                      padding: EdgeInsets.only(top: 0.h),
                    ),
              const Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(
                      user!.userProfile,
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.42,
                    child: TextField(
                      maxLines: 8,
                      controller: discription,
                      decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: 'write a caption....'),
                    ),
                  ),
                  SizedBox(
                    height: 45.h,
                    width: 45.w,
                    child: AspectRatio(
                      aspectRatio: 487.451,
                      child: Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                              image: MemoryImage(_file!),
                              fit: BoxFit.fill,
                              alignment: FractionalOffset.topCenter),
                        ),
                      ),
                    ),
                  )
                ],
              )
            ]),
          );
  }

  void showSimpleDailogs(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          title: const Text('Create a Post'),
          children: [
            SimpleDialogOption(
              padding: const EdgeInsets.all(20).copyWith(left: 30.w),
              child: const Text('Take a Photo'),
              onPressed: () async {
                Get.back();
                Uint8List file = await pickerImages(ImageSource.camera);
                setState(() {
                  _file = file;
                });
              },
            ),
            SimpleDialogOption(
              padding: const EdgeInsets.all(20),
              child: const Text('Choose From Gallery'),
              onPressed: () async {
                Get.back();
                Uint8List file = await pickerImages(ImageSource.gallery);
                setState(() {
                  _file = file;
                });
              },
            ),
            SimpleDialogOption(
              padding: const EdgeInsets.all(20),
              child: const Text('Cancel'),
              onPressed: () {
                Get.back();
              },
            )
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    discription.dispose();
  }

  clearImage() {
    setState(() {
      _file = null;
    });
  }

  addPost() async {
    setState(() {
      isLoading = true;
    });
    String res = await databaseManager.uploadPost(
      description: discription.text,
      file: _file!,
      uid: user!.uid,
      username: user!.userName,
      profImage: user!.userProfile,
    );
    if (res == 'success') {
      Get.snackbar(
        'Posted!',
        'post Successfully',
        snackPosition: SnackPosition.TOP,
      );
      setState(() {
        isLoading = false;
      });
      clearImage();
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }
}
