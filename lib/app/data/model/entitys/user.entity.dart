import 'package:objectbox/objectbox.dart';
import 'package:mydiet/app/data/model/entitys/refeicao.entity.dart';
import 'package:mydiet/app/data/model/user.dart';


@Entity()
class UserBox{
  @Id()
  int id = 0;
  String nome = "";
  String username = "";
  int pin = 0;

  @Backlink('user')
  final refeicoes = ToMany<RefeicaoBox>();

  bool isLoggedIn = false;

  User fromBox() {
    return User(
      id: id,
      nome: nome,
      username: username,
      pin: pin,
      refeicoes: refeicoes.map((refeicaoBox) => refeicaoBox.fromBox()).toList(),
      isLoggedIn: isLoggedIn,
    );
  }
}