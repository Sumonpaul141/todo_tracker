import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todotrack/models/models.dart';
import 'package:todotrack/models/todo.dart';

class DatabaseManager{
  Database _database;
  String taskTableName = "task";
  String colTaskId = "taskId";
  String colTaskTitle= "taskTitle";
  String colTaskDesc = "taskDescription";


  String todoTableName = "todo";
  String colTodoId = "todoId";
  String colTodoTitle= "todoTitle";
  String colTodoIsDone = "isDone";
  String colTodoTaskID = "taskId";

  Future openDb() async {
    _database = await openDatabase(
      join(await getDatabasesPath(), "task.db"),
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute("CREATE TABLE $taskTableName($colTaskId INTEGER PRIMARY KEY, $colTaskTitle TEXT, $colTaskDesc TEXT)");
        await db.execute("CREATE TABLE $todoTableName($colTodoId INTEGER PRIMARY KEY, $colTodoTitle TEXT, $colTodoIsDone int, $colTodoTaskID int)");
      }
    );
  }

  Future<void> insertTask(Task task) async {
    await openDb();
    await _database.insert(
      taskTableName,
      task.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> insertTodo(Todo todo) async {
    await openDb();
    await _database.insert(
      todoTableName,
      todo.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Task>> getAllTasks() async {
    await openDb();
    final List<Map<String, dynamic>> maps = await _database.rawQuery("SELECT * FROM $taskTableName ORDER BY $colTaskId DESC");
    return List.generate(maps.length, (i) {
      return Task(
        taskId: maps[i][colTaskId],
        taskTitle: maps[i][colTaskTitle],
        taskDescription: maps[i][colTaskDesc],
      );
    });
  }

  Future<List<Todo>> getAllTodos(int taskId) async {
    await openDb();
    final List<Map<String, dynamic>> maps = await _database.rawQuery("SELECT * FROM $todoTableName WHERE $colTodoTaskID = $taskId");
    return List.generate(maps.length, (i) {
      return Todo(
        todoId: maps[i][colTodoId],
        todoTitle: maps[i][colTodoTitle],
        todoIsDone: maps[i][colTodoIsDone],
        taskId: maps[i][colTaskId],
      );
    });
  }

  Future<void> deleteTask(int id) async {
    await openDb();
    await _database.rawDelete("DELETE FROM $taskTableName WHERE $colTaskId = '$id'");
    await _database.rawDelete("DELETE FROM $todoTableName WHERE $colTodoTaskID = '$id'");
  }

  Future<void> deleteTodo(int id) async {
    await openDb();
    await _database.rawDelete("DELETE FROM $todoTableName WHERE $colTodoId = '$id'");
  }

  Future<void> updateTodoDone(int id, int isDone) async {
    await openDb();
    await _database.rawUpdate("UPDATE todo SET isDone = '$isDone' WHERE $colTodoId = '$id'");
  }

}