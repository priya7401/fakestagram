import 'package:fakestagram/providers/user_provider.dart';
import 'package:fakestagram/services/services.dart';
import 'package:fakestagram/utils/global_widgets.dart';
import 'package:fakestagram/views/home/profile_tab/followers_tab/follow_requests_page.dart';
import 'package:fakestagram/views/home/profile_tab/followers_tab/follow_suggestions.dart';
import 'package:fakestagram/views/home/profile_tab/followers_tab/followers_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FollowersTab extends StatelessWidget {
  const FollowersTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(builder: (context, userProvider, child) {
      return ListView(
        shrinkWrap: true,
        children: [
          (userProvider.user?.followRequests?.isNotEmpty ?? true) &&
                  !(userProvider.isLoading)
              ? ListTile(
                  title: Text(
                    'Follow requests',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  subtitle: Text('Approve or ignore requests'),
                  onTap: () {
                    UserService().followRequestList(context);
                    Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (context) => FollowRequestsPage()),
                    );
                  },
                  trailing: Icon(
                    Icons.arrow_forward_ios,
                    size: 18,
                    color: Colors.black,
                  ),
                )
              : Container(),
          SizedBox(
            height: 25,
          ),
          userProvider.isLoading
              ? progressIndicator()
              : (userProvider.user?.followers?.isEmpty ?? true)
                  ? FollowSuggestions()
                  : ListView(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      children: const [
                        FollowersList(),
                        SizedBox(
                          height: 20,
                        ),
                        FollowSuggestions(),
                      ],
                    )
        ],
      );
    });
  }
}
