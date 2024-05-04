import 'package:flutter/material.dart';

class UISlider extends StatelessWidget {
  const UISlider({
    super.key,
    this.label,
    required this.value,
    this.onChanged,
    this.actions,
    this.max = 10,
    this.readOnly = false,
  }) : divisions = max;
  final int value;
  final int max;
  final int divisions;
  final String? label;
  final List<Widget>? actions;
  final bool readOnly;
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
        Padding(
          padding: const EdgeInsets.only(right: 14),
          child: SliderTheme(
            data: SliderTheme.of(context).copyWith(
              trackShape: const CustomSliderTrackShape(),
              thumbShape: const CustomSliderThumbShape(),
              overlayShape: const CustomSliderOverlayShape(),
            ),
            child: Opacity(
              opacity: readOnly ? .25 : 1,
              child: IgnorePointer(
                ignoring: readOnly,
                child: Slider(
                  label: value.toString(),
                  value: value.toDouble(),
                  divisions: divisions,
                  min: 0,
                  max: max.toDouble(),
                  onChanged: onChanged == null
                    ? null
                    : (value) => onChanged!(value.toInt()),
                ),
              ),
            ),
          ),
        ),
      ]
    );
  }
}

class CustomSliderTrackShape extends RoundedRectSliderTrackShape {
  const CustomSliderTrackShape();
  @override
  Rect getPreferredRect({
    required RenderBox parentBox,
    Offset offset = Offset.zero,
    required SliderThemeData sliderTheme,
    bool isEnabled = false,
    bool isDiscrete = false,
  }) {
    final trackHeight = sliderTheme.trackHeight;
    final trackLeft = offset.dx;
    final trackTop = offset.dy + (parentBox.size.height - trackHeight!) / 2;
    final trackWidth = parentBox.size.width;
    return Rect.fromLTWH(trackLeft, trackTop, trackWidth, trackHeight);
  }
}

class CustomSliderThumbShape extends RoundSliderThumbShape {
  const CustomSliderThumbShape({super.enabledThumbRadius = 10.0});

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    required bool isDiscrete,
    required TextPainter labelPainter,
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required TextDirection textDirection,
    required double value,
    required double textScaleFactor,
    required Size sizeWithOverflow,
  }) {
    super.paint(context,
        center.translate(-(value - 0.5) / 0.5 * enabledThumbRadius, 0.0),
        activationAnimation: activationAnimation,
        enableAnimation: enableAnimation,
        isDiscrete: isDiscrete,
        labelPainter: labelPainter,
        parentBox: parentBox,
        sliderTheme: sliderTheme,
        textDirection: textDirection,
        value: value,
        textScaleFactor: textScaleFactor,
        sizeWithOverflow: sizeWithOverflow);
  }
}

class CustomSliderOverlayShape extends RoundSliderOverlayShape {
  final double thumbRadius;
  const CustomSliderOverlayShape({this.thumbRadius = 10.0});

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    required bool isDiscrete,
    required TextPainter labelPainter,
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required TextDirection textDirection,
    required double value,
    required double textScaleFactor,
    required Size sizeWithOverflow,
  }) {
    super.paint(
        context, center.translate(-(value - 0.5) / 0.5 * thumbRadius, 0.0),
        activationAnimation: activationAnimation,
        enableAnimation: enableAnimation,
        isDiscrete: isDiscrete,
        labelPainter: labelPainter,
        parentBox: parentBox,
        sliderTheme: sliderTheme,
        textDirection: textDirection,
        value: value,
        textScaleFactor: textScaleFactor,
        sizeWithOverflow: sizeWithOverflow);
  }
}
