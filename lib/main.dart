import 'package:flutter/material.dart';
import 'package:mydiet/app/app.dart';
import 'package:mydiet/app/data/controllers/alimento_controller.dart';
import 'package:mydiet/app/data/controllers/refeicao_controller.dart';
import 'package:mydiet/app/theme/themecontroller.dart';
import 'package:provider/provider.dart';
import 'package:mydiet/app/data/objectbox_database.dart';
import 'package:mydiet/app/data/services/alimento_database.dart';
import 'package:mydiet/app/data/services/refeicao_database.dart';
import 'package:mydiet/app/data/services/user_database.dart';
import 'package:mydiet/app/data/controllers/sessao_controller.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final objectBoxDatabase = await startObjectBox();

  runApp(
    MultiProvider(
      providers: [
        // ObjectBox Database
        Provider<ObjectBoxDatabase>(
          create: (_) => objectBoxDatabase,
        ),
        
        // Food Database & Repository
        Provider<FoodDatabase>(
          create: (_) => FoodDatabase(objectBoxDatabase: objectBoxDatabase),
        ),
        ChangeNotifierProvider(
          create: (context) => AlimentoRepository(database: context.read()),
        ),

        // Refeicao Database & Repository
        Provider<RefeicaoDatabase>(
          create: (_) => RefeicaoDatabase(objectBoxDatabase: objectBoxDatabase),
        ),
        ChangeNotifierProvider(
          create: (context) => RefeicaoRepository(database: context.read()),
        ),
        Provider<UserDatabase>(
          create: (_) => UserDatabase(objectBoxDatabase: objectBoxDatabase),
        ),
        ChangeNotifierProvider(
          create: (context) => SessionController(userDatabase: context.read()),
        ),

        // User Preferences Repository
        //ChangeNotifierProvider(
        //  create: (context) => UserPreferencesRepository(
         //   objectBoxDatabase: objectBoxDatabase,
        //  ),
       // ),

        // Theme Controller
        ChangeNotifierProvider(create: (_) => ThemeController()),
      ],
      child: App(),
    ),
  );
}
