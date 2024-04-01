import 'package:cbt_flutter/core/entities/json_map.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:json_annotation/json_annotation.dart';

part 'thought.g.dart';

@immutable
@JsonSerializable()
class Thought extends Equatable {
  const Thought({
    required this.description,
    this.intermediate = const [],
    this.conclusion = '',
    this.corruption = '',
  });

  final String description;

  final List<String> intermediate;

  final String conclusion;
  
  final String corruption;

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
    );
  }

  static Thought fromJson(JsonMap json) => _$ThoughtFromJson(json);

  JsonMap toJson() => _$ThoughtToJson(this);

  @override
  List<Object> get props => [description, intermediate, conclusion];
}