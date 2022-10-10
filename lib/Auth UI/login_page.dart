import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:instagram_clone/Auth%20UI/signup_page.dart';
import 'package:instagram_clone/Responsive/mobile_screen_layout.dart';
import 'package:instagram_clone/Responsive/responsive_layout.dart';
import 'package:instagram_clone/Responsive/web_screen_layout.dart';
import 'package:instagram_clone/Widgets/custom_text_form_feild.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:instagram_clone/utils/global_variable.dart';
import 'package:instagram_clone/utils/images_path.dart';
import 'package:instagram_clone/utils/typography.dart';

import '../Database Services/auth_services.dart';
import '../Widgets/custom_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailEditingController = TextEditingController();
  final TextEditingController _passwordEditingController =
      TextEditingController();
  final formKey = GlobalKey<FormState>();
  final AuthServices authServices = AuthServices();
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    final wdith = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        padding: wdith > webScreenSize
            ? EdgeInsets.symmetric(horizontal: wdith / 3)
            : EdgeInsets.symmetric(horizontal: 32.w),
        width: double.infinity.w,
        child: Form(
          key: formKey,
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
            Flexible(
              flex: 2,
              child: Container(),
            ),
            SvgPicture.asset(
              CustomAssets.kInstagramLogo,
              color: CustomColors.primaryColor,
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
                textInputType: TextInputType.emailAddress,
                onChange: (v) {},
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
                  login();
                }
              },
              myWidget: isLoading
                  ? CircularProgressIndicator(
                      color: CustomColors.primaryColor,
                    )
                  : const Text('Login'),
            ),
            SizedBox(
              height: 12.h,
            ),
            Flexible(
              flex: 1,
              child: Container(),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(vertical: 12.h),
                  child: const Text("Don't have an Account?"),
                ),
                SizedBox(
                  width: 2.w,
                ),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 12.h),
                  child: InkWell(
                    onTap: () {
                      Get.to(() => const SignUpScreen());
                    },
                    child: Text(
                      ' SignUp',
                      style: CustomTextStyle.kBold,
                    ),
                  ),
                )
              ],
            )
          ]),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _emailEditingController.dispose();
    _passwordEditingController.dispose();
  }

  Future login() async {
    setState(() {
      isLoading = true;
    });
    String res = await authServices.loginUser(
      email: _emailEditingController.text,
      password: _passwordEditingController.text,
    );
    if (res == 'success') {
      Get.snackbar(
        'Account Creation',
        'User Siging Successfully',
        snackPosition: SnackPosition.TOP,
      );
      Get.offAll(
        () => const ResponsiveLayout(
          mobileScreenLayout: MobileScreenLayout(),
          webScreenLayout: WebScreenLayout(),
        ),
      );
    } else {
      if (kDebugMode) {
        print(res);
      }
      if (kDebugMode) {
        print('something error');
      }
      setState(() {
        isLoading = false;
      });
    }
  }
}
