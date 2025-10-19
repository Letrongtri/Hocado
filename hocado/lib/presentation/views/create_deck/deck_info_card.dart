import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hocado/app/provider/flashcard_provider.dart';
import 'package:hocado/core/constants/sizes.dart';
import 'package:hocado/data/models/deck.dart';
import 'package:hocado/presentation/views/create_deck/image_placeholder.dart';
import 'package:hocado/presentation/widgets/hocado_text_area.dart';

class DeckInfoCard extends ConsumerStatefulWidget {
  final Deck deck;
  const DeckInfoCard({super.key, required this.deck});

  @override
  ConsumerState<DeckInfoCard> createState() => _DeckInfoCardState();
}

class _DeckInfoCardState extends ConsumerState<DeckInfoCard> {
  late final TextEditingController titleController;
  late final TextEditingController descriptionController;

  late final FocusNode titleFocusNode;
  late final FocusNode descriptionFocusNode;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    titleController = TextEditingController();
    descriptionController = TextEditingController();

    titleFocusNode = FocusNode();
    descriptionFocusNode = FocusNode();

    // Lắng nghe khi người dùng rời khỏi ô input để cập nhật state
    titleFocusNode.addListener(_onTitleFocusChange);
    descriptionFocusNode.addListener(_onDescriptionFocusChange);
  }

  void _onTitleFocusChange() {
    if (!titleFocusNode.hasFocus) {
      ref
          .read(flashcardViewModelProvider.notifier)
          .updateDeckName(
            widget.deck.did,
            titleController.text,
          );
    }
  }

  void _onDescriptionFocusChange() {
    if (!descriptionFocusNode.hasFocus) {
      ref
          .read(flashcardViewModelProvider.notifier)
          .updateDeckDescription(
            widget.deck.did,
            descriptionController.text,
          );
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
          ImagePlaceholder(),
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
