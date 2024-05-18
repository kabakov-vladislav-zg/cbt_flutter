import 'package:flutter/material.dart';

class ExerciseOverviewLayout extends StatefulWidget {
  const ExerciseOverviewLayout({
    super.key,
    required this.onboarding,
    this.slivers = const <Widget>[],
  });

  final Widget onboarding;

  final List<Widget> slivers;

  @override
  State<ExerciseOverviewLayout> createState() => _ExerciseOverviewLayoutState();
}

class _ExerciseOverviewLayoutState extends State<ExerciseOverviewLayout> {

  late final DraggableScrollableController _draggableScrollableController;

  @override
  void initState() {
    _draggableScrollableController = DraggableScrollableController();
    _draggableScrollableController.addListener(() {
      if (_draggableScrollableController.size == 1) {
        print('1');
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _draggableScrollableController.dispose();
    super.dispose();
  }

  double get _minChildSize => 0.25;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: double.infinity,
          color: Colors.orange.shade100,
          child: SafeArea(child: widget.onboarding)
        ),
        DraggableScrollableSheet(
          initialChildSize: _minChildSize,
          minChildSize: _minChildSize,
          maxChildSize: 1,
          snap: true,
          controller: _draggableScrollableController,
          builder: (context, scrollController) {
            return Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
              ),
              child: Column(
                children: [
                  Expanded(
                    child: SafeArea(
                      child: CustomScrollView(
                        controller: scrollController,
                        slivers: widget.slivers,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ]
    );
  }
}
