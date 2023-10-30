import 'package:fakestagram/providers/user_provider.dart';
import 'package:fakestagram/views/home/profile_tab/followers_tab/followers_page.dart';
import 'package:fakestagram/views/home/profile_tab/following_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FollowersFollowingPage extends StatelessWidget {
  final int? tabIndex;
  const FollowersFollowingPage({super.key, this.tabIndex});

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(builder: (context, userProvider, child) {
      return DefaultTabController(
        length: 2,
        initialIndex: tabIndex ?? 0,
        child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text(
              userProvider.user?.username ?? "N/A",
              style: TextStyle(fontSize: 17),
              textAlign: TextAlign.center,
            ),
            leading: IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: Icon(Icons.arrow_back),
            ),
            bottom: TabBar(
              indicatorColor: Colors.pink[100],
              tabs: [
                Tab(
                  text:
                      '${userProvider.user?.followers?.length ?? 0} followers',
                ),
                Tab(
                  text:
                      '${userProvider.user?.following?.length ?? 0} following',
                ),
              ],
            ),
          ),
          body: SafeArea(
            child: TabBarView(
              children: const [
                FollowersTab(),
                FollowingPage(),
              ],
            ),
          ),
        ),
      );
    });
  }
}
