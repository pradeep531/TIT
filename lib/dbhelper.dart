import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'Network/call/reminder_model.dart';

class DBHelper {
  static final DBHelper _instance = DBHelper._internal();
  factory DBHelper() => _instance;

  DBHelper._internal();

  static Database? _database;

  Future<Database?> get database async {
    if (_database != null) return _database;
    _database = await _initDB();
    return _database;
  }

  Future<Database> _initDB() async {
    final path = join(await getDatabasesPath(), 'reminder.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE reminders(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT,
            dateTime TEXT
          )
        ''');
      },
    );
  }

  Future<int> insertReminder(Reminder reminder) async {
    final db = await database;
    return await db!.insert('reminders', reminder.toMap());
  }

  Future<List<Reminder>> getReminders() async {
    final db = await database;
    final result = await db!.query('reminders');
    return result.map((e) => Reminder.fromMap(e)).toList();
  }

  Future<void> deleteReminder(int id) async {
    final db = await database;
    await db!.delete('reminders', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> clearAllReminders() async {
    final db = await database;
    await db!.delete('reminders'); // Deletes all rows in the reminders table
  }
}
