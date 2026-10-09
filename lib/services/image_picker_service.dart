import 'dart:convert';
import 'package:equatable/equatable.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

class PickedImageData extends Equatable {
  final Uint8List bytes;
  final String name;

  const PickedImageData({
    required this.bytes,
    required this.name,
  });

  @override
  List<Object?> get props => [bytes, name];
}

class ImagePickerService {
  final ImagePicker _picker = ImagePicker();

  Future<PickedImageData?> pickImage(ImageSource source) async {
    final picked = await _picker.pickImage(
      source: source,
      maxWidth: 800,
      maxHeight: 800,
      imageQuality: 70,
    );

    if (picked == null) return null;
    final bytes = await picked.readAsBytes();
    return PickedImageData(
      bytes: bytes,
      name: picked.name,
    );
  }

  PickedImageData getSampleImage() {
    const sampleBase64Png =
        'iVBORw0KGgoAAAANSUhEUgAAAEAAAABACAQAAAAAYLlVAAAAOUlEQVR42u3OMQEAAAgDINe/tC18'
        '2AMCG1lM5yQkJCQkJCQkJCQkJCQkJCQkJCQkJCQkJCQkJCQkJCQk/EfgA6Ym2tP7wZAAAAAASUVORK5CYII=';
    return PickedImageData(
      bytes: base64Decode(sampleBase64Png),
      name: 'sample_pixel_test.png',
    );
  }
}
