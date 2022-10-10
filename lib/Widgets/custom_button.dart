
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:instagram_clone/utils/colors.dart';

class CustomButton extends StatelessWidget {
  final VoidCallback onClick;
  final Widget myWidget;
  const CustomButton({Key? key, required this.onClick, required this.myWidget})
      : super(
          key: key,
        );

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onClick,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12.h),
        decoration: ShapeDecoration(
            color: CustomColors.blueColor,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4.r))),
        alignment: Alignment.center,
        width: double.infinity,
        child: myWidget,
      ),
    );
  }
}
