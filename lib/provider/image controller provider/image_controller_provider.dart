import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'package:aiponics_web_app/models/image%20controller%20models/image_provider_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

class ImageControllerNotifier extends StateNotifier<ImageProviderModel> {
  ImageControllerNotifier() : super(ImageProviderModel(picker: ImagePicker()));

  // Update methods for TextEditingController fields
  void updateImage(File? newImage) {
    log("update image called");
    state = state.copyWith(image: newImage);
  }

  void updatePicker(ImagePicker newPicker) {
    log("update picker called");
    state = state.copyWith(picker: newPicker);
  }

  void updateWebImage(Uint8List? newWebImage) {
    log("update web image called");
    state = state.copyWith(webImage: newWebImage);
  }

  void updateImageSize(Size? newImageSize) {
    log("update image size called");
    state = state.copyWith(imageSize: newImageSize);
  }

  // Add the reset state method
  void resetState() {
    // Reinitialize the state with default values
    state = ImageProviderModel(
      imageSize: null,
      image: null,
      webImage: null,
      picker: ImagePicker(),
    );
  }

}

final imageControllerProvider =
    StateNotifierProvider<ImageControllerNotifier, ImageProviderModel>((ref) {
  return ImageControllerNotifier();
});
