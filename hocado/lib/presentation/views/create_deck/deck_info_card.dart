import 'package:flutter/material.dart';
import 'package:hocado/core/constants/sizes.dart';
import 'package:hocado/data/models/models.dart';
import 'package:hocado/presentation/views/create_deck/image_placeholder.dart';
import 'package:hocado/presentation/widgets/hocado_text_area.dart';

class DeckInfoCard extends StatefulWidget {
  final Deck deck;
  final ValueChanged<Deck> onUpdated;

  const DeckInfoCard({super.key, required this.deck, required this.onUpdated});

  @override
  State<DeckInfoCard> createState() => _DeckInfoCardState();
}

class _DeckInfoCardState extends State<DeckInfoCard> {
  late final TextEditingController titleController;
  late final TextEditingController descriptionController;

  late final FocusNode titleFocusNode;
  late final FocusNode descriptionFocusNode;

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
      widget.onUpdated(widget.deck.copyWith(name: titleController.text));
    }
  }

  void _onDescriptionFocusChange() {
    if (!descriptionFocusNode.hasFocus) {
      widget.onUpdated(
        widget.deck.copyWith(description: descriptionController.text),
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
