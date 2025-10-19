import 'package:flutter/material.dart';
import 'package:hocado/core/constants/sizes.dart';
// import 'package:image_picker/image_picker.dart';

class ImagePlaceholder extends StatelessWidget {
  ImagePlaceholder({super.key});
  // final _imagePicker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: () {
        // TODO: Xử lý chọn ảnh
        // _imagePicker.pickImage(source: ImageSource.gallery);
      },
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: theme.scaffoldBackgroundColor,
          borderRadius: BorderRadius.circular(Sizes.borderRadiusLg),
          border: Border.all(
            color: theme.colorScheme.onPrimary.withAlpha(100),
          ),
        ),
        child: Icon(
          Icons.image_outlined,
          color: theme.colorScheme.onPrimary,
          size: Sizes.iconLg,
        ),
      ),
    );
  }
}
