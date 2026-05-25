import 'package:mydiet/app/data/objectbox_database.dart';
import 'package:mydiet/app/data/model/entitys/user.entity.dart';
import 'package:mydiet/app/data/model/user.dart';

class DatabaseException implements Exception {
  final String message;
  DatabaseException(this.message);
  
  @override
  String toString() => message;
}

class UserDatabase {
  final ObjectBoxDatabase objectBoxDatabase;

  UserDatabase({required this.objectBoxDatabase});
  void createUser(User user) {
    try {
      final existingUser = _findByNameAndPinOrNull(user.nome, user.pin);
      if (existingUser != null) {
        throw DatabaseException('Usuário já existe com o mesmo nome e PIN');
      }
      final existingUsername = _findByUsernameOrNull(user.username);
      if (existingUsername != null) {
        throw DatabaseException('Nome de usuário já está em uso');
      }

      // Cria a entidade do ObjectBox
      final userBox = UserBox()
        ..nome = user.nome
        ..username = user.username
        ..pin = user.pin
        ..isLoggedIn = user.isLoggedIn;

      // Salva no banco (ObjectBox gera o ID automaticamente)
      objectBoxDatabase.store.box<UserBox>().put(userBox);
    } catch (e) {
      throw DatabaseException('Falha ao criar usuário: $e');
    }
  }
  List<User> findAllUsers() {
    try {
      final userBoxes = objectBoxDatabase.store.box<UserBox>().getAll();
      return userBoxes.map((box) => box.fromBox()).toList();
    } catch (e) {
      throw DatabaseException('Falha ao recuperar usuários: $e');
    }
  }
  User? findById(int id) {
    try {
      final userBox = objectBoxDatabase.store.box<UserBox>().get(id);
      return userBox?.fromBox();  // 🔴 Retorna null se não encontrar
    } catch (e) {
      throw DatabaseException('Falha ao recuperar usuário: $e');
    }
  }

  User? findByUsername(String username) {
    try {
      final userBoxes = objectBoxDatabase.store.box<UserBox>().getAll();
      final userBox = userBoxes.firstWhere(
        (box) => box.username == username,
      );
      return userBox.fromBox();
    } catch (e) {
      throw DatabaseException('Falha ao recuperar usuário por username: $e');
    }
  }

  /// ✅ DELETA usuário por ID
  void deleteUser(int id) {
    try {
      final userDelete = objectBoxDatabase.store.box<UserBox>().get(id);
      if (userDelete != null) {
        objectBoxDatabase.store.box<UserBox>().remove(userDelete.id);
      } else {
        throw DatabaseException('Usuário não encontrado para exclusão');
      }
    } catch (e) {
      throw DatabaseException('Falha ao excluir usuário: $e');
    }
  }

  /// ✅ ATUALIZA usuário existente
  /// 
  /// Nota: Usa o ID do usuário para encontrá-lo no banco
  /// Por isso é CRÍTICO que o ID esteja correto (veja user.entity.dart)
  void updateUser(User user) {
    try {
      final userBox = objectBoxDatabase.store.box<UserBox>().get(user.id);
      if (userBox != null) {
        userBox.nome = user.nome;
        userBox.username = user.username;
        userBox.pin = user.pin;
        userBox.isLoggedIn = user.isLoggedIn;
        objectBoxDatabase.store.box<UserBox>().put(userBox);
      } else {
        throw DatabaseException('Usuário com ID ${user.id} não encontrado para atualização');
      }
    } catch (e) {
      throw DatabaseException('Falha ao atualizar usuário: $e');
    }
  }
  User? _findByNameAndPinOrNull(String nome, int pin) {
    try {
      final userBoxes = objectBoxDatabase.store.box<UserBox>().getAll();
      final userBox = userBoxes.firstWhere(
        (box) => box.nome == nome && box.pin == pin,
      );
      return userBox.fromBox();
    } catch (e) {
      return null;
    }
  }
  User? _findByUsernameOrNull(String username) {
    try {
      final userBoxes = objectBoxDatabase.store.box<UserBox>().getAll();
      final userBox = userBoxes.firstWhere(
        (box) => box.username == username,
      );
      return userBox.fromBox();
    } catch (e) {
      return null;
    }
  }
}
