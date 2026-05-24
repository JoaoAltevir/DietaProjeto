import 'package:mydiet/app/data/model/refeicao.dart';

class User {  
  
  String nome;
  int pin;
  List<Refeicao> refeicoes;
  bool isLoggedIn;

  User({
    required this.nome,
    required this.pin,
    this.refeicoes = const [],
    this.isLoggedIn = false,
  });

}