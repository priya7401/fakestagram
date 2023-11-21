import 'package:cached_network_image/cached_network_image.dart';
import 'package:fakestagram/models/post/post.dart';
import 'package:fakestagram/providers/providers.dart';
import 'package:fakestagram/services/services.dart';
import 'package:fakestagram/utils/app_constants.dart';
import 'package:fakestagram/utils/global_widgets.dart';
import 'package:fakestagram/views/auth/sign_in.dart';
import 'package:fakestagram/views/home/home_page.dart';
import 'package:fakestagram/views/home/profile_tab/edit_profile.dart';
import 'package:fakestagram/views/home/profile_tab/post_detail_view.dart';
import 'package:fakestagram/views/home/profile_tab/followers_following_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileTabPage extends StatefulWidget {
  const ProfileTabPage({Key? key}) : super(key: key);

  @override
  State<ProfileTabPage> createState() => _ProfileTabPageState();
}

class _ProfileTabPageState extends State<ProfileTabPage> {
  @override
  Widget build(BuildContext context) {
    return Consumer3<UserProvider, PostsProvider, AppProvider>(
        builder: (context, userProvider, postProvider, appProvider, child) {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          centerTitle: false,
          title: Text(
            userProvider.user?.username ?? "N/A",
            style: TextStyle(fontSize: 17),
            textAlign: TextAlign.center,
          ),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                        builder: (context) => HomePage(
                              page: 2,
                            )),
                    (route) => false);
              },
              icon: const Icon(Icons.add_box_outlined),
            ),
            IconButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => EditProfile(
                          user: userProvider.user,
                        )));
              },
              icon: Icon(Icons.menu_rounded),
            ),
            IconButton(
              onPressed: () {
                AuthService().logout(context);
                if (appProvider.currScreen != AppScreens.singIn.name) {
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) => SignIn()),
                      (route) => false);
                  appProvider.setCurrScreen(AppScreens.singIn.name);
                }
              },
              icon: Icon(Icons.logout_rounded),
            )
          ],
        ),
        body: SafeArea(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  profilePicWidget(
                    s3Url: userProvider.user?.profilePic?.s3Url,
                    radius: 30,
                  ),
                  Column(
                    children: [
                      Text(
                        postProvider.posts?.length.toString() ?? "0",
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 16),
                      ),
                      Text('Posts')
                    ],
                  ),
                  InkWell(
                    onTap: () {
                      UserService().followersList(context);
                      UserService().followSuggestionsList(context);
                      UserService().followingList(context);
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => FollowersFollowingPage(
                                tabIndex: 0,
                              )));
                    },
                    child: Column(
                      children: [
                        Text(
                          "${userProvider.user?.followers?.length ?? 0}",
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 16),
                        ),
                        Text('Followers')
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      UserService().followingList(context);
                      UserService().followersList(context);
                      UserService().followSuggestionsList(context);
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => FollowersFollowingPage(
                                tabIndex: 1,
                              )));
                    },
                    child: Column(
                      children: [
                        Text(
                          "${userProvider.user?.following?.length ?? 0}",
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 16),
                        ),
                        Text('following')
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                userProvider.user?.fullName ?? "N/A",
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
              ),
              SizedBox(
                height: 10,
              ),
              Text(userProvider.user?.bio ?? "N/A"),
              SizedBox(
                height: 15,
              ),
              postProvider.isLoading
                  ? progressIndicator()
                  : (postProvider.posts?.isNotEmpty ?? false)
                      ? GridView(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: 3,
                            mainAxisSpacing: 3,
                            childAspectRatio: 1,
                          ),
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          children: postProvider.posts?.map((Post post) {
                                return post.attachment?.s3Url != null
                                    ? InkWell(
                                        onTap: () {
                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      PostsDetailView(
                                                        posts:
                                                            postProvider.posts,
                                                        isUserPosts: true,
                                                      )));
                                        },
                                        child: Image(
                                          image: CachedNetworkImageProvider(
                                              post.attachment?.s3Url ?? ""),
                                          fit: BoxFit.cover,
                                        ),
                                      )
                                    : Text('Image not available');
                              }).toList() ??
                              [],
                        )
                      : Center(
                          child: Text('No posts yet!'),
                        ),
            ],
          ),
        ),
      );
    });
  }
}
