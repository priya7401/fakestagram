import 'package:cached_network_image/cached_network_image.dart';
import 'package:fakestagram/providers/providers.dart';
import 'package:fakestagram/services/services.dart';
import 'package:fakestagram/utils/global_widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:intl/intl.dart';

class ProfilePostsDetailView extends StatelessWidget {
  const ProfilePostsDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    Size dim = MediaQuery.of(context).size;

    return Consumer2<UserProvider, PostsProvider>(
        builder: (context, userProvider, postProvider, child) {
      return Scaffold(
          appBar: AppBar(
            centerTitle: false,
            title: Text(
              "Posts",
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            leading: IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: const Icon(Icons.arrow_back),
            ),
          ),
          body: SafeArea(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 10),
              children: postProvider.posts?.map((post) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            profilePicWidget(
                              s3Url: userProvider.user?.profilePic?.s3Url,
                              radius: 28,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              userProvider.user?.username ?? "N/A",
                              style: TextStyle(fontSize: 16),
                            ),
                            Expanded(
                                child: IconButton(
                                    alignment: Alignment.centerRight,
                                    onPressed: () {
                                      showModalBottomSheet(
                                          context: context,
                                          builder: (context) {
                                            return Wrap(
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 20,
                                                      vertical: 20),
                                                  child: TextButton(
                                                      onPressed: () {
                                                        PostService()
                                                            .deletePost({
                                                          "post_id":
                                                              post.id.toString()
                                                        }, context);
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                      child:
                                                          Text('Delete Post')),
                                                )
                                              ],
                                            );
                                          });
                                    },
                                    icon: Icon(Icons.more_vert)))
                          ],
                        ),
                        Container(
                            width: dim.width,
                            color: Colors.black,
                            child: post.attachment?.s3Url != null
                                ? Image.network(
                                    post.attachment?.s3Url ?? "",
                                    height: 400,
                                    fit: BoxFit.fitHeight,
                                  )
                                : Text('Image not available')),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                IconButton(
                                  onPressed: () {
                                    PostService().likeDislikePost(
                                        {"post_id": post.id.toString()},
                                        context);
                                  },
                                  icon: post.userLiked == true
                                      ? Icon(
                                          Icons.favorite,
                                          color: Colors.redAccent,
                                        )
                                      : Icon(Icons.favorite_border),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: Text(
                                    post.likes.toString(),
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 15),
                                  ),
                                ),
                              ],
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
                                icon:
                                    const Icon(Icons.bookmark_border_outlined),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Text(
                            post.description ?? "N/A",
                            style: TextStyle(
                                fontWeight: FontWeight.w400, fontSize: 15),
                          ),
                        ),
                        TextButton(
                            onPressed: () {},
                            child: Text(
                              'View all ${post.commentCount ?? 0} comments',
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15,
                                  color: Colors.black),
                            )),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Text(getCreatedAt(
                              post.createdAt ?? DateTime.now().toString())),
                        ),
                        SizedBox(
                          height: 20,
                        )
                      ],
                    );
                  }).toList() ??
                  [Text('No posts yet!')],
            ),
          ));
    });
  }
}

String getCreatedAt(String createdAt) {
  DateTime date = DateTime.parse(createdAt);
  if (DateTime.now().difference(date).inDays >= 1) {
    return DateFormat("MMM d").format(date);
  } else {
    return timeago.format(date);
  }
}
