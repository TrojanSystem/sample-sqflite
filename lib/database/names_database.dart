import 'dart:io';
import 'package:example/model/transaction_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:sqlbrite/sqlbrite.dart';

import '../model/name_model.dart';

const _tableItems = 'namelList';

Future<Database> _open() async {
  final directory = await getApplicationDocumentsDirectory();
  final path = join(directory.path, 'namelList.db');
  return await openDatabase(
    path,
    version: 1,
    onCreate: (Database db, int version) async {
      await db.execute(
        '''
          CREATE TABLE $_tableItems( 
              id INTEGER PRIMARY KEY AUTOINCREMENT, 
              name TEXT NOT NULL
              
          )
        ''',
      );
    },
  );
}

class DatabaseHelperName {
  static DatabaseHelperName _singleton;

  DatabaseHelperName._();

  factory DatabaseHelperName.getInstances() =>
      _singleton ??= DatabaseHelperName._();

  final _dbFuture = _open().then((db) => BriteDatabase(db));

  Future<int> insertName(NameModel shop) async {
    final db = await _dbFuture;
    var result = db.insert(
      _tableItems,
      shop.toMap(),
    conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return result;
  }

  Future<List<Map<String, dynamic>>> rawQuery(NameModel item) async {
    final db = await _dbFuture;
    final rows = await db.query(
      _tableItems,
      where: 'name = ?',
      whereArgs: [item.name],
    );
    return rows;
  }


  Stream<List<NameModel>> getAllItems() async* {
    final db = await _dbFuture;
    yield* db
        .createQuery(_tableItems)
        .mapToList((map) => NameModel.fromMap(map));
  }

  Future<bool> update(NameModel item) async {
    final db = await _dbFuture;
    final rows = await db.update(
      _tableItems,
      item.toMap(),
      where: 'id = ?',
      whereArgs: [item.id],
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return rows > 0;
  }

  Future<NameModel> getData(NameModel username) async {
    final db = await _dbFuture;
    List<Map> result = await db
        .query(_tableItems, where: "name = ?", whereArgs: [username.name]);

    if (result.length == 1) {
      return username;
    }

    return null;
  }

  Future delete(int id) async {
    final db = await _dbFuture;

    return db?.delete(
      _tableItems,
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
