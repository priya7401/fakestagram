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

  List<String>? followers;

  List<String>? following;

  @JsonKey(name: "follow_requests")
  List<String>? followRequests;

  List<Post>? posts;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);
}

@JsonSerializable(explicitToJson: true)
class UserList {
  UserList({
    this.followSuggestions,
    this.followRequests,
    this.followers,
    this.following,
  });

  @JsonKey(name: "follow_suggestions")
  List<User>? followSuggestions;

  @JsonKey(name: "follow_requests")
  List<User>? followRequests;

  @JsonKey(name: "followers")
  List<User>? followers;

  @JsonKey(name: "following")
  List<User>? following;

  factory UserList.fromJson(Map<String, dynamic> json) =>
      _$UserListFromJson(json);

  Map<String, dynamic> toJson() => _$UserListToJson(this);
}
