import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class MyDatabase {
  Database? _instance;

  static final MyDatabase _database = MyDatabase._internal();

  MyDatabase._internal();

  factory MyDatabase() {
    return _database;
  }

  Future<Database> getInstance() async {
    if (_instance == null) {
      _instance = await _openMyDatabase();
    }

    return _instance!;
  }

  Future<Database> _openMyDatabase() async {
    final pathDatabase = await getDatabasesPath();
    final nameDatabase = 'database.db';
    final database = await openDatabase(
      join(pathDatabase, nameDatabase),
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE users(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            nome TEXT,
            email TEXT,
            cpf TEXT,
            cep TEXT,
            rua TEXT,
            numero INTEGER,
            bairro TEXT,
            cidade TEXT,
            uf TEXT,
            pais TEXT,
            pathImage TEXT
          );
        ''');
      },
    );

    return database;
  }
}
