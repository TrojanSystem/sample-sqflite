import 'package:example/model/transaction_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:sqlbrite/sqlbrite.dart';

const _tableItems = 'transactionModelList';

Future<Database> _open() async {
  final directory = await getApplicationDocumentsDirectory();
  final path = join(directory.path, 'transactionModelList.db');
  return await openDatabase(
    path,
    version: 1,
    onCreate: (Database db, int version) async {
      await db.execute(
        '''
          CREATE TABLE $_tableItems( 
              id INTEGER PRIMARY KEY AUTOINCREMENT, 
              name TEXT NOT NULL,
              description TEXT NOT NULL,
              price TEXT NOT NULL,
              date TEXT NOT NULL
          )
        ''',
      );
    },
  );
}

class DatabaseHelper {
  static DatabaseHelper _singleton;

  DatabaseHelper._();

  factory DatabaseHelper.getInstance() => _singleton ??= DatabaseHelper._();

  final _dbFuture = _open().then((db) => BriteDatabase(db));

  Future<int> insert(TransactionModel shop) async {
    final db = await _dbFuture;
    return db.insert(_tableItems, shop.toMap());
  }

  Future<List<Map<String, dynamic>>> rawQueryNames() async {
    final db = await _dbFuture;
    List<Map> result = await db.rawQuery('SELECT * FROM $_tableItems');

    // print the results
    return result;
  }

  Future<List<Map<String, dynamic>>> rawQuery(TransactionModel item) async {
    final db = await _dbFuture;
    final rows = await db.query(
      _tableItems,
      where: 'name = ?',
      whereArgs: [item.name],
    );
    return rows;
  }

  Stream<List<TransactionModel>> getAllItems() async* {
    final db = await _dbFuture;
    yield* db
        .createQuery(_tableItems)
        .mapToList((map) => TransactionModel.fromMap(map));
  }

  Future<bool> update(TransactionModel item) async {
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

  Future<int> insertName(TransactionModel item) async {
    final db = await _dbFuture;
    return db.insert(
      _tableItems,
      item.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Future<List<Map<String, Object>>> listofdata(TransactionModel item) async {
  //   final db = await _dbFuture;
  //   final rows = await db.query(
  //     _tableItems,
  //     where: 'name = ?',
  //     whereArgs: [item.name],
  //   );
  //   return rows;
  // }

  Future<TransactionModel> getData(TransactionModel username) async {
    final db = await _dbFuture;
    List<Map> result = await db
        .query(_tableItems, where: "name =?", whereArgs: [username.name]);

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
