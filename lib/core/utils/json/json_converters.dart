import 'dart:convert';

import 'package:cbt_flutter/core/utils/json/json_map.dart';

bool boolFromJson(String flag) => flag == 'true';
String boolToJson(bool flag) => flag ? 'true' : 'false';

DateTime dateFromJson(int time) => DateTime.fromMillisecondsSinceEpoch(time);
int dateToJson(DateTime time) => time.millisecondsSinceEpoch;

List<T> listFromJson<T>(String json, T Function(JsonMap) fromJson)
  => (jsonDecode(json) as List).map((data) => fromJson(data)).toList();