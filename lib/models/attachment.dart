import 'package:json_annotation/json_annotation.dart';

part 'attachment.g.dart';

@JsonSerializable(explicitToJson: true)
class Attachment {
  Attachment({
    this.s3Key,
    this.s3Url
  });

  @JsonKey(name: "s3_key")
  String? s3Key;

  @JsonKey(name: "s3_url")
  String? s3Url;

  factory Attachment.fromJson(Map<String, dynamic> json) => _$AttachmentFromJson(json);

  Map<String, dynamic> toJson() => _$AttachmentToJson(this);
}