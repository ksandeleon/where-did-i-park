import 'dart:io';
import 'package:image_picker/image_picker.dart';

class CameraService {
  final ImagePicker _picker = ImagePicker();

  /// Take a new photo using the camera
  Future<File?> takePhoto() async {
    try {
      final XFile? photo = await _picker.pickImage(source: ImageSource.camera);
      if (photo == null) return null;
      return File(photo.path);
    } catch (e) {
      print('Error taking photo: $e');
      return null;
    }
  }

  /// Pick an existing photo from the gallery
  Future<File?> pickFromGallery() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image == null) return null;
      return File(image.path);
    } catch (e) {
      print('Error picking image: $e');
      return null;
    }
  }

  /// Handle lost data in case the activity is killed (Android only)
  Future<File?> handleLostData() async {
    final LostDataResponse response = await _picker.retrieveLostData();
    if (response.isEmpty) return null;

    if (response.file != null) {
      return File(response.file!.path);
    } else {
      print("Lost data error: ${response.exception}");
      return null;
    }
  }
}
