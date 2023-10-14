import 'package:reminder_app_ios/models/reminder.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:developer' as dev;

class DatabaseHelper {
  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initDatabase();
    return _database!;
  }

  Future<Database> initDatabase() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, 'reminders1.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        return db.execute('''
          CREATE TABLE reminders(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT,
            desc TEXT,
            dateTime TEXT
          )
        ''');
      },
    );
  }

  Future<int> insertReminder(Reminder reminder) async {
    final db = await database;
    dev.log(reminder.toMap().toString());
    return await db.insert('reminders', reminder.toMap());
  }

  Future<int> deleteReminder(int id) async {
    final db = await database;
    return await db.delete(
      'reminders',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteReminderByTime(String dateTime) async {
    final db = await database;
    return await db.delete(
      'reminders',
      where: 'dateTime = ?',
      whereArgs: [dateTime],
    );
  }

  Future<List<Reminder>> getReminders() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('reminders');
    return List.generate(maps.length, (i) {
      return Reminder.fromMap(maps[i]);
    });
  }

  Future<int> getReminderID(DateTime datetime) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'reminders',
      where: 'dateTime = ?',
      whereArgs: [datetime.toIso8601String()],
    );
    return maps[0]['id'];
  }
}
