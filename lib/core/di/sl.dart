import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

import 'sl.config.dart';

final getIt = GetIt.instance;

@InjectableInit()
Future<void> init() async => getIt.init();
