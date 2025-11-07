import 'package:flutter/material.dart';
import 'package:hocado/core/constants/sizes.dart';

class HocadoTextField extends StatefulWidget {
  const HocadoTextField({
    super.key,
    required this.controller,
    required this.text,
    this.prefixIcon,
    this.isPassword = false,
  });

  final TextEditingController controller;
  final String text;
  final Icon? prefixIcon;
  final bool isPassword;

  @override
  State<HocadoTextField> createState() => _HocadoTextFieldState();
}

class _HocadoTextFieldState extends State<HocadoTextField> {
  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.isPassword;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return TextFormField(
      controller: widget.controller,
      obscureText: _obscureText,
      cursorColor: theme.colorScheme.onPrimary,
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
        suffixIcon: widget.isPassword
            ? IconButton(
                icon: Icon(
                  _obscureText
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                ),
                onPressed: () {
                  setState(() {
                    _obscureText = !_obscureText;
                  });
                },
              )
            : null,
      ),
    );
  }
}
