import 'package:objectbox/objectbox.dart';
import 'package:mydiet/app/data/model/refeicao.dart';
import 'package:mydiet/app/data/model/entitys/alimento.entity.dart';
import 'package:mydiet/app/data/model/entitys/user.entity.dart';
import 'package:mydiet/app/data/model/user.dart';

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

  final user = ToOne<UserBox>();

  Refeicao fromBox() {
    return Refeicao(
      id: id,
      nomeRefeicao: nomeRefeicao,
      dataRefeicao: dataRefeicao ?? DateTime.now(),
      alimentoListaRefeicao: alimentoListaRefeicao.map((alimentoBox) => alimentoBox.fromBox()).toList(),
      periodoRefeicao: periodoRefeicao,
      user: user.target?.fromBox() ?? User(nome: "", pin: 0, refeicoes: [], isLoggedIn: false),
    );
  }
}
