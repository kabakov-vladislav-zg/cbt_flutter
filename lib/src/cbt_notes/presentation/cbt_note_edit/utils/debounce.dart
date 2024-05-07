import 'package:flutter/material.dart';
import 'package:easy_debounce/easy_debounce.dart';

void debounce(VoidCallback callback, { bool debounced = false }) {
  const throttleTag = 'throttle';
  if(debounced) {
    EasyDebounce.debounce(
      throttleTag,
      const Duration(seconds: 5),
      () => callback(),
    );
  } else {
    EasyDebounce.cancel(throttleTag);
    callback();
  }
}