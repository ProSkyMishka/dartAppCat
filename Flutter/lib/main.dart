import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../di/locator.dart';
import '../domain/like_cubit.dart';
import '../controllers/main_screen.dart';

void main() {
  setupLocator(); // инициализация get_it
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<LikeCubit>(
      create: (_) => locator<LikeCubit>(),
      child: MaterialApp(
        title: 'Кототиндер',
        theme: ThemeData(useMaterial3: true),
        home: MainScreen(),
      ),
    );
  }
}
