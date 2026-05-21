import 'package:objectbox/objectbox.dart';
import 'package:mydiet/app/data/model/refeicao.dart';
import 'package:mydiet/app/data/model/entitys/alimento.entity.dart';


@Entity()
class RefeicaoBox {
  @Id()
  int id = 0;
  String nomeRefeicao = "";
  @Index()
  DateTime? dataRefeicao;
  
  @Backlink('refeicao')
  final alimentoListaRefeicao = ToMany<AlimentoBox>();

  String periodoRefeicao = "";

  Refeicao fromBox() {
    return Refeicao(
      id: id,
      nomeRefeicao: nomeRefeicao,
      dataRefeicao: dataRefeicao ?? DateTime.now(),
      alimentoListaRefeicao: alimentoListaRefeicao.map((alimentoBox) => alimentoBox.fromBox()).toList(),
      periodoRefeicao: periodoRefeicao,
    );
  }
}
