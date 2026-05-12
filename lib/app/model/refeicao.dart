import 'package:mydiet/app/model/alimento.dart';

class Refeicao {
  String id;
  String nomeRefeicao;
  DateTime dataRefeicao;
  List<Alimento> alimentoListaRefeicao;
  String periodoRefeicao;

  Refeicao({this.id = '', required this.nomeRefeicao,required this.dataRefeicao,required this.alimentoListaRefeicao,required this.periodoRefeicao});
}