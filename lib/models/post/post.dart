import 'package:json_annotation/json_annotation.dart';
import 'package:fakestagram/models/models.dart';

part 'post.g.dart';

@JsonSerializable(explicitToJson: true)
class Post {
  Post(
      {this.id,
      this.likes,
      this.description,
      this.userId,
      this.createdAt,
      this.attachment,
      this.commentCount,
      this.userLiked});

  @JsonKey(name: "_id")
  String? id;

  int? likes;

  String? description;

  @JsonKey(name: "user_id")
  String? userId;

  @JsonKey(name: "created_at")
  String? createdAt;

  Attachment? attachment;

  int? commentCount;

  @JsonKey(name: "user_liked")
  bool? userLiked;

  factory Post.fromJson(Map<String, dynamic> json) => _$PostFromJson(json);

  Map<String, dynamic> toJson() => _$PostToJson(this);
}

@JsonSerializable(explicitToJson: true)
class PostList {
  PostList({this.posts});

  List<Post>? posts;

  factory PostList.fromJson(Map<String, dynamic> json) =>
      _$PostListFromJson(json);

  Map<String, dynamic> toJson() => _$PostListToJson(this);
}
