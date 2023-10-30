import 'dart:io';

import 'package:fakestagram/utils/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

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

Widget progressIndicator() {
  return Transform.scale(
    scale: 1,
    child: Center(
      child: SizedBox(
        height: 40,
        width: 40,
        child: CircularProgressIndicator(
          strokeWidth: 3,
          color: AppConstants.primaryColor,
        ),
      ),
    ),
  );
}

class SmallThemeButton extends StatelessWidget {
  String? buttonText;
  Function? onTap;
  Color? buttonBGColor;
  SmallThemeButton({
    super.key,
    this.buttonText,
    this.onTap,
    this.buttonBGColor,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          minimumSize: Size(40, 30),
          padding: const EdgeInsets.symmetric(horizontal: 13),
          backgroundColor: buttonBGColor),
      child: Text(buttonText ?? ""),
      onPressed: () {
        if (onTap != null) {
          onTap!();
        }
      },
    );
  }
}
