import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:uuid/uuid.dart';


@immutable
class Emotion extends Equatable {
  Emotion({
    required this.name,
    this.intensityFirst = 0,
    int? intensitySecond,
    String? uuid,
  }) :
    intensitySecond = intensitySecond ?? intensityFirst,
    _uuid = uuid ?? const Uuid().v1();

  final String name;

  final int intensityFirst;

  final int intensitySecond;

  final String _uuid;

  String get uuid => _uuid;

  Emotion copyWith({
    String? name,
    int? intensityFirst,
    int? intensitySecond,
  }) {
    return Emotion(
      name: name ?? this.name,
      intensityFirst: intensityFirst ?? this.intensityFirst,
      intensitySecond: intensitySecond ?? this.intensitySecond,
      uuid: _uuid,
    );
  }

  @override
  List<Object> get props => [name, intensityFirst, intensitySecond, uuid];
}