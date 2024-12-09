import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImageProviderModel {

  final File? image;
  final ImagePicker picker;
  final Uint8List? webImage;
  final Size? imageSize;

  ImageProviderModel({
    this.image,
    required this.picker,
    this.webImage,
    this.imageSize,
  });

  // Add copyWith method for immutability
  ImageProviderModel copyWith({
    File? image,
    ImagePicker? picker,
    Uint8List? webImage,
    Size? imageSize,
  }) {
    return ImageProviderModel(
      image: image ?? this.image,
      picker: picker ?? this.picker,
      webImage: webImage ?? this.webImage,
      imageSize: imageSize ?? this.imageSize,
    );
  }
}