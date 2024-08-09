import 'package:sqflite/sqflite.dart';

import '../models/task.dart';

class DBHelper {
  static Database? _db;
  static const int _version = 1;
  static const String _tableName = 'tasks';

  static Future<void> initDb() async {
    if (_db != null) {
      return;
    } else {
      try {
        String _path = await getDatabasesPath() + 'task.db';
        _db = await openDatabase(
          _path,
          version: _version,
          onCreate: ((db, version) async {
            await db.execute('CREATE TABLE $_tableName ('
                'id INTEGER PRIMARY KEY AUTOINCREMENT, '
                'title String, '
                'note TEXT, '
                'date String, '
                'startTime String, '
                'endTime String, '
                'repeat String, '
                'isComplete INTEGER, '
                'remind INTEGER, '
                'color INTEGER)');
          }),
        );
      } catch (e) {
        print(e);
      }
    }
  }

  static Future<int> insert(Task task) async {
    return await _db!.insert(_tableName, task.toJson());
  }

  static Future<int> delete(int id) async {
    return await _db!.delete(
      _tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  static Future<int> update(int id) async {
    return await _db!.rawUpdate(
      'UPDATE tasks SET isComplete = ? WHERE id = ?',
      [1, id],
    );
  }

  static Future<List<Map<String, dynamic>>> query() async {
    return await _db!.query(_tableName);
  }
}
