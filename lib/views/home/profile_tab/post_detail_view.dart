import 'package:cached_network_image/cached_network_image.dart';
import 'package:fakestagram/models/models.dart';
import 'package:fakestagram/providers/providers.dart';
import 'package:fakestagram/services/services.dart';
import 'package:fakestagram/utils/global_widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PostsDetailView extends StatelessWidget {
  final List<Post>? posts;
  final bool? isUserPosts;
  const PostsDetailView({
    super.key,
    this.posts,
    this.isUserPosts = true,
  });

  @override
  Widget build(BuildContext context) {
    Size dim = MediaQuery.of(context).size;

    return Consumer2<UserProvider, PostsProvider>(
        builder: (context, userProvider, postProvider, child) {
      return Scaffold(
          appBar: AppBar(
              centerTitle: false,
              title: isUserPosts == true
                  ? Text(
                      "Posts",
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    )
                  : Text(
                      'Fakestagram',
                      style: TextStyle(fontSize: 20),
                      textAlign: TextAlign.center,
                    ),
              leading: isUserPosts == true
                  ? IconButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      icon: const Icon(Icons.arrow_back),
                    )
                  : null,
              actions: isUserPosts == false
                  ? [
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.favorite_border),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.messenger_outline_outlined),
                      ),
                    ]
                  : null),
          body: SafeArea(
            child: postProvider.isLoading
                ? progressIndicator()
                : ListView(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    children: posts?.map((post) {
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 5, bottom: 8),
                                    child: profilePicWidget(
                                      s3Url: isUserPosts == true
                                          ? userProvider.user?.profilePic?.s3Url
                                          : post.userDetails?.profilePic?.s3Url,
                                      radius: 26,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    isUserPosts == true
                                        ? userProvider.user?.username ?? "N/A"
                                        : post.userDetails?.username ?? " N/A",
                                    style: TextStyle(fontSize: 16),
                                  ),
                                  isUserPosts == true
                                      ? Expanded(
                                          child: IconButton(
                                            alignment: Alignment.centerRight,
                                            onPressed: () {
                                              showModalBottomSheet(
                                                  context: context,
                                                  builder: (context) {
                                                    return Wrap(
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                                  horizontal:
                                                                      20,
                                                                  vertical: 20),
                                                          child: TextButton(
                                                              onPressed: () {
                                                                PostService()
                                                                    .deletePost({
                                                                  "post_id": post
                                                                      .id
                                                                      .toString()
                                                                }, context);
                                                                Navigator.of(
                                                                        context)
                                                                    .pop();
                                                              },
                                                              child: Text(
                                                                  'Delete Post')),
                                                        )
                                                      ],
                                                    );
                                                  });
                                            },
                                            icon: Icon(Icons.more_vert),
                                          ),
                                        )
                                      : Container(),
                                ],
                              ),
                              Container(
                                width: dim.width,
                                color: Colors.black,
                                child: post.attachment?.s3Url != null
                                    ? CachedNetworkImage(
                                        imageUrl: post.attachment?.s3Url ?? "",
                                        height: 400,
                                        fit: BoxFit.fitHeight,
                                      )
                                    : Text('Image not available'),
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Column(
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          PostService().likeDislikePost(
                                            {"post_id": post.id.toString()},
                                            context,
                                          );
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              5, 10, 5, 0),
                                          child: post.userLiked == true
                                              ? Icon(
                                                  Icons.favorite,
                                                  color: Colors.redAccent,
                                                )
                                              : Icon(Icons.favorite_border),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 3),
                                        child: Text(
                                          post.likes.toString(),
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 15,
                                          ),
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
                                      icon: const Icon(
                                          Icons.bookmark_border_outlined),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: Text(
                                  post.description ?? "N/A",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 15),
                                ),
                              ),
                              post.commentCount != null &&
                                      post.commentCount != 0
                                  ? TextButton(
                                      onPressed: () {},
                                      child: Text(
                                        'View all ${post.commentCount ?? 0} comments',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 15,
                                            color: Colors.black),
                                      ),
                                    )
                                  : Container(
                                      height: 15,
                                    ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: Text(
                                  getCreatedAt(post.createdAt ??
                                      DateTime.now().toString()),
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              )
                            ],
                          );
                        }).toList() ??
                        [
                          isUserPosts == true
                              ? Text('No posts yet!')
                              : Text(
                                  'No feed available at the moment.',
                                  textAlign: TextAlign.center,
                                )
                        ],
                  ),
          ));
    });
  }
}
