import 'package:flutter/material.dart';
import 'package:mydiet/app/data/controllers/sessao_controller.dart';
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
          // 🆕 Mostrar splash screen enquanto carrega a sessão
          if (sessionController.isLoading) {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
          if (sessionController.isLoggedIn) {
            return const MainHome();
          }
          return const CadastroPage();
        },
      ),
    );
  }
}