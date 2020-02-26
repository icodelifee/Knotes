import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

Database db;

class DatabaseCreator {
  static const temp_table = "temp";
  static const knotes_table = "knotes";
  static const id = 'id';
  static const title = 'title';
  static const content = 'content';
  static const timestamp = 'timestamp';

  Future<void> createKnotesTable(Database db) async {
    final todoSql = '''CREATE TABLE IF NOT EXISTS $knotes_table (
      $id INTEGER PRIMARY KEY AUTOINCREMENT,
      $title TEXT,
      $content TEXT
    )''';

    final tempSql = '''CREATE TABLE IF NOT EXISTS $temp_table (
      $title TEXT,
      $content TEXT
    )''';

    Batch batch = db.batch();

    batch.execute(todoSql);
    batch.execute(tempSql);

    List<dynamic> res = await batch.commit();
  }

  Future<String> getDatabasePath(String name) async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, name);

    return path;
  }

  Future<void> initDatabase() async {
    final path = await getDatabasePath('knotes_db');
    db = await openDatabase(path, version: 1, onCreate: onCreate);
    print(db);
  }

  Future<void> onCreate(Database db, int version) async {
    await createKnotesTable(db);
  }
}
