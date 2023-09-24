import 'package:fakestagram/models/models.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable(explicitToJson: true)
class User {
  User(
      {this.id,
      this.username,
      this.email,
      this.followers,
      this.following,
      this.posts});

  @JsonKey(name: "_id")
  String? id;

  String? username;

  String? email;

  int? followers;

  int? following;

  List<Post>? posts;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);
}
