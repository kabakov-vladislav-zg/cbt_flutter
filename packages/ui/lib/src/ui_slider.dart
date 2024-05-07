import 'package:flutter/material.dart';

class UISlider extends StatefulWidget {
  const UISlider({
    super.key,
    this.label,
    this.value,
    this.initValue,
    required this.onChanged,
    this.onChangeEnd,
    this.actions,
    this.max = 10,
    this.readOnly = false,
  }) :
    divisions = max,
    assert(value == null || initValue == null);
  final int? value;
  final int? initValue;
  final int max;
  final int divisions;
  final String? label;
  final List<Widget>? actions;
  final bool readOnly;
  final void Function(int) onChanged;
  final void Function(int)? onChangeEnd;
  @override
  State<UISlider> createState() => _UISliderState();
}

class _UISliderState extends State<UISlider> {
  late final _initValue =  widget.initValue;
  late int _value = widget.value ?? _initValue ?? 0;

  int get value => _value;
  set value (int value) {
    _value = value;
    widget.onChangeEnd?.call(_value);
  }

  @override
  void didUpdateWidget(covariant UISlider oldWidget) {
    final value = widget.value;

    if (_initValue != null) {
      assert(value == null);
      return;
    }
    assert(value != null);

    if (value! != oldWidget.value) {
      setState(() {
        _value = value;
      });
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null || widget.actions != null)
          Row(
            children: [
              if (widget.label != null)
                Text(widget.label!),
              const Spacer(),
              if (widget.actions != null)
                Row(children: widget.actions!)
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
              opacity: widget.readOnly ? .25 : 1,
              child: IgnorePointer(
                ignoring: widget.readOnly,
                child: Slider(
                  label: _value.toString(),
                  value: _value.toDouble(),
                  divisions: widget.divisions,
                  min: 0,
                  max: widget.max.toDouble(),
                  onChanged: (value) {
                    setState(() {
                      _value = value.toInt();
                    });
                    widget.onChanged(_value);
                  },
                  onChangeEnd: widget.onChangeEnd == null
                    ? null
                    : (value) => widget.onChangeEnd!(_value),
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
