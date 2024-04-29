import 'package:flutter/material.dart';

class UISlider extends StatelessWidget {
  const UISlider({
    super.key,
    this.label,
    required this.value,
    this.onChanged,
    this.actions,
    this.max = 10,
  }) : divisions = max;
  final int value;
  final int max;
  final int divisions;
  final String? label;
  final List<Widget>? actions;
  final void Function(int)? onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null || actions != null)
          Row(
            children: [
              if (label != null)
                Text(label!),
              const Spacer(),
              if (actions != null)
                Row(children: actions!)
            ],
          ),
        Slider(
          label: value.toString(),
          value: value.toDouble(),
          divisions: divisions,
          min: 0,
          max: max.toDouble(),
          onChanged: onChanged == null
            ? null
            : (value) => onChanged!(value.toInt()),
        ),
      ]
    );
  }

}