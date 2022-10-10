import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:instagram_clone/utils/images_path.dart';

import '../utils/global_variable.dart';

class WebScreenLayout extends StatefulWidget {
  const WebScreenLayout({super.key});

  @override
  State<WebScreenLayout> createState() => _WebScreenLayoutState();
}

class _WebScreenLayoutState extends State<WebScreenLayout> {
  int _page = 0;
  late PageController pageController;
  @override
  void initState() {
    // ignore: todo
    // TODO: implement initState
    super.initState();
    pageController = PageController();
  }

  onChanges(int page) {
    setState(() {
      _page = page;
    });
  }

  navTab(int page) {
    pageController.jumpToPage(page);
    setState(() {
      _page = page;
    });
  }

  @override
  void dispose() {
    // ignore: todo
    // TODO: implement dispose
    super.dispose();
    pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final wdith = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(
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
            IconButton(
              onPressed: () => navTab(0),
              icon: Icon(
                Icons.home,
                color: _page == 0
                    ? CustomColors.primaryColor
                    : CustomColors.secondaryColor,
              ),
            ),
            IconButton(
              onPressed: () => navTab(1),
              icon: Icon(
                Icons.search,
                color: _page == 1
                    ? CustomColors.primaryColor
                    : CustomColors.secondaryColor,
              ),
            ),
            IconButton(
              onPressed: () => navTab(2),
              icon: Icon(
                Icons.add_a_photo,
                color: _page == 2
                    ? CustomColors.primaryColor
                    : CustomColors.secondaryColor,
              ),
            ),
            IconButton(
              onPressed: () => navTab(3),
              icon: Icon(
                Icons.favorite,
                color: _page == 3
                    ? CustomColors.primaryColor
                    : CustomColors.secondaryColor,
              ),
            ),
            IconButton(
              onPressed: () => navTab(4),
              icon: Icon(
                Icons.person,
                color: _page == 4
                    ? CustomColors.primaryColor
                    : CustomColors.secondaryColor,
              ),
            ),
          ],
        ),
        body: PageView(
          physics: const NeverScrollableScrollPhysics(),
          controller: pageController,
          onPageChanged: onChanges,
          children: listOfpages,
        ));
  }
}
