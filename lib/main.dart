import 'package:flutter/material.dart';
import 'package:mydiet/app/app.dart';
import 'package:mydiet/app/data/repositories/alimento_repository.dart';
import 'package:mydiet/app/data/repositories/refeicao_repository.dart';
import 'package:mydiet/app/theme/themecontroller.dart';
import 'package:provider/provider.dart';
import 'package:mydiet/app/data/objectbox_database.dart';
import 'package:mydiet/app/data/services/alimento_database.dart';
import 'package:mydiet/app/data/services/refeicao_database.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final objectBoxDatabase = await startObjectBox();
  TODO final foodDatabase = FoodDatabase(objectBoxDatabase: objectBoxDatabase);
  //TODO final mealDatabase = RefeicaoDatabase(objectBoxDatabase: objectBoxDatabase);

  final alimentoRepository = AlimentoRepository(database: foodDatabase);
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => RefeicaoRepository(),
        ),
        ChangeNotifierProvider(
          create: (_) => ThemeController()
          ),
      ],
      child: App(alimentoRepository: alimentoRepository),
    ),
  );
}

