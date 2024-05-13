import 'package:flutter/material.dart';

class UIDraggableScrollableSheet extends StatefulWidget {
  const UIDraggableScrollableSheet({
    super.key,
    this.height = 300,
    this.heading,
    this.slivers = const <Widget>[],
  });

  final double height;

  final Widget? heading;

  final List<Widget> slivers;

  @override
  State<UIDraggableScrollableSheet> createState() => _UIDraggableScrollableSheetState();
}

class _UIDraggableScrollableSheetState extends State<UIDraggableScrollableSheet> {

  late final DraggableScrollableController _draggableScrollableController;

  @override
  void initState() {
    _draggableScrollableController = DraggableScrollableController();
    super.initState();
  }

  @override
  void dispose() {
    _draggableScrollableController.dispose();
    super.dispose();
  }

  void _onVerticalDragUpdate(DragUpdateDetails details) {
    double sheetPosition = _draggableScrollableController.size;
    sheetPosition -= details.delta.dy / 800;
    if (sheetPosition < 0.25) {
      sheetPosition = 0.25;
    }
    if (sheetPosition > 1.0) {
      sheetPosition = 1.0;
    }
    _draggableScrollableController.jumpTo(sheetPosition);
  }

  @override
  Widget build(BuildContext context) {
    final minChildSize = 1 - widget.height / MediaQuery.of(context).size.height;

    return SafeArea(
      child: Stack(
        children: [
          SizedBox(
            height: widget.height,
            child: widget.heading,
          ),
          DraggableScrollableSheet(
            initialChildSize: minChildSize,
            minChildSize: minChildSize,
            maxChildSize: 1,
            controller: _draggableScrollableController,
            builder: (context, scrollController) {
              return Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
                ),
                child: Column(
                  children: [
                    _Grabber(
                      onVerticalDragUpdate: _onVerticalDragUpdate,
                    ),
                    Expanded(
                      child: CustomScrollView(
                        controller: scrollController,
                        slivers: widget.slivers,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ]
      ),
    );
  }
}

class _Grabber extends StatelessWidget {
  const _Grabber({
    required this.onVerticalDragUpdate,
  });

  final ValueChanged<DragUpdateDetails> onVerticalDragUpdate;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onVerticalDragUpdate: onVerticalDragUpdate,
      child: Container(
        width: double.infinity,
        color: Colors.transparent,
        height: 42,
        child: Center(
          child: Container(
            width: 32.0,
            height: 4.0,
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
        ),
      ),
    );
  }
}