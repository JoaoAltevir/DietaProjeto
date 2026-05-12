import 'package:mydiet/app/data/model/alimento.dart';
import 'package:objectbox/objectbox.dart';
import 'package:mydiet/app/data/model/refeicao.dart';

@Entity()
class RefeicaoBox {
  @Id()
  int id = 0;
  String nomeRefeicao = "";
  DateTime dataRefeicao = DateTime.now();
  final List<Alimento> alimentoListaRefeicao = ToMany<Alimento>();
  String periodoRefeicao = "";

  Refeicao fromBox() {
    return Refeicao(
      id: id.toString(),
      nomeRefeicao: nomeRefeicao,
      dataRefeicao: dataRefeicao,
      alimentoListaRefeicao: alimentoListaRefeicao,
      periodoRefeicao: periodoRefeicao,
    );
  }
}
