import 'package:flutter/material.dart';
import 'package:mydiet/app/data/model/user.dart';
import 'package:mydiet/app/data/services/user_database.dart';

class SessionController extends ChangeNotifier {
  final UserDatabase userDatabase;
  
  User? _usuarioAtual;
  bool _isLoading = false;
  String? _errorMessage;

  SessionController({required this.userDatabase}){
    _verificarUserLogged();
  }

  User? get usuarioAtual => _usuarioAtual;
  bool get isLoggedIn => _usuarioAtual != null;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<bool> login(String username, int pin) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      final usuarios = userDatabase.findAllUsers();
      final usuario = usuarios.firstWhere(
        (u) => u.username == username && u.pin == pin,
        orElse: () => User(nome: '', username: '', pin: 0, refeicoes: [], isLoggedIn: false),
      );

      if (usuario.username.isEmpty) {
        _errorMessage = 'Usuário ou PIN incorretos';
        _isLoading = false;
        notifyListeners();
        return false;
      }

      _usuarioAtual = usuario;
      usuario.isLoggedIn = true;
      _isLoading = false;
      _errorMessage = null;
      notifyListeners();
      return true;
      
    } catch (e) {
      _errorMessage = 'Erro ao fazer login: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> registrar(String nome, String nomeUsuario, int pin) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      if (nome.isEmpty || nomeUsuario.isEmpty || pin.toString().length < 4) {
        _errorMessage = 'Dados inválidos. PIN deve ter no mínimo 4 dígitos';
        _isLoading = false;
        notifyListeners();
        return false;
      }

      final novoUsuario = User(
        nome: nomeUsuario,
        username: nomeUsuario,
        pin: pin,
        isLoggedIn: true,
      );

      userDatabase.createUser(novoUsuario);

      final usuarios = userDatabase.findAllUsers();
      _usuarioAtual = usuarios.firstWhere(
        (u) => u.nome == nomeUsuario && u.pin == pin,
      );

      _isLoading = false;
      _errorMessage = null;
      notifyListeners();
      return true;

    } catch (e) {
      _errorMessage = 'Erro ao registrar: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  void logout() {
    if (_usuarioAtual != null) {
      _usuarioAtual!.isLoggedIn = false;
    }
    _usuarioAtual = null;
    _errorMessage = null;
    notifyListeners();
  }

  void _verificarUserLogged(){
    _isLoading = true;
    final usuarios = userDatabase.findAllUsers();
    for(var usuario in usuarios){
      if(usuario.isLoggedIn == true){
        _usuarioAtual = usuario;
        break;
      }
    }
    
    _isLoading = false;
    notifyListeners();
  }

}