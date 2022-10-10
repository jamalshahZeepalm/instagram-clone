import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_clone/Database%20Services/auth_services.dart';
import 'package:instagram_clone/Auth%20UI/login_page.dart';
import 'package:instagram_clone/Model/user_profile.dart';
import 'package:instagram_clone/Responsive/mobile_screen_layout.dart';
import 'package:instagram_clone/Responsive/responsive_layout.dart';
import 'package:instagram_clone/Responsive/web_screen_layout.dart';
import 'package:instagram_clone/Widgets/custom_text_form_feild.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:instagram_clone/utils/images_path.dart';
import 'package:instagram_clone/utils/typography.dart';
import 'package:instagram_clone/utils/utils.dart';

import '../Widgets/custom_button.dart';
import '../utils/global_variable.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _emailEditingController = TextEditingController();
  final TextEditingController _passwordEditingController =
      TextEditingController();
  final TextEditingController _userNameEditingController =
      TextEditingController();
  final TextEditingController _bioEditingController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final AuthServices authServices = AuthServices();
  Uint8List? _image;
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    final wdith = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          alignment: Alignment.center,
          padding: wdith > webScreenSize
              ? EdgeInsets.symmetric(horizontal: wdith / 3)
              : EdgeInsets.symmetric(horizontal: 32.w),
          width: double.infinity.w,
          child: Form(
            key: formKey,
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 70.h,
                  ),
                  SvgPicture.asset(
                    CustomAssets.kInstagramLogo,
                    color: CustomColors.primaryColor,
                  ),
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
                        bottom: -10,
                        left: 80,
                        child: IconButton(
                          onPressed: selectImage,
                          icon: const Icon(Icons.add_a_photo),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 24.h,
                  ),
                  CustomTextFormFeild(
                      validator: (val) {
                        if (val!.isEmpty) {
                          return "This field can't be empty";
                        }
                        return null;
                      },
                      onChange: (v) {},
                      textInputType: TextInputType.text,
                      hintText: 'enter your user-name',
                      textEditingController: _userNameEditingController),
                  SizedBox(
                    height: 24.h,
                  ),
                  CustomTextFormFeild(
                      validator: (val) {
                        if (val!.isEmpty) {
                          return "This field can't be empty";
                        }
                        return null;
                      },
                      onChange: (v) {},
                      hintText: 'enter your Bio',
                      textInputType: TextInputType.text,
                      textEditingController: _bioEditingController),
                  SizedBox(
                    height: 24.h,
                  ),
                  CustomTextFormFeild(
                      validator: (val) {
                        if (val!.isEmpty) {
                          return "This field can't be empty";
                        }
                        return null;
                      },
                      onChange: (v) {},
                      textInputType: TextInputType.emailAddress,
                      hintText: 'enter your email',
                      textEditingController: _emailEditingController),
                  SizedBox(
                    height: 24.h,
                  ),
                  CustomTextFormFeild(
                      isPass: true,
                      textInputType: TextInputType.text,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "This field can't be empty";
                        }
                        return null;
                      },
                      onChange: (v) {},
                      hintText: 'enter your password',
                      textEditingController: _passwordEditingController),
                  SizedBox(
                    height: 24.h,
                  ),
                  CustomButton(
                    onClick: () async {
                      if (formKey.currentState!.validate()) {
                        userSignup();
                      }
                    },
                    myWidget: isLoading
                        ? CircularProgressIndicator(
                            color: CustomColors.primaryColor,
                          )
                        : const Text('Sign Up'),
                  ),
                  SizedBox(
                    height: 64.h,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(vertical: 12.h),
                        child: const Text("Have an Account?"),
                      ),
                      SizedBox(
                        width: 2.w,
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(vertical: 12.h),
                        child: InkWell(
                          onTap: () {
                            Get.to(() => const LoginScreen());
                          },
                          child: Text(
                            ' Login',
                            style: CustomTextStyle.kBold,
                          ),
                        ),
                      )
                    ],
                  )
                ]),
          ),
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

  @override
  void dispose() {
    super.dispose();
    _emailEditingController.dispose();
    _passwordEditingController.dispose();
  }

  void userSignup() async {
    setState(() {
      isLoading = true;
    });
    UserModel userModel = UserModel(
      uid: '',
      userName: _userNameEditingController.text,
      email: _emailEditingController.text,
      bio: _bioEditingController.text,
      follower: [],
      following: [],
      userProfile: '',
    );
    String res = await authServices.signUpUser(
      file: _image!,
      userModel: userModel,
      password: _passwordEditingController.text,
    );

    if (res == 'success') {
      Get.offAll(
        () => const ResponsiveLayout(
          mobileScreenLayout: MobileScreenLayout(),
          webScreenLayout: WebScreenLayout(),
        ),
      );
      Get.snackbar(
        'Account Creation',
        'User Signup Successfully',
        snackPosition: SnackPosition.TOP,
      );
      setState(() {
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
      Get.snackbar(
        'Account Creation',
        'User Signup Feild',
        titleText: Text(res.toString()),
        snackPosition: SnackPosition.TOP,
      );
    }
  }
}
