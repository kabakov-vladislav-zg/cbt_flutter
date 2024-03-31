import 'package:flutter/material.dart';

class DiaryEditPage extends StatelessWidget {
  const DiaryEditPage({super.key, required this.noteId});

  final String noteId;

  static const routeName = '/edit';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('noteId $noteId'),
      ),
      body: const Center(
        child: Text('More Information Here'),
      ),
    );
  }
}
