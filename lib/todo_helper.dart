// ignore_for_file: depend_on_referenced_packages

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'todos.dart';

class DBHelper {
  static Future<Database> initDB() async {
    var dbPath = await getDatabasesPath();
    String path = join(dbPath, 'todos.db');
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  static Future _onCreate(Database db, int version) async {
    const sql = '''CREATE TABLE todos(
      id INTEGER PRIMARY KEY,
      name TEXT,
      todo TEXT
    )''';
    await db.execute(sql);
  }

  static Future<int> createTodos(Todo todo) async {
    Database db = await DBHelper.initDB();
    return await db.insert('todos', todo.toJson());
  }

  static Future<List<Todo>> readTodos() async {
    Database db = await DBHelper.initDB();
    var todo = await db.query('todos', orderBy: 'name');
    List<Todo> todoList = todo.isNotEmpty
        ? todo.map((details) => Todo.fromJson(details)).toList()
        : [];
    return todoList;
  }

  static Future<int> updateTodos(Todo todo) async {
    Database db = await DBHelper.initDB();
    return await db.update('todos', todo.toJson(),
        where: 'id = ?', whereArgs: [todo.id]);
  }

  static Future<int> deleteTodos(int id) async {
    Database db = await DBHelper.initDB();
    return await db.delete('todos', where: 'id = ?', whereArgs: [id]);
  }
}
