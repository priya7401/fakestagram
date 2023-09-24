import 'package:fakestagram/utils/app_constants.dart';
import 'package:fakestagram/views/home/home_tab/home_tab_page.dart';
import 'package:fakestagram/views/home/profile_tab/profile_tab_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _page = 0;

  final PageController pageController = PageController();

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        physics: const NeverScrollableScrollPhysics(),
        controller: pageController,
        onPageChanged: (int page) {
          setState(() {
            _page = page;
          });
        },
        children: const [
          // const Text('feed screen'),
          HomeTabPage(),
          Text('search screen'),
          Text('add post screen'),
          Text('reels screen'),
          ProfileTabPage()
        ],
      ),
      bottomNavigationBar: CupertinoTabBar(
        backgroundColor: Colors.white,
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
              color: _page == 0 ? AppConstants.primaryColor : Colors.grey[500],
            ),
            label: '',
            backgroundColor: AppConstants.primaryColor,
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.search,
              color: _page == 1 ? AppConstants.primaryColor : Colors.grey[500],
            ),
            label: '',
            backgroundColor: AppConstants.primaryColor,
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.add_circle,
              color: _page == 2 ? AppConstants.primaryColor : Colors.grey[500],
            ),
            label: '',
            backgroundColor: AppConstants.primaryColor,
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.slow_motion_video_sharp,
              color: _page == 3 ? AppConstants.primaryColor : Colors.grey[500],
            ),
            label: '',
            backgroundColor: AppConstants.primaryColor,
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.person,
              color: _page == 4 ? AppConstants.primaryColor : Colors.grey[500],
            ),
            label: '',
            backgroundColor: AppConstants.primaryColor,
          ),
        ],
        onTap: (int page) {
          pageController.jumpToPage(page);
          if(page == 3) {

          }
        },
      ),
    );
  }
}
