import 'package:mydiet/app/data/model/alimento.dart';
import 'package:mydiet/app/data/model/user.dart';

class Refeicao {
  int id;
  String nomeRefeicao;
  DateTime dataRefeicao;
  List<Alimento> alimentoListaRefeicao;
  String periodoRefeicao;
  User? user;

  Refeicao({
    this.id = 0,
    required this.nomeRefeicao,
    required this.dataRefeicao,
    required this.alimentoListaRefeicao,
    required this.periodoRefeicao,
    required this.user,
  });
}
