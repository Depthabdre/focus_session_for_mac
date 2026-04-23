import 'package:get_it/get_it.dart';

import '../features/settings/di/settings_injection.dart';
import '../features/timer/di/timer_injection.dart';

final GetIt sl = GetIt.instance;

Future<void> initDependencies() async {
  await registerSettingsDependencies(sl);
  registerTimerDependencies(sl);
}
