import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import '../models/todo.dart';

class DatabaseProvider extends ChangeNotifier {
  late Future<Database> _database;
  bool _isCompletedFilter = false;
  bool _sortByTitleAscending = true;
  bool get isCompletedFilter => _isCompletedFilter;
  bool get sortByTitleAscending => _sortByTitleAscending;

  void toggleCompletedFilter() {
    _isCompletedFilter = !_isCompletedFilter;
    notifyListeners();
  }

  void toggleSortByTitleAscending() {
    _sortByTitleAscending = !_sortByTitleAscending;
    notifyListeners();
  }

  DatabaseProvider() {
    _database = _initDatabase();
  }

  Future<Database> _initDatabase() async {
    var directory = await getApplicationDocumentsDirectory();
    var path = join(directory.path, 'todo.db');
    var database = await openDatabase(
      path,
      version: 3,
      onCreate: (db, version) {
        db.execute(
          'CREATE TABLE todo(id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT, is_completed INTEGER, due_date TEXT, notes TEXT)',
        );
      },
      onUpgrade: (db, oldVersion, newVersion) {
        if (oldVersion < 2) {
          db.execute('ALTER TABLE todo ADD COLUMN due_date TEXT');
        }
        if (oldVersion < 3) {
          db.execute('ALTER TABLE todo ADD COLUMN notes TEXT');
        }
      },
    );
    return database;
  }

  Future<List<Todo>> getTodos() async {
    Database db = await _database;
    final List<Map<String, dynamic>> todos = await db.query('todo');

    // Apply filters
    List<Map<String, dynamic>> filteredTodos = todos.where((todo) {
      if (_isCompletedFilter) {
        return todo['is_completed'] == 1;
      } else {
        return true;
      }
    }).toList();

    // Sort
    filteredTodos.sort((a, b) {
      if (_sortByTitleAscending) {
        return a['title'].compareTo(b['title']);
      } else {
        return b['title'].compareTo(a['title']);
      }
    });

    return List.generate(
      filteredTodos.length,
      (i) => Todo(
        id: filteredTodos[i]['id'],
        title: filteredTodos[i]['title'],
        isCompleted: filteredTodos[i]['is_completed'] == 1,
        dueDate: filteredTodos[i]['due_date'],
        notes: filteredTodos[i]['notes'],
      ),
    );
  }

  Future<void> addTodo(String title, String dueDate, String notes) async {
    Database db = await _database;
    await db.insert(
      'todo',
      {'title': title, 'is_completed': 0, 'due_date': dueDate, 'notes': notes},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    notifyListeners();
  }

  Future<void> updateTodoStatus(int id, bool isCompleted) async {
    Database db = await _database;
    await db.update(
      'todo',
      {'is_completed': isCompleted ? 1 : 0},
      where: 'id = ?',
      whereArgs: [id],
    );
    notifyListeners();
  }

  Future<void> deleteTodo(int id) async {
    Database db = await _database;
    await db.delete(
      'todo',
      where: 'id = ?',
      whereArgs: [id],
    );
    notifyListeners();
  }

  Future<void> updateTodoTitle(int id, String newTitle) async {
    Database db = await _database;
    await db.update(
      'todo',
      {'title': newTitle},
      where: 'id = ?',
      whereArgs: [id],
    );
    notifyListeners();
  }

  Future<void> updateTodoNotes(int id, String newNotes) async {
    Database db = await _database;
    await db.update(
      'todo',
      {'notes': newNotes},
      where: 'id = ?',
      whereArgs: [id],
    );
    notifyListeners();
  }
}
