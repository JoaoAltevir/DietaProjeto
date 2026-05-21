import 'package:mydiet/app/data/objectbox_database.dart';
import 'package:mydiet/app/data/model/entitys/alimento.entity.dart';
import 'package:mydiet/app/data/model/alimento.dart';

class DatabaseException implements Exception {
  final String message;
  DatabaseException(this.message);
}

//falta implementar outras funções e alterar a parte do repository...
class FoodDatabase{
  final ObjectBoxDatabase objectBoxDatabase;

  FoodDatabase({required this.objectBoxDatabase});

  void createFood(Alimento alimento) {
    try {
      final alimentoBox = AlimentoBox()
        ..nome = alimento.nome
        ..carboidratos = alimento.carboidratos
        ..gordura = alimento.gordura
        ..proteina = alimento.proteina
        ..caloria = alimento.caloria
        ..unidadeMedida = alimento.unidadeMedida
        ..valorCota = alimento.valorCota;

      objectBoxDatabase.store.box<AlimentoBox>().put(alimentoBox);
    } catch (e) {
      throw DatabaseException('Falha ao inserir alimento: $e');
    }
  }

  List<Alimento> findAllFoods() {
    try {
      final alimentoBoxes = objectBoxDatabase.store.box<AlimentoBox>().getAll();
      return alimentoBoxes.map((box) => box.fromBox()).toList();
    } catch (e) {
      throw DatabaseException('Falha ao recuperar alimentos cadastrados: $e');
    }
  }

  void deleteFood(int id) {
    try {
      final alimentoDelete = objectBoxDatabase.store.box<AlimentoBox>().get(id);
      if (alimentoDelete != null) {
        objectBoxDatabase.store.box<AlimentoBox>().remove(alimentoDelete.id);
      } else {
        throw DatabaseException('Alimento não encontrado para exclusão');
      }
    } catch (e) {
      throw DatabaseException('Falha ao excluir alimento: $e');
    }
  }
}