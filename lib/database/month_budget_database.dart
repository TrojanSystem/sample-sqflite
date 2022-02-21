import 'dart:io';
import 'package:example/model/month_budget_model.dart';
import 'package:example/model/transaction_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:sqlbrite/sqlbrite.dart';


const _tableItems = 'monthBudgetList';

Future<Database> _open() async {
  final directory = await getApplicationDocumentsDirectory();
  final path = join(directory.path, 'monthBudgetList.db');
  return await openDatabase(
    path,
    version: 1,
    onCreate: (Database db, int version) async {
      await db.execute(
        '''
          CREATE TABLE $_tableItems( 
              id INTEGER PRIMARY KEY AUTOINCREMENT, 
              price TEXT NOT NULL
             
          )
        ''',
      );


    },
  );
}
class DatabaseHelpers {

  static DatabaseHelpers _singleton;

  DatabaseHelpers._();

  factory DatabaseHelpers.getInstances() => _singleton ??= DatabaseHelpers._();

  final _dbFuture = _open().then((db) => BriteDatabase(db));





  Future<int> insert(MonthBudget shop) async {
    final db = await _dbFuture;
    return db.insert(_tableItems, shop.toMap());
  }

  Stream<List<MonthBudget>> getAllItems() async* {
    final db = await _dbFuture;
    yield* db
        .createQuery(_tableItems)
        .mapToList((map) => MonthBudget.fromMap(map));
  }

  Future<bool> update(MonthBudget item) async {
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

  Future delete(int id) async {
    final db = await _dbFuture;

    return db?.delete(
      _tableItems,
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
