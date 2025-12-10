import 'package:flutter/material.dart';
import 'package:hocado/core/constants/sizes.dart';

class HocadoTextArea extends StatefulWidget {
  const HocadoTextArea({
    super.key,
    required this.controller,
    required this.text,
    this.prefixIcon,
    this.focusNode,
  });

  final TextEditingController controller;
  final String text;
  final Icon? prefixIcon;
  final FocusNode? focusNode;

  @override
  State<HocadoTextArea> createState() => _HocadoTextAreaState();
}

class _HocadoTextAreaState extends State<HocadoTextArea> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return TextFormField(
      controller: widget.controller,
      maxLines: null,
      focusNode: widget.focusNode,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white.withAlpha(40),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Sizes.borderRadiusLg),
          borderSide: BorderSide(
            color: theme.colorScheme.onPrimary.withAlpha(100),
            width: 1.2,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Sizes.borderRadiusLg),
          borderSide: BorderSide(
            color: theme.colorScheme.onPrimary,
            width: 1.6,
          ),
        ),
        labelStyle: theme.textTheme.bodyMedium?.copyWith(
          color: theme.colorScheme.onPrimary,
          fontSize: 16,
        ),

        prefixIcon: widget.prefixIcon,
        labelText: widget.text,
        hintText: widget.text,
      ),
    );
  }
}
