import 'dart:convert';
import 'dart:typed_data';
import 'package:image_picker/image_picker.dart';
import '../core/utils/app_constants.dart';

class PickedImageData {
  final String name;
  final String path;
  final Uint8List bytes;
  final String mimeType;
  final int sizeInBytes;

  const PickedImageData({
    required this.name,
    required this.path,
    required this.bytes,
    required this.mimeType,
    required this.sizeInBytes,
  });

  String get base64String => base64Encode(bytes);
  String get sizeInKb => (sizeInBytes / 1024).toStringAsFixed(1);
  String get sizeInMb => (sizeInBytes / (1024 * 1024)).toStringAsFixed(2);
}

class ImageService {
  final ImagePicker _picker = ImagePicker();

  Future<PickedImageData?> pickImageFromGallery() async {
    return _pickImage(ImageSource.gallery);
  }

  Future<PickedImageData?> pickImageFromCamera() async {
    return _pickImage(ImageSource.camera);
  }

  Future<PickedImageData?> _pickImage(ImageSource source) async {
    try {
      final XFile? file = await _picker.pickImage(
        source: source,
        maxWidth: 2048,
        maxHeight: 2048,
        imageQuality: 85,
      );

      if (file == null) return null;

      final bytes = await file.readAsBytes();
      if (bytes.length > AppConstants.maxImageSizeBytes) {
        throw Exception(
          'Image size exceeds maximum limit of ${(AppConstants.maxImageSizeBytes / (1024 * 1024)).toInt()} MB.',
        );
      }

      final mimeType = _determineMimeType(file.name);

      return PickedImageData(
        name: file.name,
        path: file.path,
        bytes: bytes,
        mimeType: mimeType,
        sizeInBytes: bytes.length,
      );
    } catch (e) {
      rethrow;
    }
  }

  String _determineMimeType(String fileName) {
    final lower = fileName.toLowerCase();
    if (lower.endsWith('.png')) return 'image/png';
    if (lower.endsWith('.jpg') || lower.endsWith('.jpeg')) return 'image/jpeg';
    if (lower.endsWith('.webp')) return 'image/webp';
    return 'image/png';
  }
}
