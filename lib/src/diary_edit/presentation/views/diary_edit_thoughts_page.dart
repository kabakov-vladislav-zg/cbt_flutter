import 'package:cbt_flutter/core/di/sl.dart';
import 'package:cbt_flutter/src/diary_edit/presentation/bloc/diary_edit_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DiaryEditPage extends StatelessWidget {
  const DiaryEditPage({super.key, required this.noteId});

  final String noteId;

  static const routeName = '/edit';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt.get<DiaryEditCubit>(),
      child: Scaffold(),
    );
  }
}

