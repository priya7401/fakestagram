import 'dart:io';

import 'package:fakestagram/utils/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

Widget progressIndicator() {
  return CircularProgressIndicator(
    color: AppConstants.primaryColor,
  );
}

pickFile(ImageSource imageSource) async {
  _pickFile() async {
    final XFile? pickedFile =
        await ImagePicker().pickImage(source: imageSource);
    if (pickedFile != null) {
      final File file = File(pickedFile.path);
      return file;
    }
  }

  if (imageSource == ImageSource.camera) {
    const permission = Permission.camera;
    if (await permission.isGranted) {
      return _pickFile();
    } else if (await permission.request().isGranted) {
      return _pickFile();
    }
  } else {
    if (Platform.isAndroid) {
      return _pickFile();
    } else {
      const permission = Permission.photos;
      if (await permission.isGranted) {
        return _pickFile();
      } else if (await permission.request().isGranted) {
        return _pickFile();
      }
    }
  }
}
