import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:mydiet/app/model/alimento.dart';
import 'package:mydiet/app/model/refeicao.dart';

class RefeicaoRepository extends ChangeNotifier {
  final List<Refeicao> _listaRefeicoes = [];
  DateTime _dataSelecionada = DateTime.now();
  DateTime get dataSelecionada => _dataSelecionada;

  UnmodifiableListView<Refeicao> get listaRefeicoes =>
      UnmodifiableListView(_listaRefeicoes);

  void saveRefeicao(Refeicao refeicao) {
    _listaRefeicoes.add(refeicao);
    notifyListeners();
  }

  void remove(Refeicao refeicao) {
    _listaRefeicoes.remove(refeicao);
    notifyListeners();
  }

  void removerAlimento(Refeicao refeicao, Alimento alimento) {
    refeicao.alimentoListaRefeicao.remove(alimento);
     if (refeicao.alimentoListaRefeicao.isEmpty) {
    _listaRefeicoes.remove(refeicao);
    }
    notifyListeners();
  }

  void saveAll(List<Refeicao> refeicoes) {
    for (var refeicao in refeicoes) {
      if (!_listaRefeicoes.contains(refeicao)) _listaRefeicoes.add(refeicao);
    }
    notifyListeners();
  }

  void setDataSelecionada(DateTime novaData) {
    _dataSelecionada = novaData;
    notifyListeners();
  }

  List<Refeicao> get refeicoesDoDia {
    return listaRefeicoes.where((refeicao) {
      return refeicao.dataRefeicao.year == _dataSelecionada.year &&
          refeicao.dataRefeicao.month == _dataSelecionada.month &&
          refeicao.dataRefeicao.day == _dataSelecionada.day;
    }).toList();
  }

  void editarAlimento() {
        notifyListeners();
      }
}
