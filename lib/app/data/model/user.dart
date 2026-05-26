import 'package:mydiet/app/data/model/refeicao.dart';

class User {  
  
  int id;
  String nome;
  String username;
  int pin;
  List<Refeicao> refeicoes;
  bool isLoggedIn;

  User({
    this.id = 0,
    required this.nome,
    required this.username,
    required this.pin,
    this.refeicoes = const [],
    this.isLoggedIn = false,
  });

}