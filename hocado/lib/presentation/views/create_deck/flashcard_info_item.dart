import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hocado/app/provider/provider.dart';
import 'package:hocado/core/constants/sizes.dart';
import 'package:hocado/data/models/models.dart';
import 'package:hocado/presentation/viewmodels/viewmodels.dart';
import 'package:hocado/presentation/views/create_deck/add_card_button.dart';
import 'package:hocado/presentation/views/create_deck/image_placeholder.dart';
import 'package:hocado/presentation/widgets/hocado_text_area.dart';

class FlashcardInfoItem extends ConsumerStatefulWidget {
  const FlashcardInfoItem({super.key, required this.card});
  final Flashcard card;

  @override
  ConsumerState<FlashcardInfoItem> createState() => _FlashcardInfoItemState();
}

class _FlashcardInfoItemState extends ConsumerState<FlashcardInfoItem> {
  late final TextEditingController termController;
  late final TextEditingController definitionController;
  late final TextEditingController noteController;

  late final FocusNode termFocusNode;
  late final FocusNode definitionFocusNode;
  late final FocusNode noteFocusNode;

  late final CreateDeckViewModel viewModel;

  @override
  void initState() {
    super.initState();

    viewModel = ref.read(
      createDeckViewModelProvider(widget.card.did).notifier,
    );

    termController = TextEditingController(text: widget.card.front);
    definitionController = TextEditingController(text: widget.card.back);
    noteController = TextEditingController(text: widget.card.note);

    termController.text = widget.card.front;
    definitionController.text = widget.card.back;
    noteController.text = widget.card.note ?? '';

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
      viewModel.updateFlashcardFront(widget.card.fid, termController.text);
    }
  }

  void _onDefinitionFocusChange() {
    if (!definitionFocusNode.hasFocus) {
      viewModel.updateFlashcardBack(widget.card.fid, definitionController.text);
    }
  }

  void _onNoteFocusChange() {
    if (!noteFocusNode.hasFocus) {
      viewModel.updateFlashcardNote(widget.card.fid, noteController.text);
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
              viewModel.deleteFlashcard(widget.card.fid);
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
                  ImagePlaceholder(),
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
                  ImagePlaceholder(),
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
          fid: widget.card.fid,
          did: widget.card.did,
        ),
      ],
    );
  }
}
