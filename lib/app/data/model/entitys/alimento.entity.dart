import 'package:mydiet/app/data/model/entitys/refeicao.entity.dart';
import 'package:objectbox/objectbox.dart';
import 'package:mydiet/app/data/model/alimento.dart';

@Entity()
class AlimentoBox {
  @Id()
  int id = 0;
  String nome;
  String carboidratos;
  String gordura;
  String proteina;
  String caloria;
  String unidadeMedida;
  String valorCota;

  final refeicao = ToOne<RefeicaoBox>();

  AlimentoBox()
      : nome = "",
        carboidratos = "",
        gordura = "",
        proteina = "",
        caloria = "",
        unidadeMedida = "",
        valorCota = "";

  Alimento fromBox() {
    return Alimento(
      id: id,
      nome: nome,
      carboidratos: carboidratos,
      gordura: gordura,
      proteina: proteina,
      caloria: caloria,
      unidadeMedida: unidadeMedida,
      valorCota: valorCota,
    );
  }
}
