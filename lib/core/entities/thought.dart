import 'package:cbt_flutter/core/utils/json/json_map.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:uuid/uuid.dart';

import 'package:json_annotation/json_annotation.dart';

part 'thought.g.dart';

@immutable
@JsonSerializable(explicitToJson: true)
class Thought extends Equatable {
  Thought({
    String? description,
    List<String>? intermediate,
    String? conclusion,
    String? corruption,
    String? uuid,
  }) :
      description = description ?? '',
      intermediate = intermediate ?? [],
      conclusion = conclusion ?? '',
      corruption = corruption ?? '',
      _uuid = uuid ?? const Uuid().v1(),
      isCreated = description?.trim().isNotEmpty ?? false,
      isCompleted = [description, conclusion, corruption]
        .indexWhere((item) => item?.trim().isEmpty ?? true) == -1;

  final String description;

  final List<String> intermediate;

  final String conclusion;
  
  final String corruption;

  final String _uuid;

  final bool isCreated;

  final bool isCompleted;

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

  
  JsonMap toJson() => _$ThoughtToJson(this);

  static Thought fromJson(JsonMap json) => _$ThoughtFromJson(json);

  @override
  List<Object> get props => [description, intermediate, conclusion, corruption, uuid];
}