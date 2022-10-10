import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_clone/Database%20Services/auth_services.dart';
import 'package:instagram_clone/Database%20Services/database_manager.dart';
import 'package:instagram_clone/Model/test.dart';

import 'utils/utils.dart';

class TestPage extends StatefulWidget {
  const TestPage({super.key});

  @override
  State<TestPage> createState() => _TestPageState();
}

Uint8List? _image;
List<String> listOfImages = [];
List<String> listOfName = [];
TextEditingController nameEditingController = TextEditingController();
AuthServices authServices = AuthServices();

class _TestPageState extends State<TestPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
            SizedBox(
              height: 12.h,
            ),
            Stack(
              alignment: Alignment.center,
              children: [
                _image != null
                    ? CircleAvatar(
                        radius: 64.r,
                        backgroundImage: MemoryImage(_image!),
                      )
                    : CircleAvatar(
                        radius: 64.r,
                        backgroundImage: const NetworkImage(
                          'https://www.pngitem.com/pimgs/m/35-350426_profile-icon-png-default-profile-picture-png-transparent.png',
                          scale: 1.0,
                        ),
                      ),
                Positioned(
                  bottom: -5,
                  left: 70,
                  child: IconButton(
                    onPressed: selectImage,
                    icon: const Icon(Icons.add_a_photo),
                  ),
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                cursorColor: Colors.amber,
                controller: nameEditingController,
                decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(),
                    fillColor: Colors.black12,
                    filled: true),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                String image =
                    await DatabaseManager.imageStorages(file: _image!);
                //store into List
                listOfImages.add(image);
                listOfName.add(nameEditingController.text);


                 //printing  the lenght
                log(listOfImages.length.toString());
                log('name: ${listOfName.length.toString()}');


                // just messages
                Get.snackbar('Teacher Image Added into List',
                    'Lenght : ${listOfImages.length.toString()}',
                    snackPosition: SnackPosition.BOTTOM,
                    colorText: Colors.blueAccent);

                Get.snackbar('Teacher Name Added into List',
                    'Lenght : ${listOfName.length.toString()}',
                    snackPosition: SnackPosition.BOTTOM,
                    colorText: Colors.blueAccent);

                nameEditingController.clear();

                setState(() {
                  _image = null;
                });
              },
              child: Text('save to List'),
            ),
            ElevatedButton(
              onPressed: () {
                Test test = Test(imagesUrl: listOfImages, userName: listOfName);
                authServices.simpleStore(test: test);
                listOfImages.clear();
                listOfName.clear();
                Get.snackbar('FireStore', 'Succfully store to FireStore',
                    snackPosition: SnackPosition.BOTTOM,
                    colorText: Colors.blueAccent);
              },
              child: Text('save to firestore and storage'),
            )
          ]),
        ),
      ),
    );
  }

  Future selectImage() async {
    Uint8List getImage = await pickerImages(ImageSource.gallery);
    setState(() {
      _image = getImage;
    });
  }
}
