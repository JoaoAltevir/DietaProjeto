import 'package:mydiet/app/data/objectbox_database.dart';
import 'package:mydiet/app/data/model/entitys/refeicao.entity.dart';
import 'package:mydiet/app/data/model/refeicao.dart';

class DatabaseException implements Exception {
  final String message;
  DatabaseException(this.message);
}

class RefeicaoDatabase{
  final ObjectBoxDatabase objectBoxDatabase;

  RefeicaoDatabase({required this.objectBoxDatabase});

  void createRefeicao(Refeicao refeicao) {
    try {
      final refeicaoBox = RefeicaoBox()
        ..nomeRefeicao = refeicao.nomeRefeicao
        ..dataRefeicao = refeicao.dataRefeicao
        ..periodoRefeicao = refeicao.periodoRefeicao;

      objectBoxDatabase.store.box<RefeicaoBox>().put(refeicaoBox);
    } catch (e) {
      throw DatabaseException('Falha ao inserir refeição: $e');
    }
  }

  List<Refeicao> findAll() {
    try {
      final refeicaoBoxes = objectBoxDatabase.store.box<RefeicaoBox>().getAll();
      return refeicaoBoxes.map((box) => box.fromBox()).toList();
    } catch (e) {
      throw DatabaseException('Falha ao recuperar refeições cadastradas: $e');
    }
  }

  void deleteRefeicao(int id) {
    try {
      final refeicaoDelete = objectBoxDatabase.store.box<RefeicaoBox>().get(id);
      if (refeicaoDelete != null) {
        objectBoxDatabase.store.box<RefeicaoBox>().remove(refeicaoDelete.id);
      } else {
        throw DatabaseException('Refeição não encontrada para exclusão');
      }
    } catch (e) {
      throw DatabaseException('Falha ao excluir refeição: $e');
    }
  }
}