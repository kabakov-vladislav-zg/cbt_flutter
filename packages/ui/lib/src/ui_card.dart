import 'package:flutter/material.dart';

class UICard extends StatelessWidget {
  const UICard({
    super.key, 
    this.onTap,
    this.clickable = true,
    required this.child,
  });

  final VoidCallback? onTap;
  final bool clickable;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    Widget result = Container(
      padding: const EdgeInsets.all(16),
      child: child,
    );
    if (clickable && onTap != null) {
      result = InkWell(
        onTap: onTap,
        child: result,
      );
    }
    result = Card(
      clipBehavior: Clip.hardEdge,
      child: result,
    );
    return result;
  }
}