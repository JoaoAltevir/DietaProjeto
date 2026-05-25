import 'package:mydiet/app/data/objectbox_database.dart';
import 'package:mydiet/app/data/model/entitys/user.entity.dart';
import 'package:mydiet/app/data/model/user.dart';

class DatabaseException implements Exception {
  final String message;
  DatabaseException(this.message);
}

class UserDatabase {
  final ObjectBoxDatabase objectBoxDatabase;

  UserDatabase({required this.objectBoxDatabase});

  void createUser(User user) {
    try {
      //validações para nome e PIN do usuário
      if (user.nome.isEmpty) {
        if(user.pin.toString().isEmpty) {
           throw DatabaseException('O nome do usuário não pode ser vazio e o PIN deve ter 4 dígitos');
        }
        throw DatabaseException('O nome do usuário não pode ser vazio');
      }else if (user.pin.toString().isEmpty) {
        throw DatabaseException('O PIN não pode estar vazio!');
      }
      //validação para verificar se usuário já existe
      final existingUser = _findByNameAndPin(user.nome, user.pin);
      if (existingUser.nome.isNotEmpty) {
        throw DatabaseException('Usuário já existe com o mesmo nome e PIN');
      }else{
        final userBox = UserBox()
          ..nome = user.nome
          ..pin = user.pin
          ..isLoggedIn = user.isLoggedIn;

        objectBoxDatabase.store.box<UserBox>().put(userBox);
      }
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

  User findById(int id) {
    try {
      final userBox = objectBoxDatabase.store.box<UserBox>().get(id);
      if (userBox != null) {
        return userBox.fromBox();
      } else {
        throw DatabaseException('Usuário não encontrado');
      }
    } catch (e) {
      throw DatabaseException('Falha ao recuperar usuário: $e');
    }
  }

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

  User _findByNameAndPin(String nome, int pin) {
    try {
      final userBoxes = objectBoxDatabase.store.box<UserBox>().getAll();
      final userBox = userBoxes.firstWhere(
        (box) => box.nome == nome && box.pin == pin,
      );
      return userBox.fromBox();
    } catch (e) {
      throw DatabaseException('Falha ao recuperar usuário por nome e PIN: $e');
    }
  }

  void updateUser(User user){
    try{
        
    }catch (e){

    }
  }
}

