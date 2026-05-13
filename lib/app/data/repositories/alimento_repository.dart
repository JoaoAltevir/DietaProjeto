import 'dart:collection';

import 'package:mydiet/app/core/result.dart';
import 'package:flutter/material.dart';
import 'package:mydiet/app/data/model/alimento.dart';
import 'package:mydiet/app/data/services/alimento_database.dart'; 

class AlimentoRepository extends ChangeNotifier {
  final FoodDatabase database;
  List<Alimento> _listaAlimentos = [];

  AlimentoRepository({required this.database});

  UnmodifiableListView<Alimento> get listaAlimentos =>
      UnmodifiableListView(_listaAlimentos);

  Future<void> getAll() async{
    final List<Alimento> alimentos = database.findAllFoods();
    _listaAlimentos = [];
    for (var alimento in alimentos) {
      if (!_listaAlimentos.contains(alimento)){
        _listaAlimentos.add(alimento);
      }
    }
    notifyListeners();
  }
  
  Result<bool, String> saveAlimento(Alimento alimento){
    try {
      database.createFood(alimento);
      notifyListeners();
      return Ok(true);
    } on DatabaseException catch(_) {
      return Err('Erro ao inserir alimento no banco de dados');
    }
  }

  /*void remove(Alimento alimento) {
    _listaAlimentos.remove(alimento);
    notifyListeners();
  }*/
}
