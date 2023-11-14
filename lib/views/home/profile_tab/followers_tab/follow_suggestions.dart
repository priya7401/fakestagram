import 'package:fakestagram/providers/user_provider.dart';
import 'package:fakestagram/services/services.dart';
import 'package:fakestagram/utils/global_widgets.dart';
import 'package:fakestagram/views/home/profile_tab/follower_profile_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FollowSuggestions extends StatelessWidget {
  const FollowSuggestions({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(builder: (context, userProvider, child) {
      return ListView(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              'Suggested for you',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          SizedBox(
            height: 15,
          ),
          (userProvider.followSuggestions?.isNotEmpty ?? false)
              ? ListView(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  children: userProvider.followSuggestions?.map((user) {
                        return ListTile(
                          leading: profilePicWidget(
                            radius: 23,
                            s3Url: user.profilePic?.s3Url,
                          ),
                          titleAlignment: ListTileTitleAlignment.center,
                          title: Text(user.username ?? "N/A"),
                          subtitle: Text(user.fullName ?? ""),
                          trailing: SizedBox(
                            // width: 101,
                            width: 70,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                userProvider.isLoading
                                    ? progressIndicator()
                                    : SmallThemeButton(
                                        buttonText: "Follow",
                                        onTap: () {
                                          UserService().followUser(
                                            {"follower_id": user.id},
                                            context,
                                          );
                                        },
                                      ),
                                // SizedBox(
                                //   width: 10,
                                // ),
                                // InkWell(
                                //   onTap: () {},
                                //   child: Icon(
                                //     Icons.close,
                                //     size: 18,
                                //     color: Colors.black,
                                //   ),
                                // )
                              ],
                            ),
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
                      [Text('No suggestions available')],
                )
              : Text('No suggestions available')
        ],
      );
    });
  }
}
