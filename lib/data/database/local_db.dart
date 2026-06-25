import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class LocalDb {
  static Database? _db;

  static Future<Database> get database async {
    if (_db != null) {
      return _db!;
    }
    _db = await _initDB('ocean_sys.db');
    return _db!;
  }

  static Future<Database> _initDB(String filePaath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePaath);
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        print('[LocalDb] Creating table pending_requests');
        await db.execute('''
                        CREATE TABLE pending_requests(
                          id INTEGER PRIMARY KEY AUTOINCREMENT,
                          url TEXT,
                          payload TEXT
                        )''');
      },
    );
  }

  static Future<int> insertRequest(String url, String payload) async {
    print('[LocalDb] insertRequest: url=$url, payload=$payload');
    final db = await database;
    return await db.insert("pending_requests", {
      "url": url,
      "payload": payload,
    });
  }

  static Future<List<Map<String, dynamic>>> getPendingRequests() async {
    final db = await database;
    return await db.query("pending_requests");
  }

  static Future<int> deletePendingRequest(int id) async {
    print('[LocalDb] deletePendingRequest: id=$id');
    final db = await database;
    return await db.delete(
      "pending_requests",
      where: "id = ?",
      whereArgs: [id],
    );
  }
}
