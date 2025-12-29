import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:mahavar_technician/constants.dart';

class ImageHelper {
  final ImagePicker imagePicker = ImagePicker();
  final ImageCropper imageCropper = ImageCropper();

  Future<XFile?> getImage() async {
    try {
      return await imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 100,
      );
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<File?> crop(XFile file) async {
    final croppedFile = await imageCropper.cropImage(
      sourcePath: file.path,
      compressQuality: 100,
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Cropper',
          toolbarColor: Colors.white,
          toolbarWidgetColor: Colors.black,
          backgroundColor: color4,
          initAspectRatio: CropAspectRatioPreset.square,
          lockAspectRatio: false,
        ),
        IOSUiSettings(
          title: 'Cropper',
        ),
      ],
    );

    return croppedFile == null ? null : File(croppedFile.path);
  }
}
