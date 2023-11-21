import 'package:fakestagram/providers/providers.dart';
import 'package:fakestagram/services/services.dart';
import 'package:fakestagram/utils/app_constants.dart';
import 'package:fakestagram/views/home/add_post_tab/add_post.dart';
import 'package:fakestagram/views/home/profile_tab/post_detail_view.dart';
import 'package:fakestagram/views/home/profile_tab/profile_tab_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  final int page;
  const HomePage({Key? key, this.page = 0}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _page = 0;
  PageController pageController = PageController();

  @override
  void initState() {
    _page = widget.page;
    pageController = PageController(initialPage: widget.page);
    super.initState();
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<AppProvider, PostsProvider>(
        builder: (context, appProvider, postProvider, child) {
      return Scaffold(
        body: PageView(
          physics: const NeverScrollableScrollPhysics(),
          controller: pageController,
          onPageChanged: (int page) {
            appProvider.setPrevTabPage(_page);
            setState(() {
              _page = page;
            });
          },
          children: [
            PostsDetailView(
              posts: postProvider.feed,
              isUserPosts: false,
            ),
            Text('search screen'),
            AddPost(),
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
                color:
                    _page == 0 ? AppConstants.primaryColor : Colors.grey[500],
              ),
              label: '',
              backgroundColor: AppConstants.primaryColor,
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.search,
                color:
                    _page == 1 ? AppConstants.primaryColor : Colors.grey[500],
              ),
              label: '',
              backgroundColor: AppConstants.primaryColor,
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.add_circle,
                color:
                    _page == 2 ? AppConstants.primaryColor : Colors.grey[500],
              ),
              label: '',
              backgroundColor: AppConstants.primaryColor,
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.slow_motion_video_sharp,
                color:
                    _page == 3 ? AppConstants.primaryColor : Colors.grey[500],
              ),
              label: '',
              backgroundColor: AppConstants.primaryColor,
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.person,
                color:
                    _page == 4 ? AppConstants.primaryColor : Colors.grey[500],
              ),
              label: '',
              backgroundColor: AppConstants.primaryColor,
            ),
          ],
          onTap: (int page) {
            pageController.jumpToPage(page);
            if (page == 4) {
              PostService().getPosts(context);
            } else if (page == 0) {
              PostService().getFeed(context);
            }
          },
        ),
      );
    });
  }
}
