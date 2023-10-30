import 'package:fakestagram/models/models.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable(explicitToJson: true)
class User {
  User({
    this.id,
    this.username,
    this.fullName,
    this.email,
    this.followers,
    this.following,
    this.posts,
    this.followRequests,
  });

  @JsonKey(name: "_id")
  String? id;

  @JsonKey(name: "user_name")
  String? username;

  @JsonKey(name: "full_name")
  String? fullName;

  String? email;

  List<User>? followers;

  List<User>? following;

  @JsonKey(name: "follow_requests")
  List<User>? followRequests;

  List<Post>? posts;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);
}

@JsonSerializable(explicitToJson: true)
class UserList {
  UserList({this.users});

  @JsonKey(name: "follow_suggestions")
  List<User>? users;

  factory UserList.fromJson(Map<String, dynamic> json) =>
      _$UserListFromJson(json);

  Map<String, dynamic> toJson() => _$UserListToJson(this);
}
