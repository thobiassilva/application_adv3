import 'package:application_adv3/data/db.dart';
import 'package:application_adv3/models/user_model.dart';

class Repository {
  MyDatabase _myDatabase;
  Repository(this._myDatabase);

  Future<List<User>> getAll() async {
    print('Buscando todos os Usuarios');
    try {
      final instance = await _myDatabase.getInstance();
      final result = await instance.query('users');
      final users = result.map((user) => User.fromMap(user)).toList();
      print(users);
      return users;
    } catch (e) {
      print(e);
      throw 'Erro ao recuperar os usuário';
    }
  }

  Future<bool> insert(User user) async {
    print('Inserindo novo Usuario');
    print(user);
    try {
      final instance = await _myDatabase.getInstance();
      final result = await instance.insert('users', user.toMap());
      return result > 0;
    } catch (e) {
      print(e);
      throw 'Erro ao inserir os usuário';
    }
  }

  Future<bool> update(User user) async {
    print('Atualizando Usuario');
    print(user);
    try {
      final instance = await _myDatabase.getInstance();
      final result = await instance
          .update('users', user.toMap(), where: 'id = ?', whereArgs: [user.id]);
      return result > 0;
    } catch (e) {
      print(e);
      throw 'Erro ao atualizar os usuário';
    }
  }

  Future<bool> delete(User user) async {
    print('Deletando Usuario');
    print(user);
    try {
      final instance = await _myDatabase.getInstance();
      final result =
          await instance.delete('users', where: 'id = ?', whereArgs: [user.id]);
      return result > 0;
    } catch (e) {
      print(e);
      throw 'Erro ao deletar os usuário';
    }
  }
}
