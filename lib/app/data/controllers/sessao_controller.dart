import 'package:flutter/material.dart';
import 'package:mydiet/app/data/model/user.dart';
import 'package:mydiet/app/data/services/user_database.dart';

/// 🔐 SessionController - Gerencia autenticação e sessão do usuário
/// 
/// Responsável por:
/// - Inicializar sessão ao abrir o app
/// - Fazer login/registro de usuários
/// - Fazer logout
/// - Manter estado de autenticação
class SessionController extends ChangeNotifier {
  final UserDatabase userDatabase;
  
  User? _usuarioAtual;
  bool _isLoading = true; // 🔴 Inicia como true para carregar a sessão
  String? _errorMessage;

  SessionController({required this.userDatabase}) {
    _inicializarSessao(); // 🔴 Inicializa sessão de forma assíncrona
  }

  // ✅ Getters
  User? get usuarioAtual => _usuarioAtual;
  bool get isLoggedIn => _usuarioAtual != null;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  /// 🔴 Inicializa sessão ao abrir o app
  /// 
  /// Busca por um usuário com isLoggedIn=true
  /// Se encontrar, restaura a sessão
  /// Caso contrário, usuário vê tela de cadastro/login
  Future<void> _inicializarSessao() async {
    try {
      _isLoading = true;
      notifyListeners();
      
      // Permite que o build() aconteça ANTES de buscar no banco
      // Assim o splash screen é mostrado
      await Future.delayed(Duration.zero);
      
      final usuarios = userDatabase.findAllUsers();
      
      // Busca o primeiro usuário com isLoggedIn = true
      User? usuarioLogado;
      for (var usuario in usuarios) {
        if (usuario.isLoggedIn == true) {
          usuarioLogado = usuario;
          break;
        }
      }
      
      _usuarioAtual = usuarioLogado;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Erro ao inicializar sessão: $e';
      _isLoading = false;
      notifyListeners();
    }
  }

  /// ✅ Faz login do usuário
  /// 
  /// Procura por um usuário com username e pin corretos
  /// Garante que apenas UM usuário fica logado por vez
  Future<bool> login(String username, int pin) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    
    try {
      final usuarios = userDatabase.findAllUsers();
      
      // Procura por username + pin
      User? usuario;
      for (var u in usuarios) {
        if (u.username == username && u.pin == pin) {
          usuario = u;
          break;
        }
      }

      if (usuario == null) {
        _errorMessage = 'Usuário ou PIN incorretos';
        _isLoading = false;
        notifyListeners();
        return false;
      }

      // 🔴 Garante que apenas UM usuário está logado
      // Se outro usuário estava logado, faz logout dele
      for (var u in usuarios) {
        if (u.id != usuario.id && u.isLoggedIn) {
          u.isLoggedIn = false;
          userDatabase.updateUser(u);
        }
      }

      _usuarioAtual = usuario;
      usuario.isLoggedIn = true;
      userDatabase.updateUser(usuario);
      
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

  /// ✅ Registra novo usuário
  /// 
  /// Valida os dados e cria novo usuário no banco
  /// Garante que username é único
  Future<bool> registrar(String nome, String nomeUsuario, int pin) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // Validações básicas
      if (nome.isEmpty || nomeUsuario.isEmpty || pin.toString().length < 4) {
        _errorMessage = 'Dados inválidos. PIN deve ter no mínimo 4 dígitos';
        _isLoading = false;
        notifyListeners();
        return false;
      }

      final usuarios = userDatabase.findAllUsers();
      
      // 🔴 Valida se username já existe
      final userExists = usuarios.any((u) => u.username == nomeUsuario);
      if (userExists) {
        _errorMessage = 'Nome de usuário já existe';
        _isLoading = false;
        notifyListeners();
        return false;
      }

      // Faz logout de outros usuários (apenas um logado por vez)
      for (var u in usuarios) {
        if (u.isLoggedIn) {
          u.isLoggedIn = false;
          userDatabase.updateUser(u);
        }
      }

      // 🔴 Cria novo usuário com dados CORRETOS
      final novoUsuario = User(
        nome: nome,              // Nome completo
        username: nomeUsuario,   // Username para login
        pin: pin,
        isLoggedIn: true,
      );

      userDatabase.createUser(novoUsuario);

      // 🔴 Recupera o usuário criado COM ID do ObjectBox
      final usuariosAtualizados = userDatabase.findAllUsers();
      final usuarioCriado = usuariosAtualizados.lastWhere(
        (u) => u.username == nomeUsuario && u.pin == pin,
      );

      _usuarioAtual = usuarioCriado;
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

  /// ✅ Faz logout do usuário atual
  Future<void> logout() async {
    _isLoading = true;
    notifyListeners();
    
    try {
      if (_usuarioAtual != null) {
        _usuarioAtual!.isLoggedIn = false;
        userDatabase.updateUser(_usuarioAtual!);
      }
      _usuarioAtual = null;
      _errorMessage = null;
    } catch (e) {
      _errorMessage = 'Erro ao fazer logout: $e';
    }

    _isLoading = false;
    notifyListeners();
  }
}
