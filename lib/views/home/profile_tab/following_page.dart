import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class FollowingPage extends StatelessWidget {
  const FollowingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      padding: EdgeInsets.symmetric(vertical: 10),
      children: [
        ListTile(
          leading: CircleAvatar(
            radius: 30,
            backgroundImage: CachedNetworkImageProvider(profilePicUrl),
          ),
          title: Text('username 1'),
          trailing: ElevatedButton(
            child: Text('Following'),
            onPressed: () async {
              await showAdaptiveDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog.adaptive(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(16),
                        ),
                      ),
                      scrollable: true,
                      content: Column(
                        children: [
                          CircleAvatar(
                            radius: 30,
                            backgroundImage:
                                CachedNetworkImageProvider(profilePicUrl),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                              "If you change your mind, you'll have to reqeuest to follow <username> again."),
                        ],
                      ),
                      actionsAlignment: MainAxisAlignment.center,
                      actions: [
                        Column(
                          children: [
                            TextButton(
                                onPressed: () {},
                                child: Text(
                                  'Unfollow',
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.w600,
                                  ),
                                )),
                            TextButton(
                                onPressed: () {},
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
        ),
      ],
    );
  }
}

String profilePicUrl =
    "https://media.istockphoto.com/id/909772478/photo/brown-teddy-bear-isolated-in-front-of-a-white-background.jpg?s=612x612&w=0&k=20&c=F4252bOrMfRTB8kWm2oM2jlb9JXY08tKCaO5G_ms1Uw=";
