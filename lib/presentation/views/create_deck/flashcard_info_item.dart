import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hocado/core/constants/sizes.dart';
import 'package:hocado/data/models/models.dart';
import 'package:hocado/presentation/views/create_deck/add_card_button.dart';
import 'package:hocado/presentation/views/create_deck/image_placeholder.dart';
import 'package:hocado/presentation/widgets/hocado_dialog.dart';
import 'package:hocado/presentation/widgets/hocado_text_area.dart';
import 'package:image_picker/image_picker.dart';

class FlashcardInfoItem extends StatefulWidget {
  const FlashcardInfoItem({
    super.key,
    required this.card,
    required this.onCardChanged,
    required this.onCardDelete,
    required this.onAddCard,
  });
  final Flashcard card;
  final ValueChanged<(Flashcard, XFile?, XFile?)> onCardChanged;
  final ValueChanged<String> onCardDelete;
  final VoidCallback onAddCard;

  @override
  State<FlashcardInfoItem> createState() => _FlashcardInfoItemState();
}

class _FlashcardInfoItemState extends State<FlashcardInfoItem> {
  late final TextEditingController termController;
  late final TextEditingController definitionController;
  late final TextEditingController noteController;

  late final FocusNode termFocusNode;
  late final FocusNode definitionFocusNode;
  late final FocusNode noteFocusNode;

  XFile? _pickedImageFront;
  Uint8List? _webImageBytesFront;

  XFile? _pickedImageBack;
  Uint8List? _webImageBytesBack;

  @override
  void initState() {
    super.initState();

    termController = TextEditingController(text: widget.card.front);
    definitionController = TextEditingController(text: widget.card.back);
    noteController = TextEditingController(text: widget.card.note);

    termFocusNode = FocusNode();
    definitionFocusNode = FocusNode();
    noteFocusNode = FocusNode();

    // Lắng nghe khi người dùng rời khỏi ô input để cập nhật state
    termFocusNode.addListener(_onTermFocusChange);
    definitionFocusNode.addListener(_onDefinitionFocusChange);
    noteFocusNode.addListener(_onNoteFocusChange);
  }

  void _onTermFocusChange() {
    if (!termFocusNode.hasFocus) {
      widget.onCardChanged((
        widget.card.copyWith(front: termController.text),
        _pickedImageFront,
        _pickedImageBack,
      ));
    }
  }

  void _onDefinitionFocusChange() {
    if (!definitionFocusNode.hasFocus) {
      widget.onCardChanged((
        widget.card.copyWith(back: definitionController.text),
        _pickedImageFront,
        _pickedImageBack,
      ));
    }
  }

  void _onNoteFocusChange() {
    if (!noteFocusNode.hasFocus) {
      widget.onCardChanged((
        widget.card.copyWith(note: noteController.text),
        _pickedImageFront,
        _pickedImageBack,
      ));
    }
  }

  @override
  void dispose() {
    termController.dispose();
    definitionController.dispose();
    noteController.dispose();
    termFocusNode.dispose();
    definitionFocusNode.dispose();
    noteFocusNode.dispose();
    super.dispose();
  }

  void _onPickImageFront() async {
    final imagePicker = ImagePicker();
    try {
      final imageFile = await imagePicker.pickImage(
        source: ImageSource.gallery,
      );
      if (imageFile == null) return;

      if (kIsWeb) {
        final bytes = await imageFile.readAsBytes();
        setState(() {
          _pickedImageFront = imageFile;
          _webImageBytesFront = bytes; // Lưu bytes để hiển thị Preview
        });
      } else {
        setState(() {
          _pickedImageFront = imageFile;
        });
      }

      final updatedCard = widget.card.copyWith(
        front: termController.text, // Lấy text đang nhập
        back: definitionController.text,
        note: noteController.text,
      );

      widget.onCardChanged((updatedCard, _pickedImageFront, _pickedImageBack));
    } catch (e) {
      if (mounted) {
        showErrorSnackbar(context, "Lỗi chọn ảnh: $e");
      }
    }
  }

