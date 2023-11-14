import 'package:cached_network_image/cached_network_image.dart';
import 'package:fakestagram/models/post/post.dart';
import 'package:fakestagram/providers/posts_provider.dart';
import 'package:fakestagram/providers/user_provider.dart';
import 'package:fakestagram/utils/global_widgets.dart';
import 'package:fakestagram/views/home/home_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({Key? key}) : super(key: key);

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  @override
  Widget build(BuildContext context) {
    return Consumer2<UserProvider, PostsProvider>(
        builder: (context, userProvider, postProvider, child) {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          centerTitle: false,
          title: !userProvider.isLoading
              ? Text(
                  userProvider.follower?.username ?? "N/A",
                  style: TextStyle(fontSize: 17),
                  textAlign: TextAlign.center,
                )
              : Container(),
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
          ],
        ),
        body: SafeArea(
          child: Stack(
            children: [
              ListView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      profilePicWidget(
                        s3Url: userProvider.follower?.profilePic?.s3Url,
                        radius: 30,
                      ),
                      Column(
                        children: [
                          Text(
                            postProvider.followerPosts?.length.toString() ??
                                "0",
                            style: TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 16),
                          ),
                          Text('Posts')
                        ],
                      ),
                      InkWell(
                        onTap: () {
                          // UserService().followersList(context);
                          // UserService().followSuggestionsList(context);
                          // Navigator.of(context).push(MaterialPageRoute(
                          //     builder: (context) => FollowersFollowingPage(
                          //           tabIndex: 0,
                          //         )));
                        },
                        child: Column(
                          children: [
                            Text(
                              "${userProvider.follower?.followers?.length ?? 0}",
                              style: TextStyle(
                                  fontWeight: FontWeight.w600, fontSize: 16),
                            ),
                            Text('Followers')
                          ],
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          // UserService().followingList(context);
                          // Navigator.of(context).push(MaterialPageRoute(
                          //     builder: (context) => FollowersFollowingPage(
                          //           tabIndex: 1,
                          //         )));
                        },
                        child: Column(
                          children: [
                            Text(
                              "${userProvider.follower?.following?.length ?? 0}",
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
                    height: 10,
                  ),
                  Text(
                    userProvider.follower?.fullName ?? "N/A",
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    userProvider.follower?.bio ?? "",
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  userProvider.isLoading == false &&
                          userProvider.follower?.isPublic == false
                      ? Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Center(
                            child: Text(
                                'This account is private. Follow user to see posts'),
                          ),
                        )
                      : Container(),
                  postProvider.isLoading
                      ? progressIndicator()
                      : (postProvider.followerPosts?.isNotEmpty ?? false)
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
                              children: postProvider.followerPosts
                                      ?.map((Post post) {
                                    return post.attachment?.s3Url != null
                                        ? InkWell(
                                            onTap: () {
                                              // Navigator.of(context).push(
                                              //     MaterialPageRoute(
                                              //         builder: (context) =>
                                              //             ProfilePostsDetailView()));
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
                          : Container(),
                ],
              ),
              userProvider.isLoading
                  ? Center(
                      child: progressIndicator(),
                    )
                  : Container()
            ],
          ),
        ),
      );
    });
  }
}
