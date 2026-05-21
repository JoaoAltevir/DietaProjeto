import 'package:flutter/material.dart';
import 'package:mydiet/app/app.dart';
import 'package:mydiet/app/data/repositories/alimento_repository.dart';
import 'package:mydiet/app/data/repositories/refeicao_repository.dart';
import 'package:mydiet/app/theme/themecontroller.dart';
import 'package:provider/provider.dart';
import 'package:mydiet/app/data/objectbox_database.dart';
import 'package:mydiet/app/data/services/alimento_database.dart';
//TODOimport 'package:mydiet/app/data/services/refeicao_database.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final objectBoxDatabase = await startObjectBox();

  runApp(
    MultiProvider(
      providers: [
        Provider<FoodDatabase>(
          create: (_) => FoodDatabase(objectBoxDatabase: objectBoxDatabase),
        ),
        ChangeNotifierProvider(
          create: (context) => AlimentoRepository(database: context.read()),
        ),
        ChangeNotifierProvider(
          create: (_) => RefeicaoRepository(),
        ),
        ChangeNotifierProvider(create: (_) => ThemeController()),
      ],
      child: App(),
    ),
  );
}
