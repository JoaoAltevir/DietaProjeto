import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:mydiet/app/data/model/alimento.dart';
import 'package:mydiet/app/data/model/refeicao.dart';
import 'package:mydiet/app/core/result.dart';
import 'package:mydiet/app/data/services/refeicao_database.dart';

class   RefeicaoRepository extends ChangeNotifier {
  final RefeicaoDatabase database;
  final List<Refeicao> _listaRefeicoes = [];
  DateTime _dataSelecionada = DateTime.now();
  DateTime get dataSelecionada => _dataSelecionada;

    RefeicaoRepository({required this.database}) {
      findAll();
    }
  UnmodifiableListView<Refeicao> get listaRefeicoes =>
      UnmodifiableListView(_listaRefeicoes);

  Result<bool, String> saveRefeicao(Refeicao refeicao) {
    try {
      database.createRefeicao(refeicao);
       _listaRefeicoes.add(refeicao);
      notifyListeners();
      return Ok(true);
    } on DatabaseException catch (_) {
      return Err('Erro ao salvar refeição no banco de dados');
    }
   
  }

  void remove(Refeicao refeicao) {
    database.deleteRefeicao(refeicao.id);
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

  Future<void> findAll() async {
   final List<Refeicao> refeicoes = database.findAll();
    _listaRefeicoes.addAll(refeicoes);
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
