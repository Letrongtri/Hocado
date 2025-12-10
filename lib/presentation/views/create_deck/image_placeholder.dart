import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hocado/core/constants/sizes.dart';
import 'package:image_picker/image_picker.dart';

class ImagePlaceholder extends StatelessWidget {
  const ImagePlaceholder({
    super.key,
    this.existingImageUrl,
    this.pickedImage,
    this.webImageBytes,
    this.onPickImage,
  });

  final String? existingImageUrl;
  final XFile? pickedImage;
  final Uint8List? webImageBytes;
  final VoidCallback? onPickImage;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    ImageProvider? backgroundImage;

    if (pickedImage != null) {
      if (kIsWeb && webImageBytes != null) {
        backgroundImage = MemoryImage(webImageBytes!);
      } else if (!kIsWeb) {
        backgroundImage = FileImage(File(pickedImage!.path));
      }
    } else if (existingImageUrl != null) {
      backgroundImage = NetworkImage(existingImageUrl!);
    }

    return InkWell(
      onTap: onPickImage,
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          image: backgroundImage != null
              ? DecorationImage(image: backgroundImage)
              : null,
          color: theme.scaffoldBackgroundColor,
          borderRadius: BorderRadius.circular(Sizes.borderRadiusLg),
          border: Border.all(
            color: theme.colorScheme.onPrimary.withAlpha(100),
          ),
        ),
        child: backgroundImage == null
            ? Icon(
                Icons.image_outlined,
                color: theme.colorScheme.onPrimary,
                size: Sizes.iconLg,
              )
            : null,
      ),
    );
  }
}
