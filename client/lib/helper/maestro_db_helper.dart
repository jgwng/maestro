import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:client/model/documents.dart';

class MaestroDBHelper{
  static final MaestroDBHelper _db = MaestroDBHelper._internal();
  factory MaestroDBHelper() => _db;
  MaestroDBHelper._internal();

  static Database? _database;
  final String tableName = 'SavedDocuments';

  Future<Database> get database async => _database ??= await initDB();

  Future<Database> initDB() async {
    String path = join(await getDatabasesPath(), 'SavedDocument.db');
    return await openDatabase(
        path,
        version: 1,
        onCreate: (db, version) async {
          await db.execute('''
            CREATE TABLE $tableName(
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              collection TEXT,
              thumbnail_url TEXT,
              image_url TEXT, 
              width INTEGER,
              height INTEGER,
              display_sitename TEXT,
              doc_url TEXT,
              datetime TEXT,
              isFavorite INTEGER
            )
          ''');
        },
        onUpgrade: (db, oldVersion, newVersion){}
    );
  }

  Future<List<Document>> getDB() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db!.query(tableName);
    if( maps.isEmpty ) return [];
    List<Document> list = List.generate(maps.length, (index) {
      return Document.fromJson(maps[index]);
    });
    return list;
  }


  Future<void> insert(Document document) async {
    final db = await database;
    document.id = await db.insert(tableName, document.toJson());
  }

  Future<void> delete(Document document) async {
    final db = await database;
    await db.delete(
      tableName,
      where: "id = ?",
      whereArgs: [document.id],
    );
  }

}