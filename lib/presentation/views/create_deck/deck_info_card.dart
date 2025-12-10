import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hocado/core/constants/sizes.dart';
import 'package:hocado/data/models/models.dart';
import 'package:hocado/presentation/views/create_deck/image_placeholder.dart';
import 'package:hocado/presentation/widgets/hocado_dialog.dart';
import 'package:hocado/presentation/widgets/hocado_text_area.dart';
import 'package:image_picker/image_picker.dart';

class DeckInfoCard extends StatefulWidget {
  final Deck deck;
  final ValueChanged<(Deck, XFile?)> onUpdated;

  const DeckInfoCard({super.key, required this.deck, required this.onUpdated});

  @override
  State<DeckInfoCard> createState() => _DeckInfoCardState();
}

class _DeckInfoCardState extends State<DeckInfoCard> {
  late final TextEditingController titleController;
  late final TextEditingController descriptionController;

  late final FocusNode titleFocusNode;
  late final FocusNode descriptionFocusNode;

  XFile? _pickedImage;
  Uint8List? _webImageBytes; // for web

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController();
    descriptionController = TextEditingController();

    titleController.text = widget.deck.name;
    descriptionController.text = widget.deck.description;

    titleFocusNode = FocusNode();
    descriptionFocusNode = FocusNode();

    // Lắng nghe khi người dùng rời khỏi ô input để cập nhật state
    titleFocusNode.addListener(_onTitleFocusChange);
    descriptionFocusNode.addListener(_onDescriptionFocusChange);
  }

  void _onTitleFocusChange() {
    if (!titleFocusNode.hasFocus) {
      widget.onUpdated((
        widget.deck.copyWith(name: titleController.text),
        _pickedImage,
      ));
    }
  }

  void _onDescriptionFocusChange() {
    if (!descriptionFocusNode.hasFocus) {
      widget.onUpdated((
        widget.deck.copyWith(description: descriptionController.text),
        _pickedImage,
      ));
    }
  }

  void _onPickImage() async {
    final imagePicker = ImagePicker();
    try {
      final imageFile = await imagePicker.pickImage(
        source: ImageSource.gallery,
      );
      if (imageFile == null) return;

      if (kIsWeb) {
        final bytes = await imageFile.readAsBytes();
        setState(() {
          _pickedImage = imageFile;
          _webImageBytes = bytes; // Lưu bytes để hiển thị Preview
        });
      } else {
        setState(() {
          _pickedImage = imageFile;
        });
      }

      widget.onUpdated((widget.deck, _pickedImage));
    } catch (e) {
      if (mounted) {
        showErrorSnackbar(context, "Lỗi chọn ảnh: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.all(Sizes.md),
      decoration: BoxDecoration(
        color: theme.colorScheme.secondary,
        borderRadius: BorderRadius.circular(Sizes.borderRadiusLg),
      ),

      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ImagePlaceholder(
            existingImageUrl: widget.deck.thumbnailUrl,
            pickedImage: _pickedImage,
            webImageBytes: _webImageBytes,
            onPickImage: _onPickImage,
          ),

          SizedBox(width: Sizes.md),
          Expanded(
            child: Column(
              children: [
                HocadoTextArea(
                  controller: titleController,
                  text: "Tiêu đề",
                  focusNode: titleFocusNode,
                ),
                SizedBox(height: Sizes.sm),
                HocadoTextArea(
                  controller: descriptionController,
                  text: "Mô tả",
                  focusNode: descriptionFocusNode,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
