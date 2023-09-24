import 'package:fakestagram/models/models.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable(explicitToJson: true)
class User {
  User({
    this.id,
    this.userAuth,
    this.followers,
    this.following,
    this.posts
  });

  @JsonKey(name: "_id")
  String? id;

  @JsonKey(name: "user_auth")
  UserAuth? userAuth;

  int? followers;

  int? following;

  List<Post>? posts;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);
}

@JsonSerializable(explicitToJson: true)
class UserAuth {
  UserAuth({this.username, this.email, this.token});

  String? username;
  String? email;
  String? token;

  factory UserAuth.fromJson(Map<String, dynamic> json) =>
      _$UserAuthFromJson(json);

  Map<String, dynamic> toJson() => _$UserAuthToJson(this);
}
