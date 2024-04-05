import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:uuid/uuid.dart';

@immutable
class Thought extends Equatable {
  Thought({
    required this.description,
    this.intermediate = const [],
    this.conclusion = '',
    this.corruption = '',
    String? uuid,
  }) : _uuid = uuid ?? const Uuid().v1();

  final String description;

  final List<String> intermediate;

  final String conclusion;
  
  final String corruption;

  final String _uuid;

  String get uuid => _uuid;

  Thought copyWith({
    String? description,
    List<String>? intermediate,
    String? conclusion,
    String? corruption,
  }) {
    return Thought(
      description: description ?? this.description,
      intermediate: intermediate ?? this.intermediate,
      conclusion: conclusion ?? this.conclusion,
      corruption: corruption ?? this.corruption,
      uuid: _uuid,
    );
  }

  @override
  List<Object> get props => [description, intermediate, conclusion, uuid];
}