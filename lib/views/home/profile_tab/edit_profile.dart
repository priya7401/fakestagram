import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:fakestagram/models/models.dart';
import 'package:fakestagram/providers/providers.dart';
import 'package:fakestagram/services/services.dart';
import 'package:fakestagram/utils/global_widgets.dart';
import 'package:fakestagram/utils/text_fields.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class EditProfile extends StatefulWidget {
  final User? user;
  const EditProfile({
    super.key,
    this.user,
  });

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  File? image;
  final formKey = GlobalKey<FormState>();
  final username = TextEditingController();
  final fullname = TextEditingController();
  final bio = TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController();
  bool isPublic = true;

  @override
  void initState() {
    super.initState();
    username.text = widget.user?.username ?? "";
    fullname.text = widget.user?.fullName ?? "";
    bio.text = widget.user?.bio ?? "";
    email.text = widget.user?.email ?? "";
    isPublic = widget.user?.isPublic ?? true;
  }

  @override
  void dispose() {
    username.dispose();
    fullname.dispose();
    bio.dispose();
    email.dispose();
    password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<UserProvider, PostsProvider>(
        builder: (context, userProvider, postsProvider, child) {
      return Scaffold(
        body: SafeArea(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            children: [
              SizedBox(
                height: 50,
              ),
              GestureDetector(
                onTap: () {
                  showModalBottomSheet(
                      context: context,
                      builder: (context) {
                        return Wrap(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 10),
                              child: Column(
                                children: [
                                  TextButton(
                                      onPressed: () async {
                                        final file =
                                            await pickFile(ImageSource.gallery);
                                        setState(() {
                                          image = file;
                                        });
                                        if (context.mounted) {
                                          Navigator.of(context).pop();
                                        }
                                      },
                                      child: Text('Upload from gallery')),
                                  TextButton(
                                      onPressed: () async {
                                        final file =
                                            await pickFile(ImageSource.camera);
                                        setState(() {
                                          image = file;
                                        });
                                        if (context.mounted) {
                                          Navigator.of(context).pop();
                                        }
                                      },
                                      child: Text('Upload from camera')),
                                ],
                              ),
                            ),
                          ],
                        );
                      });
                },
                child: profilePicWidget(
                  image: image,
                  s3Url: userProvider.user?.profilePic?.s3Url,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Form(
                key: formKey,
                child: ListView(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    EditProfileTextfield(
                      title: 'Username',
                      textfieldWidget: CustomTextField(
                        textEditingController: username,
                        hintText: 'Enter username',
                        fieldName: 'username',
                        initialText: widget.user?.username,
                        isRequired: false,
                      ),
                    ),
                    EditProfileTextfield(
                      title: 'Full Name',
                      textfieldWidget: CustomTextField(
                        textEditingController: fullname,
                        hintText: 'Enter full name',
                        fieldName: 'fullname',
                        initialText: widget.user?.fullName,
                        isRequired: false,
                      ),
                    ),
                    EditProfileTextfield(
                      title: 'Email',
                      textfieldWidget: CustomTextField(
                        textEditingController: email,
                        hintText: 'Enter email',
                        fieldName: 'email',
                        isEmail: true,
                        initialText: widget.user?.email,
                        isRequired: false,
                      ),
                    ),
                    EditProfileTextfield(
                      title: 'Bio',
                      textfieldWidget: CustomTextField(
                        textEditingController: bio,
                        hintText: 'Enter bio',
                        fieldName: 'bio',
                        initialText: widget.user?.bio,
                        isRequired: false,
                      ),
                    ),
                    EditProfileTextfield(
                      title: 'Account',
                      textfieldWidget: SwitchListTile(
                        value: isPublic,
                        onChanged: (bool? val) {
                          setState(() {
                            isPublic = val ?? true;
                          });
                        },
                        title: Text(isPublic ? "Public" : "Private"),
                        secondary: Icon(
                          Icons.account_circle_outlined,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              userProvider.isLoading || postsProvider.isLoading
                  ? const ProgressIndicatorButton()
                  : SubmitButton(
                      buttonText: 'Submit',
                      onTap: () async {
                        if (formKey.currentState!.validate()) {
                          Map<String, dynamic> data = {};
                          if (username.text != widget.user?.username) {
                            data["user_name"] = username.text;
                          }
                          if (fullname.text != widget.user?.fullName) {
                            data["full_name"] = fullname.text;
                          }
                          if (email.text != widget.user?.email) {
                            data["email"] = email.text;
                          }
                          if (isPublic != widget.user?.isPublic) {
                            data["is_public"] = isPublic;
                          }
                          if (bio.text != widget.user?.bio) {
                            data["bio"] = bio.text;
                          }
                          if (image != null) {
                            PostService().getPresingedUrl(
                              {
                                "file_name": image?.path.split('/').last,
                                "file_type": image?.path.split('.').last
                              },
                              image!,
                              context,
                              callback: (String s3Key) async {
                                data["s3_key"] = s3Key;
                                UserService().updateUserDetails(
                                  context,
                                  data,
                                );
                              },
                            );
                          } else {
                            UserService().updateUserDetails(
                              context,
                              data,
                            );
                          }
                        }
                      },
                    ),
              SizedBox(
                height: 15,
              )
            ],
          ),
        ),
      );
    });
  }
}

class EditProfileTextfield extends StatelessWidget {
  final String? title;
  final Widget? textfieldWidget;
  const EditProfileTextfield({
    super.key,
    this.title,
    this.textfieldWidget,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title ?? "",
          style: TextStyle(fontSize: 20),
        ),
        SizedBox(
          width: 0,
          height: 20,
        ),
        textfieldWidget ?? Container(),
        SizedBox(
          width: 0,
          height: 50,
        ),
      ],
    );
  }
}
