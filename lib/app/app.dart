import 'package:flutter/material.dart';
import 'package:mydiet/app/controllers/sessao_controller.dart';
import 'package:mydiet/app/theme/themecontroller.dart';
import 'package:provider/provider.dart';
import 'package:mydiet/app/pages/userPages/cadastro_page.dart';
import 'package:mydiet/app/pages/main_homepage.dart';

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
      home: Consumer<SessionController>(
        builder: (context, sessionController, _) {
          // Se usuário está logado, mostrar app principal
          // Se não, mostrar página de cadastro/login
          return sessionController.isLoggedIn 
            ? MainHome()
            : CadastroPage();
        },
      ),
    );
  }
}