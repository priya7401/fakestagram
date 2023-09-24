import 'package:fakestagram/models/post/post.dart';
import 'package:fakestagram/providers/posts_provider.dart';
import 'package:fakestagram/providers/user_provider.dart';
import 'package:fakestagram/views/home/home_page.dart';
import 'package:fakestagram/views/home/home_tab/home_tab_page.dart';
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
    return Consumer2<UserProvider, PostsProvider>(
        builder: (context, userProvider, postProvider, child) {
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
                  CircleAvatar(
                    radius: 30,
                    backgroundImage: NetworkImage(profilePicUrl),
                  ),
                  Column(
                    children: const [
                      Text(
                        '3',
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 16),
                      ),
                      Text('Posts')
                    ],
                  ),
                  Column(
                    children: const [
                      Text(
                        '100',
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 16),
                      ),
                      Text('Followers')
                    ],
                  ),
                  Column(
                    children: const [
                      Text(
                        '125',
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 16),
                      ),
                      Text('following')
                    ],
                  ),
                ],
              ),
              Text(
                'Name',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
              ),
              SizedBox(
                height: 5,
              ),
              Text(bio),
              SizedBox(
                height: 15,
              ),
              postProvider.isLoading
                  ? const CircularProgressIndicator(
                      strokeWidth: 2,
                    )
                  : GridView(
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
                                ? Image(
                                    image: NetworkImage(
                                        post.attachment?.s3Url ?? ""),
                                    fit: BoxFit.cover,
                                  )
                                : Text('Image not available');
                          }).toList() ??
                          [],
                    ),
            ],
          ),
        ),
      );
    });
  }
}

String bio =
    "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec in quam quam. ";
