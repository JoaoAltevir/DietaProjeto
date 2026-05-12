import 'package:objectbox/objectbox.dart';
import 'package:mydiet/app/data/model/alimento.dart';

@Entity()
class AlimentoBox {
  @Id()
  int id = 0;
  String nome = "";
  String carboidratos = "";
  String gordura = "";
  String proteina = "";
  String caloria = "";
  String unidadeMedida = "";
  String valorCota = "";

  Alimento fromBox() {
    return Alimento(
      id: id.toString(),
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
