import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'src/cubits/task_cubit.dart';
import 'src/cubits/theme_cubit.dart';  
import 'src/screens/home/home_screen.dart';
import 'src/theme/app_theme.dart';

void main() {
  runApp(const TaskManagerApp());
}

class TaskManagerApp extends StatelessWidget {
  const TaskManagerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => TaskCubit()),
        BlocProvider(create: (_) => ThemeCubit()),
      ],
      child: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (context, currentThemeMode) {
          return MaterialApp(
            title: 'Task Manager',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.light,
            darkTheme: AppTheme.dark,
            themeMode: currentThemeMode, 
            home: const HomeScreen(),
          );
        },
      ),
    );
  }
}