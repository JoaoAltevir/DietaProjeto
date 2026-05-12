import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:mydiet/app/model/alimento.dart';

class AlimentoRepository extends ChangeNotifier {
  final List<Alimento> _listaAlimentos = [];

  UnmodifiableListView<Alimento> get listaAlimentos =>
      UnmodifiableListView(_listaAlimentos);

  void saveAll(List<Alimento> alimentos) {
    for (var alimento in alimentos) {
      if (!_listaAlimentos.contains(alimento)) _listaAlimentos.add(alimento);
    }
    notifyListeners();
  }

  void saveAlimento(Alimento alimento) {
    _listaAlimentos.add(alimento);
    notifyListeners();
  }

  void remove(Alimento alimento) {
    _listaAlimentos.remove(alimento);
    notifyListeners();
  }
}
