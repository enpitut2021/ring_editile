import 'package:dio/dio.dart';
// import 'package:http_parser/http_parser.dart';
import 'dart:async';
import 'package:ring_sns/api/API.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'dart:io';

class CupyAPI extends API {
  String _cupyBaseUrl;

  CupyAPI(String bearer) : super(bearer) {
    _cupyBaseUrl = 'https://restapi-editile.p0x0q.com';
  }

  Future<dynamic> postImageRequest(String url, [FormData formData]) async {
    print('[$url] submit');

    try {
      Response<dynamic> response = await dio.post(
        url,
        data: formData,
      );
      print('[$url] response: $response');
      return response.data;
    } catch (e) {
      print('[$url] error: $e');
      return e;
    }
  }

  Future<String> _uploadImage(String imageFilePath, PickedFile imageFile) async {
    String url = 'images/upload/cupy';
    File file = File(imageFile.path);
    FormData formData = FormData.fromMap({
      'name': 'image_file',
      'image_file': await MultipartFile.fromFile(
      file.path,
      filename: file.path.split('/').last,
    ),
    });
    try {
      dynamic response = await postImageRequest(url, formData);
      String filename = response['file'];
      String imageUrl = "https://restapi-editile.p0x0q.com" + filename;
      print('[$url] uploaded image url: $imageUrl');
      return imageUrl;
    } catch (e) {
      print('[$url] error: $e');
      return '';
    }
  }

  Future<File> _imageCrop(String imagePath) async {
    return ImageCropper.cropImage(
        sourcePath: imagePath,
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio3x2,
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.ratio4x3,
          CropAspectRatioPreset.ratio16x9
        ],
        androidUiSettings: AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: Colors.deepOrange,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        iosUiSettings: IOSUiSettings(
          minimumAspectRatio: 1.0,
        ));
  }

  Future<String> callImagePicker({bool clop = false}) async {
    PickedFile imageFile =
        await ImagePicker().getImage(source: ImageSource.gallery);
    if (imageFile == null) return '';
    String imagePath = imageFile.path;
    if (clop) {
      File cloppedImageFile = await _imageCrop(imagePath);
      if (cloppedImageFile == null) return '';
      imagePath = cloppedImageFile.path;
    }
    return imagePath;
  }

  Future<String> uploadImageWithPicker({bool clop = false}) async {
    PickedFile imageFile =
        await ImagePicker().getImage(source: ImageSource.gallery);
    if (imageFile == null) return '';
    String imagePath = imageFile.path;
    // if (clop) {
    //   File cloppedImageFile = await _imageCrop(imagePath);
    //   if (cloppedImageFile == null) return '';
    //   imagePath = cloppedImageFile.path;
    // }
    return await _uploadImage(imagePath, imageFile);
  }
}
