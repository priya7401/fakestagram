import 'package:cached_network_image/cached_network_image.dart';
import 'package:fakestagram/providers/user_provider.dart';
import 'package:fakestagram/services/user_service.dart';
import 'package:fakestagram/utils/global_widgets.dart';
import 'package:fakestagram/views/home/profile_tab/follow_requests_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FollowersList extends StatelessWidget {
  const FollowersList({super.key});

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
              'All followers',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          SizedBox(
            height: 15,
          ),
          ListView(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: userProvider.followers?.map((follower) {
                  return ListTile(
                    leading: CircleAvatar(
                      radius: 30,
                      backgroundImage:
                          CachedNetworkImageProvider(profilePicUrl),
                    ),
                    title: Text(follower.username ?? "N/A"),
                    trailing: SmallThemeButton(
                      buttonText: "Remove",
                      onTap: () {
                        showModalBottomSheet(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(16),
                                topRight: Radius.circular(16),
                              ),
                            ),
                            context: context,
                            builder: (context) {
                              return Wrap(
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        height: 15,
                                      ),
                                      ListTile(
                                        leading: CircleAvatar(
                                          radius: 30,
                                          backgroundImage:
                                              CachedNetworkImageProvider(
                                                  profilePicUrl),
                                        ),
                                        title: Text('Remove Follower?'),
                                        subtitle: Padding(
                                          padding:
                                              const EdgeInsets.only(top: 5),
                                          child: Text(
                                              "We won't tell ${follower.username ?? 'N/A'} they were removed from your followers"),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 20),
                                        child: TextButton(
                                            onPressed: () {
                                              UserService().removeFollower(
                                                  {"follower_id": follower.id},
                                                  context);
                                              Navigator.of(context).pop();
                                            },
                                            child: Text(
                                              "Remove",
                                              style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                color: Colors.redAccent,
                                              ),
                                            )),
                                      )
                                    ],
                                  ),
                                ],
                              );
                            });
                      },
                    ),
                  );
                }).toList() ??
                [Text('No followers')],
          )
        ],
      );
    });
  }
}
