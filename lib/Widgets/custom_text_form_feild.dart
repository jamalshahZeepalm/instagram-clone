import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomTextFormFeild extends StatelessWidget {
  const CustomTextFormFeild(
      {super.key,
      required this.textInputType,
      required this.validator,
      required this.onChange,
      required this.hintText,
      this.isPass = false,
      required this.textEditingController});
  final TextEditingController textEditingController;
  final bool isPass;
  final String hintText;
final TextInputType textInputType;
  final String? Function(String?)? validator;
  final void Function(String)? onChange;
  @override
  Widget build(BuildContext context) {
    final inputBorder =
        OutlineInputBorder(borderSide: Divider.createBorderSide(context));
    return TextFormField(
      keyboardType: textInputType,
      controller: textEditingController,
      obscureText: isPass,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(horizontal: 8.w),
        border: inputBorder,
        focusedBorder: inputBorder,
        enabledBorder: inputBorder,
        filled: true,
        hintText: hintText,
      ),
      validator: validator,
      onChanged: onChange,
    );
  }
}
