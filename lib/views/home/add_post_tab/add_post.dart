import 'dart:io';
import 'package:fakestagram/providers/providers.dart';
import 'package:fakestagram/services/services.dart';
import 'package:fakestagram/utils/global_widgets.dart';
import 'package:fakestagram/views/home/home_page.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class AddPost extends StatefulWidget {
  const AddPost({super.key});

  @override
  State<AddPost> createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {
  File? image;
  final description = TextEditingController();

  @override
  void dispose() {
    description.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(builder: (context, appProvider, child) {
      return Scaffold(
        appBar: AppBar(
          title: Text('New Post'),
          leading: InkWell(
            onTap: () {
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                      builder: (context) => HomePage(
                            page: appProvider.prevTabPage,
                          )),
                  (route) => false);
            },
            child: Icon(Icons.close),
          ),
        ),
        body: SafeArea(
            child: Center(
          child: ListView(
            shrinkWrap: true,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            children: [
              Container(
                alignment: Alignment.center,
                height: 300,
                width: 350,
                child: image == null
                    ? ElevatedButton(
                        onPressed: () {
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
                                                final file = await pickFile(
                                                    ImageSource.gallery);
                                                setState(() {
                                                  image = file;
                                                });
                                                Navigator.of(context).pop();
                                              },
                                              child:
                                                  Text('Upload from gallery')),
                                          TextButton(
                                              onPressed: () async {
                                                final file = await pickFile(
                                                    ImageSource.camera);
                                                setState(() {
                                                  image = file;
                                                });
                                                Navigator.of(context).pop();
                                              },
                                              child:
                                                  Text('Upload from camera')),
                                        ],
                                      ),
                                    ),
                                  ],
                                );
                              });
                        },
                        child: Text(
                          'Select image',
                          style: TextStyle(fontSize: 16),
                        ))
                    : Image.file(image!, fit: BoxFit.contain),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                'Description',
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(
                width: 0,
                height: 20,
              ),
              TextField(
                controller: description,
                decoration: InputDecoration(hintText: 'Enter description'),
              ),
              SizedBox(
                width: 0,
                height: 50,
              ),
              ElevatedButton(
                onPressed: () {
                  if (image != null) {
                    PostService().getPresingedUrl({
                      "file_name": image?.path.split('/').last,
                      "file_type": image?.path.split('.').last
                    }, image!, context, description: description.text.trim());
                  }
                },
                child: Text('Create post'),
              )
            ],
          ),
        )),
      );
    });
  }
}
