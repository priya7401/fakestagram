import 'package:fakestagram/providers/user_provider.dart';
import 'package:fakestagram/services/services.dart';
import 'package:fakestagram/utils/global_widgets.dart';
import 'package:fakestagram/views/home/profile_tab/follower_profile_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FollowingPage extends StatelessWidget {
  const FollowingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(builder: (context, userProvider, child) {
      return userProvider.isLoading
          ? progressIndicator()
          : (userProvider.following?.isNotEmpty ?? false)
              ? ListView(
                  shrinkWrap: true,
                  padding: EdgeInsets.symmetric(vertical: 10),
                  children: userProvider.following?.map((user) {
                        return ListTile(
                          leading: profilePicWidget(
                            radius: 23,
                            s3Url: userProvider.user?.profilePic?.s3Url,
                          ),
                          title: Text(user.username ?? "N/A"),
                          trailing: ElevatedButton(
                            child: Text('Following'),
                            onPressed: () async {
                              await showAdaptiveDialog(
                                  context: context,
                                  builder: (dialogContext) {
                                    return AlertDialog.adaptive(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(16),
                                        ),
                                      ),
                                      scrollable: true,
                                      content: Column(
                                        children: [
                                          profilePicWidget(
                                              radius: 23,
                                              s3Url: userProvider
                                                  .user?.profilePic?.s3Url),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Text(
                                              "If you change your mind, you'll have to reqeuest to follow ${user.username} again."),
                                        ],
                                      ),
                                      actionsAlignment:
                                          MainAxisAlignment.center,
                                      actions: [
                                        Column(
                                          children: [
                                            TextButton(
                                                onPressed: () {
                                                  UserService().unfollowUser(
                                                      {"follower_id": user.id},
                                                      context);
                                                  Navigator.of(context).pop();
                                                },
                                                child: Text(
                                                  'Unfollow',
                                                  style: TextStyle(
                                                    color: Colors.red,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                )),
                                            TextButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                                child: Text(
                                                  'Cancel',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                )),
                                          ],
                                        ),
                                      ],
                                    );
                                  });
                            },
                          ),
                          onTap: () {
                            UserService()
                                .getUserDetails(context, followerId: user.id);
                            PostService()
                                .getPosts(context, followerId: user.id);
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => ProfileView()));
                          },
                        );
                      }).toList() ??
                      [],
                )
              : Container(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Text(
                    'You are not following anyone!',
                    textAlign: TextAlign.center,
                  ),
                );
    });
  }
}
