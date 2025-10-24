import 'package:flutter/material.dart';

class HocadoSwitch extends StatefulWidget {
  final bool initialValue;
  final ValueChanged<bool> onChanged;

  const HocadoSwitch({
    super.key,
    required this.initialValue,
    required this.onChanged,
  });

  @override
  State<HocadoSwitch> createState() => _HocadoSwitchState();
}

class _HocadoSwitchState extends State<HocadoSwitch> {
  late bool currentValue;

  @override
  void initState() {
    super.initState();
    currentValue = widget.initialValue;
  }

  @override
  void didUpdateWidget(covariant HocadoSwitch oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialValue != widget.initialValue) {
      currentValue = widget.initialValue;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Switch(
      value: currentValue,
      activeThumbColor: theme.colorScheme.primary,
      onChanged: (value) {
        setState(() {
          currentValue = value;
        });
        widget.onChanged(value);
      },
    );
  }
}
