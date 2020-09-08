import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todotrack/models/models.dart';

class DatabaseManager{
  Database _database;
  String taskTableName = "task";
  String colTaskId = "taskId";
  String colTaskTitle= "taskTitle";
  String colTaskDesc = "taskDescription";

  Future openDb() async {
    _database = await openDatabase(
      join(await getDatabasesPath(), "task.db"),
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute("CREATE TABLE $taskTableName($colTaskId INTEGER PRIMARY KEY, $colTaskTitle TEXT, $colTaskDesc TEXT)");
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

  Future<List<Task>> getAllTasks() async {
    await openDb();
    final List<Map<String, dynamic>> maps = await _database.rawQuery("SELECT * FROM $taskTableName");
    return List.generate(maps.length, (i) {
      return Task(
        taskId: maps[i][colTaskId],
        taskTitle: maps[i][colTaskTitle],
        taskDescription: maps[i][colTaskDesc],
      );
    });
  }

  Future<void> deleteTask(int id) async {
    await openDb();
    await _database.delete(
      taskTableName,
      where: "$colTaskId = ?",
      whereArgs: [id],
    );
    print(id.toString() + " deleted");
  }
}