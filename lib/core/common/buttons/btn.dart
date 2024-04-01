import 'package:flutter/material.dart';
import 'package:control_style/control_style.dart';

class Btn extends StatelessWidget {
  const Btn({
    super.key,
    required this.onPressed,
    required this.text,
    this.block,
    this.isActive = true,
    this.large = false,
  });

  final VoidCallback onPressed;
  final String text;
  final bool isActive;
  final bool? block;
  final bool large;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: block != null && block == true ? double.infinity : null,
      height: large ? 60 : 50,
      child: TextButton(
          onPressed: isActive ? onPressed : null,
          style: TextButton.styleFrom(
            backgroundColor: isActive
                ? Colors.blue
                : Colors.grey,
            shape: DecoratedOutlinedBorder(
              child: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
          ),
          child: Text(
            text,
            style: TextStyle(
                color: isActive
                    ? Colors.white
                    : Colors.black,
                fontSize: large ? 20 : 16),
          )),
    );
  }
}
