import 'package:fakestagram/providers/user_provider.dart';
import 'package:fakestagram/services/services.dart';
import 'package:fakestagram/utils/global_widgets.dart';
import 'package:fakestagram/views/home/profile_tab/follower_profile_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FollowRequestsPage extends StatefulWidget {
  const FollowRequestsPage({super.key});

  @override
  State<FollowRequestsPage> createState() => _FollowRequestsPageState();
}

class _FollowRequestsPageState extends State<FollowRequestsPage> {
  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(builder: (context, userProvider, child) {
      return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            "Follow requests",
            style: TextStyle(fontSize: 17),
            textAlign: TextAlign.center,
          ),
          leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: Icon(
              Icons.arrow_back_ios,
            ),
          ),
        ),
        body: SafeArea(
          child: userProvider.isLoading
              ? progressIndicator()
              : (userProvider.followRequests?.isNotEmpty ?? false)
                  ? ListView(
                      children: userProvider.followRequests?.map((user) {
                            return ListTile(
                              leading: profilePicWidget(
                                  radius: 23,
                                  s3Url: userProvider.user?.profilePic?.s3Url),
                              title: Text(user.username ?? "N/A"),
                              subtitle: Text(user.fullName ?? ""),
                              trailing: SizedBox(
                                width: 160,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    SmallThemeButton(
                                      buttonText: "Confirm",
                                      onTap: () {
                                        UserService().acceptRejectRequest({
                                          "follower_id": user.id,
                                          "accept": true
                                        }, context);
                                      },
                                    ),
                                    SmallThemeButton(
                                      buttonText: "Delete",
                                      onTap: () {
                                        UserService().acceptRejectRequest({
                                          "follower_id": user.id,
                                          "accept": false
                                        }, context);
                                      },
                                      buttonBGColor:
                                          Colors.grey.withOpacity(0.4),
                                    ),
                                  ],
                                ),
                              ),
                              onTap: () {
                                UserService().getUserDetails(context,
                                    followerId: user.id);
                                PostService()
                                    .getPosts(context, followerId: user.id);
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => ProfileView()));
                              },
                            );
                          }).toList() ??
                          [],
                    )
                  : Text('No follow requests!'),
        ),
      );
    });
  }
}
