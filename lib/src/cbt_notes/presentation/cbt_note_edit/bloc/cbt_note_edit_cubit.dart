import 'package:cbt_flutter/core/entities/cbt_note.dart';
import 'package:cbt_flutter/core/entities/emotion.dart';
import 'package:cbt_flutter/core/entities/thought.dart';
import 'package:cbt_flutter/src/cbt_notes/domain/update_cbt_note.dart';
import 'package:cbt_flutter/src/cbt_notes/domain/update_cbt_notes_stream.dart';
import 'package:injectable/injectable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'cbt_note_edit_state.dart';

@injectable
class CbtNoteEditCubit extends Cubit<CbtNoteEditState> {
  @factoryMethod
  CbtNoteEditCubit(@factoryParam CbtNote cbtNote, {
    required UpdateCbtNote updateCbtNote,
    required UpdateCbtNotesStream updateCbtNotesStream,
  }) :
    _updateCbtNote = updateCbtNote,
    _updateCbtNotesStream = updateCbtNotesStream,
    super(CbtNoteEditState(cbtNote: cbtNote));
    
  final UpdateCbtNote _updateCbtNote;
  final UpdateCbtNotesStream _updateCbtNotesStream;
  static const debouncerTag = 'ThrottledUpdateCbtNote';

  void updateTrigger(String trigger) {
    _emitCbtNote(trigger: trigger);
  }

  void insertThoughtList(List<String> list) {
    final thoughts = list
      .map((description)
        => Thought(description: description))
      .toList();
    _emitCbtNote(thoughts: thoughts);
  }

  ({int index, Thought thought}) insertThought({
    String? description,
    List<String>? intermediate,
    String? conclusion,
    String? corruption,
  }) {
    final thoughts = [...state.cbtNote.thoughts];
    final thought = Thought(
      description: description,
      intermediate: intermediate,
      conclusion: conclusion,
      corruption: corruption,
    );
    thoughts.add(thought);
    _emitCbtNote(thoughts: thoughts);
    return (index: thoughts.length, thought: thought);
  }

  void updateThought(int index, {
    String? description,
    List<String>? intermediate,
    String? conclusion,
    String? corruption,
  }) {
    final thoughts = [...state.cbtNote.thoughts];
    thoughts[index] = thoughts[index].copyWith(
      description: description,
      intermediate: intermediate,
      conclusion: conclusion,
      corruption: corruption,
    );
    _emitCbtNote(thoughts: thoughts);
  }

  void removeThought(int index) {
    final thoughts = [...state.cbtNote.thoughts];
    thoughts.removeAt(index);
    _emitCbtNote(thoughts: thoughts);
  }

  void removeEmptyFields() {
    final thoughts = [...state.cbtNote.thoughts];
    thoughts.removeWhere((Thought thought) => thought.description.trim().isEmpty);
    _emitCbtNote(thoughts: thoughts);
  }

  ({int index, Emotion emotion}) insertEmotion({
    required String name,
    int? intensityFirst,
    int? intensitySecond,
  }) {
    final emotions = [...state.cbtNote.emotions];
    final emotion = Emotion(
      name: name,
      intensityFirst: intensityFirst,
      intensitySecond: intensitySecond,
    );
    emotions.add(emotion);
    _emitCbtNote(emotions: emotions);
    return (index: emotions.length, emotion: emotion);
  }

  void updateEmotion(int index, {
    String? name,
    int? intensityFirst,
    int? intensitySecond,
  }) {
    final emotions = [...state.cbtNote.emotions];
    emotions[index] = emotions[index].copyWith(
      name: name,
      intensityFirst: intensityFirst,
      intensitySecond: intensitySecond,
    );
    _emitCbtNote(emotions: emotions);
  }

  void removeEmotion(int index) {
    final emotions = [...state.cbtNote.emotions];
    emotions.removeAt(index);
    _emitCbtNote(emotions: emotions);
  }

  Future<void> _emitCbtNote({
    String? trigger,
    List<Thought>? thoughts,
    List<Emotion>? emotions,
    bool? isCreated,
    bool? isCompleted,
  }) async {
    print('_emitCbtNote');
    final cbtNote = state.cbtNote.copyWith(
      trigger: trigger,
      thoughts: thoughts,
      emotions: emotions,
      isCreated: isCreated,
      isCompleted: isCompleted,
    );
    emit(state.copyWith(cbtNote: cbtNote));
    await _updateCbtNote(cbtNote);
    await _updateCbtNotesStream();
  }

  void setStep(EditStep step) {
    switch (step) {
      case EditStep.creation:
        _emitCbtNote(isCreated: false, isCompleted: false);
        break;
      case EditStep.deconstruction:
        assert(isCreated());
        _emitCbtNote(isCreated: true, isCompleted: false);
        break;
      case EditStep.viewing:
        assert(isCompleted());
        _emitCbtNote(isCreated: true, isCompleted: true);
        break;
      default:
    }
  }

  List<EditStep> getAvaibleSteps() {
    return [
      EditStep.creation,
      if (state.cbtNote.isCreated) EditStep.deconstruction,
      if (state.cbtNote.isCompleted) EditStep.viewing,
    ];
  }

  bool isCreated() {
    final trigger = state.cbtNote.trigger;
    final thoughts = state.cbtNote.thoughts;
    final emotions = state.cbtNote.emotions;
    return trigger.trim().isNotEmpty
      && thoughts.isNotEmpty
      && emotions.isNotEmpty;
  }

  bool isCompleted() {
    final thoughts = state.cbtNote.thoughts;
    if(!isCreated()) return false;
    return -1 == thoughts
      .indexWhere((thought) => !thought.isCompleted);
  }
}
