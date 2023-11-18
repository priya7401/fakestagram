import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:fakestagram/services/auth_service.dart';
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

Widget progressIndicator({Color? color, double? size}) {
  return Transform.scale(
    scale: 1,
    child: Center(
      child: SizedBox(
        height: size ?? 40,
        width: size ?? 40,
        child: CircularProgressIndicator(
          strokeWidth: 3,
          color: color ?? AppConstants.primaryColor,
        ),
      ),
    ),
  );
}

class SmallThemeButton extends StatelessWidget {
  final String? buttonText;
  final Function? onTap;
  final Color? buttonBGColor;
  const SmallThemeButton({
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

apiSnackbar(BuildContext context, DioException dioError) {
  final Response? errorResponse = dioError.response;

  debugPrint(
      "=========== statusCode: ${errorResponse?.statusCode} ==============");
  debugPrint("=========== error: ${errorResponse?.data} ==============");

  if (dioError.response != null) {
    if (dioError.response?.statusCode == 401) {
      AuthService().forceLogout(context);
      return;
    }
  }

  if (dioError.type == DioExceptionType.badResponse) {
    if (errorResponse?.data is Map &&
        errorResponse?.data.containsKey("message")) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content:
              Text(errorResponse?.data["message"] ?? "Something went wrong")));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content:
              Text(errorResponse?.data.toString() ?? "Something went wrong")));
    }
  } else {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content:
            Text(errorResponse?.data["message"] ?? "Something went wrong")));
  }
}

class SubmitButton extends StatelessWidget {
  final String? buttonText;
  final Function? onTap;
  const SubmitButton({
    super.key,
    required this.buttonText,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap!(),
      child: Container(
        width: double.infinity,
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: ShapeDecoration(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(4),
            ),
          ),
          color: Colors.pink[100],
        ),
        child: Text(buttonText ?? ""),
      ),
    );
  }
}

class ProgressIndicatorButton extends StatelessWidget {
  const ProgressIndicatorButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(4),
          ),
        ),
        color: Colors.pink[100],
      ),
      child: Center(
        child: progressIndicator(color: Colors.white, size: 20),
      ),
    );
  }
}

Widget profilePicWidget({
  File? image,
  String? s3Url,
  double? radius,
}) {
  return CircleAvatar(
    radius: radius ?? 52,
    backgroundColor: Colors.white,
    child: ClipRRect(
      borderRadius: BorderRadius.circular(50),
      child: image != null
          ? Image.file(
              image!,
              width: 100,
              height: 100,
              fit: BoxFit.cover,
            )
          : s3Url != null
              ? CachedNetworkImage(
                  imageUrl: s3Url,
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                )
              : Icon(
                  Icons.account_circle_rounded,
                  size: radius != null ? radius * 2 : 100,
                ),
    ),
  );
}
