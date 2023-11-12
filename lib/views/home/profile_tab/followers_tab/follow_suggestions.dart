import 'package:cached_network_image/cached_network_image.dart';
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
                          leading: CircleAvatar(
                            radius: 30,
                            backgroundImage:
                                CachedNetworkImageProvider(profilePicUrl),
                          ),
                          title: Text(user.username ?? "N/A"),
                          subtitle: Text(user.fullName ?? "N/A"),
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

String profilePicUrl =
    "https://media.istockphoto.com/id/909772478/photo/brown-teddy-bear-isolated-in-front-of-a-white-background.jpg?s=612x612&w=0&k=20&c=F4252bOrMfRTB8kWm2oM2jlb9JXY08tKCaO5G_ms1Uw=";
