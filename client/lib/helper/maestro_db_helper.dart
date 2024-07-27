import 'package:client/model/book.dart';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class MaestroDBHelper{
  static final MaestroDBHelper _db = MaestroDBHelper._internal();
  factory MaestroDBHelper() => _db;
  MaestroDBHelper._internal();

  static Database? _database;
  final String tableName = 'SavedDocuments';

  Future<Database?> get database async => _database ??= await initDB();

  Future<Database?> initDB() async {
    if(kIsWeb) return null;

    String path = join(await getDatabasesPath(), 'SavedDocument.db');
    return await openDatabase(
        path,
        version: 1,
        onCreate: (db, version) async {
          await db.execute('''
            CREATE TABLE $tableName(
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              authors TEXT,
              contents TEXT,
              datetime TEXT,
              isbn TEXT,
              price INTEGER, 
              publisher TEXT,
              salesPrice INTEGER,
              status TEXT,
              thumbnail TEXT,
              title TEXT,
              translators TEXT,
              url TEXT,
              isFavorite INTEGER
            )
          ''');
        },
        onUpgrade: (db, oldVersion, newVersion){}
    );
  }

  Future<List<Book>> getDB() async {
    if(kIsWeb) return [];
    final db = await database;
    final List<Map<String, dynamic>> maps = await db!.query(tableName);
    if( maps.isEmpty ) return [];
    List<Book> list = List.generate(maps.length, (index) {
      return Book.fromJson(maps[index],isFromDB: true);
    });
    return list;
  }


  Future<void> insert(Book document) async {
    if(kIsWeb) return;

    final db = await database;
    document.id = await db!.insert(tableName, document.toJson());
  }

  Future<void> delete(Book document) async {
    if(kIsWeb) return;

    final db = await database;
    await db!.delete(
      tableName,
      where: "id = ?",
      whereArgs: [document.id],
    );
  }

}