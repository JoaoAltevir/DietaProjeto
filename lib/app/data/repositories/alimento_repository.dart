import 'dart:collection';

import 'package:mydiet/app/core/result.dart';
import 'package:flutter/material.dart';
import 'package:mydiet/app/data/model/alimento.dart';
import 'package:mydiet/app/data/services/alimento_database.dart'; 

class AlimentoRepository extends ChangeNotifier {
  final FoodDatabase database;
  final List<Alimento> _listaAlimentos = [];

  AlimentoRepository({required this.database}){
    getAll();
  }

  UnmodifiableListView<Alimento> get listaAlimentos =>
      UnmodifiableListView(_listaAlimentos);

  Future<void> getAll() async{
    final List<Alimento> alimentos = database.findAllFoods();
    _listaAlimentos.addAll(alimentos);
    //for (var alimento in alimentos) {
      //if (!_listaAlimentos.contains(alimento)){
        //_listaAlimentos.add(alimento);
      //}
    //}
    notifyListeners();

  }
  
  Result<bool, String> saveAlimento(Alimento alimento){
    try {
      database.createFood(alimento);
      _listaAlimentos.add(alimento);
      notifyListeners();
      return Ok(true);
    } on DatabaseException catch(_) {
      return Err('Erro ao inserir alimento no banco de dados');
    }
  }

  void remove(Alimento alimento) {
    int idAlimento = alimento.id;
    database.deleteFood(idAlimento);
    _listaAlimentos.remove(alimento);
    notifyListeners();
  }

  void removeList(List<Alimento> alimentos) {
    for (var alimento in alimentos) {
      int idAlimento = alimento.id;
      database.deleteFood(idAlimento);
      _listaAlimentos.remove(alimento);
    }
    notifyListeners();
  }

}
