import 'package:flutter/material.dart';
import 'package:mydiet/app/data/repositories/alimento_repository.dart';
import 'package:mydiet/app/pages/main_homepage.dart';
import 'package:mydiet/app/theme/themecontroller.dart';
import 'package:provider/provider.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = context.watch<ThemeController>();
    return MaterialApp(
      title: 'MyDiet',
      debugShowCheckedModeBanner: false,
      themeMode: themeController.themeMode,
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.blue,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
      ),
      home: MainHome(),
    );
  }
}
