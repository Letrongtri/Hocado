import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';

class StorageService {
  final FirebaseStorage _storage;

  StorageService({required FirebaseStorage storage}) : _storage = storage;

  Future<String?> uploadImage({
    required XFile image,
    required String path,
    required String name,
  }) async {
    try {
      final fileName = '$name.${image.path.split('.').last}';
      final destination = '$path/$fileName';

      final ref = _storage.ref(destination);

      SettableMetadata metadata = SettableMetadata(
        contentType: 'image/jpeg',
      );

      UploadTask task;

      // await ref.putFile(File(image.path));
      if (kIsWeb) {
        final bytes = await image.readAsBytes();
        task = ref.putData(bytes, metadata);
      } else {
        task = ref.putFile(File(image.path), metadata);
      }

      await task;

      return await ref.getDownloadURL();
    } catch (e) {
      throw Exception("Could not upload image to storage");
    }
  }
}
