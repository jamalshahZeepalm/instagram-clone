import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:instagram_clone/utils/global_variable.dart';

class MobileScreenLayout extends StatefulWidget {
  const MobileScreenLayout({super.key});

  @override
  State<MobileScreenLayout> createState() => _MobileScreenLayoutState();
}

class _MobileScreenLayoutState extends State<MobileScreenLayout> {
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

  @override
  void dispose() {
    // ignore: todo
    // TODO: implement dispose
    super.dispose();
    pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: PageView(
          physics: const NeverScrollableScrollPhysics(),
          controller: pageController,
          onPageChanged: onChanges,
          children: listOfpages,
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: CupertinoTabBar(
          backgroundColor: CustomColors.mobileBackgroundColor,
          items: [
            BottomNavigationBarItem(
              icon: Icon(
                Icons.home,
                color: _page == 0
                    ? CustomColors.primaryColor
                    : CustomColors.secondaryColor,
              ),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.search,
                color: _page == 1
                    ? CustomColors.primaryColor
                    : CustomColors.secondaryColor,
              ),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.add_circle,
                color: _page == 2
                    ? CustomColors.primaryColor
                    : CustomColors.secondaryColor,
              ),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.favorite,
                color: _page == 3
                    ? CustomColors.primaryColor
                    : CustomColors.secondaryColor,
              ),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.person,
                color: _page == 4
                    ? CustomColors.primaryColor
                    : CustomColors.secondaryColor,
              ),
              label: '',
            )
          ],
          onTap: navTab,
        ),
      ),
    );
  }

  navTab(int page) {
    pageController.jumpToPage(page);
  }
}
