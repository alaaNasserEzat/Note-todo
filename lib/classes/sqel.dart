import 'package:noteapp/classes/note.dart';
import 'package:noteapp/classes/todo.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class sqelhelper {
  Database? database;
  Future getDatabase() async {
    if (database != null) return database;
    database = await initDatabase();
    return database;
  }

  Future initDatabase() async {
    String path = join(await getDatabasesPath(), "mydatabase.db");
    return await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      Batch batch = db.batch();
      batch.execute('''
CREATE TABLE note(
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  title TEXT,
  content TEXT
)
''');
      batch.execute('''
CREATE TABLE todo(
  id INTEGER PRIMARY KEY,
  title TEXT,
 value INTEGER
)
''');
      batch.commit();
    });
  }

  Future insertnote(Note note) async {
    Database db = await getDatabase();
    Batch batch = db.batch();
    batch.insert("note", note.tomap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
    batch.commit();
  }

  Future inserttodo(ToDo todo) async {
    Database db = await getDatabase();
    Batch batch = db.batch();
    batch.insert("todo", todo.tomap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
    batch.commit();
  }

  Future<List<Map>> loadnote() async {
    Database db = await getDatabase();
    List<Map> mp = await db.query("note");
    return List.generate(mp.length, (index) {
      return Note(
              content: mp[index]['content'],
              id: mp[index]['id'],
              title: mp[index]['title'])
          .tomap();
    });
  }

  Future<List<Map>> loadtodo() async {
    Database db = await getDatabase();
    List<Map> mp = await db.query("todo");
    return List.generate(mp.length, (index) {
      return ToDo(
              value: mp[index]['value'],
              id: mp[index]['id'],
              title: mp[index]['title'])
          .tomap();
    });
  }

  Future updatenote(Note note) async {
    Database db = await getDatabase();
    await db.update('note', note.tomap(), where: "id=?", whereArgs: [note.id]);
  }

 Future updatcheck(int id, int curvalue) async {
    Database db = await getDatabase();
    Map<String, dynamic> values = {"value": curvalue == 0 ? 1 : 0};
    await db.update('todo', values, where: "id=?", whereArgs: [id]);
  }

 Future deletallnote() async {
    Database db = await getDatabase();
    await db.delete("note");
  }

 Future deletalltodo() async {
    Database db = await getDatabase();
    await db.delete("todo");
  }

 Future deletnote(int id) async {
    Database db = await getDatabase();
    await db.delete("note", where: "id=?", whereArgs: [id]);
  }
}
