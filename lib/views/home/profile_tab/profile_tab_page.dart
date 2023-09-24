import 'package:fakestagram/utils/app_constants.dart';
import 'package:fakestagram/views/home/home_tab/home_tab_page.dart';
import 'package:flutter/material.dart';

class ProfileTabPage extends StatefulWidget {
  const ProfileTabPage({Key? key}) : super(key: key);

  @override
  State<ProfileTabPage> createState() => _ProfileTabPageState();
}

class _ProfileTabPageState extends State<ProfileTabPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppConstants.primaryColor,
        centerTitle: false,
        title: Text(
          'Username',
          style: TextStyle(fontSize: 17),
          textAlign: TextAlign.center,
        ),
        actions: [
          IconButton(
            onPressed: () {},
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
                  children: [
                    Text(
                      '3',
                      style:
                          TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                    ),
                    Text('Posts')
                  ],
                ),
                Column(
                  children: [
                    Text(
                      '100',
                      style:
                          TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                    ),
                    Text('Followers')
                  ],
                ),
                Column(
                  children: [
                    Text(
                      '125',
                      style:
                          TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
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
            GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: 20,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 3,
                  mainAxisSpacing: 3,
                  childAspectRatio: 1,
                ),
                itemBuilder: (context, index) {
                  return Image(
                    image: NetworkImage(postUrl),
                    fit: BoxFit.cover,
                  );
                }),
          ],
        ),
      ),
    );
  }
}

String bio =
    "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec in quam quam. ";
