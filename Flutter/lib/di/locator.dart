import 'package:get_it/get_it.dart';
import '../domain/like_cubit.dart';

final locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton(() => LikeCubit());
}
