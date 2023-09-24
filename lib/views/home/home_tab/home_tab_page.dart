import 'package:fakestagram/utils/app_constants.dart';
import 'package:flutter/material.dart';

class HomeTabPage extends StatefulWidget {
  const HomeTabPage({Key? key}) : super(key: key);

  @override
  State<HomeTabPage> createState() => _HomeTabPageState();
}

class _HomeTabPageState extends State<HomeTabPage> {
  @override
  Widget build(BuildContext context) {
    final Size dim = MediaQuery.of(context).size;

    return Scaffold(
        appBar: AppBar(
          backgroundColor: AppConstants.primaryColor,
          centerTitle: false,
          title: Text(
            'Fakestagram',
            style: TextStyle(fontSize: 20),
            textAlign: TextAlign.center,
          ),
          actions: [
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.favorite_border),
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.messenger_outline_outlined),
            ),
          ],
        ),
        body: ListView.builder(
          itemCount: 1,
          itemBuilder: (context, index) => Container(
            margin: EdgeInsets.symmetric(vertical: 15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundImage: NetworkImage(profilePicUrl),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      'pubity',
                      style: TextStyle(fontSize: 16),
                    ),
                    Expanded(
                        child: IconButton(
                            alignment: Alignment.centerRight,
                            onPressed: () {},
                            icon: Icon(Icons.more_vert)))
                  ],
                ),
                Container(
                    width: dim.width,
                    color: Colors.black,
                    child: Image.network(
                      postUrl,
                      height: 400,
                      fit: BoxFit.fitHeight,
                    )),
                Row(
                  children: [
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.favorite_border),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.comment_outlined),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.send),
                    ),
                    Expanded(
                      child: IconButton(
                        alignment: Alignment.centerRight,
                        onPressed: () {},
                        icon: const Icon(Icons.bookmark_border_outlined),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    '30,000 likes',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    postDesc,
                    style: TextStyle(fontWeight: FontWeight.w400, fontSize: 15),
                  ),
                ),
                TextButton(
                    onPressed: () {},
                    child: Text(
                      'View all 1,500 comments',
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                          color: Colors.black),
                    )),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Text('4 hours ago'),
                )
              ],
            ),
          ),
        ));
  }
}

String profilePicUrl =
    "https://media.istockphoto.com/id/909772478/photo/brown-teddy-bear-isolated-in-front-of-a-white-background.jpg?s=612x612&w=0&k=20&c=F4252bOrMfRTB8kWm2oM2jlb9JXY08tKCaO5G_ms1Uw=";

String postUrl =
    "https://cdn.pixabay.com/photo/2015/12/01/20/28/road-1072823_640.jpg";

String postDesc =
    "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Phasellus dictum in mi at tempus. Praesent finibus faucibus molestie. Morbi magna sem, consequat at turpis at, tincidunt vulputate arcu. ";