  void _onPickImageBack() async {
    final imagePicker = ImagePicker();
    try {
      final imageFile = await imagePicker.pickImage(
        source: ImageSource.gallery,
      );
      if (imageFile == null) return;

      if (kIsWeb) {
        final bytes = await imageFile.readAsBytes();
        setState(() {
          _pickedImageBack = imageFile;
          _webImageBytesBack = bytes; // Lưu bytes để hiển thị Preview
        });
      } else {
        setState(() {
          _pickedImageBack = imageFile;
        });
      }

      final updatedCard = widget.card.copyWith(
        front: termController.text, // Lấy text đang nhập
        back: definitionController.text,
        note: noteController.text,
      );

      widget.onCardChanged((updatedCard, _pickedImageFront, _pickedImageBack));
    } catch (e) {
      if (mounted) {
        showErrorSnackbar(context, "Lỗi chọn ảnh: $e");
      }
    }
  }

  @override
  void didUpdateWidget(FlashcardInfoItem oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Kiểm tra nếu dữ liệu từ cha thay đổi và khác với controller hiện tại
    // thì mới cập nhật (để tránh lỗi nhảy con trỏ khi đang gõ)

    if (widget.card.front != oldWidget.card.front &&
        widget.card.front != termController.text) {
      termController.text = widget.card.front;
    }

    if (widget.card.back != oldWidget.card.back &&
        widget.card.back != definitionController.text) {
      definitionController.text = widget.card.back;
    }

    if (widget.card.note != oldWidget.card.note &&
        widget.card.note != noteController.text) {
      noteController.text = widget.card.note ?? '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Slidable(
      key: ValueKey(widget.card.fid),
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        extentRatio: 0.4,
        children: [
          CustomSlidableAction(
            onPressed: (_) {
              widget.onCardDelete(widget.card.fid);
            },
            backgroundColor: Colors.transparent,
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: theme.colorScheme.error,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.delete_outline_rounded,
                color: theme.colorScheme.onError,
                size: Sizes.iconMd,
              ),
            ),
          ),
        ],
      ),
      child: _buildFlashcardInfo(theme),
    );
  }

  Widget _buildFlashcardInfo(ThemeData theme) {
    return Column(
      children: [
        const SizedBox(height: Sizes.xs),
        Container(
          padding: const EdgeInsets.all(Sizes.md),
          decoration: BoxDecoration(
            color: theme.colorScheme.secondary,
            borderRadius: BorderRadius.circular(Sizes.borderRadiusLg),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  ImagePlaceholder(
                    existingImageUrl: widget.card.frontImageUrl,
                    pickedImage: _pickedImageFront,
                    webImageBytes: _webImageBytesFront,
                    onPickImage: _onPickImageFront,
                  ),
                  const SizedBox(width: Sizes.md),
                  Expanded(
                    child: HocadoTextArea(
                      controller: termController,
                      focusNode: termFocusNode,
                      text: 'Thuật ngữ',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: Sizes.sm),
              Row(
                children: [
                  ImagePlaceholder(
                    existingImageUrl: widget.card.backImageUrl,
                    pickedImage: _pickedImageBack,
                    webImageBytes: _webImageBytesBack,
                    onPickImage: _onPickImageBack,
                  ),
                  const SizedBox(width: Sizes.md),
                  Expanded(
                    child: HocadoTextArea(
                      controller: definitionController,
                      focusNode: definitionFocusNode,
                      text: 'Định nghĩa',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: Sizes.sm),
              HocadoTextArea(
                controller: noteController,
                focusNode: noteFocusNode,
                text: 'Ghi chú',
              ),
            ],
          ),
        ),
        const SizedBox(height: Sizes.xs),
        AddCardButton(
          onAddCard: widget.onAddCard,
        ),
      ],
    );
  }
}
