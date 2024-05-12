import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class CbtNotesFilter extends Equatable {
  const CbtNotesFilter({
    this.uuid,
    this.isCompleted,
    this.dateFrom,
    this.dateTo,
    this.emotion,
    this.corruption,
  });

  final String? uuid;
  final bool? isCompleted;
  final DateTime? dateFrom;
  final DateTime? dateTo;
  final String? emotion;
  final String? corruption;

  CbtNotesFilter copyWithGetter({
    ValueGetter<String>? uuid,
    ValueGetter<bool>? isCompleted,
    ValueGetter<DateTime>? dateFrom,
    ValueGetter<DateTime>? dateTo,
    ValueGetter<String>? emotion,
    ValueGetter<String>? corruption,
  }) {
    return CbtNotesFilter(
      uuid: uuid != null ? uuid() : this.uuid,
      isCompleted: isCompleted != null ? isCompleted() : this.isCompleted,
      dateFrom: dateFrom != null ? dateFrom() : this.dateFrom,
      dateTo: dateTo != null ? dateTo() : this.dateTo,
      emotion: emotion != null ? emotion() : this.emotion,
      corruption: corruption != null ? corruption() : this.corruption,
    );
  }

  @override
  get props => [uuid, isCompleted, dateFrom, dateTo, emotion, corruption];
}