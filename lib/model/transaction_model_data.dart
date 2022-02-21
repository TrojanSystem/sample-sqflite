import 'package:example/database/expense_database.dart';
import 'package:example/database/month_budget_database.dart';
import 'package:example/model/transaction_model.dart';
import 'package:flutter/material.dart';

class TransactionModelData extends ChangeNotifier {
  double sums = 0;
  String nameofItem = '';
  List<dynamic> datas = [];
  double dailyTotal = 0;
  double total = 0;
  double monthMoney = 0;
  int progress = 0;
  bool monthPressed = false;

  query(String names, int indexss) async {
    double sum = 0;
    // get a reference to the database
    final db = DatabaseHelper.getInstance();
    // List<Map<String, dynamic>> x = await db.rawQueryNames();
    // List nameofofItem = (x.map(
    //       (e) => e['name'],
    // )).toList();
    //  List v = (nameofofItem.toSet()).toList();
    // raw query

    List<Map<String, dynamic>> result = await db.rawQuery(
      TransactionModel(
        date: DateTime.now().toString(),
        description: 'Food',
        price: '120',
        name: names,
      ),
    );

    List name = (result.map(
      (e) => e['price'],
    )).toList();
    List nameItem = (result.map(
      (e) => e['name'],
    )).toList();

    print('list of price $name');
    // print('Length of result ${result.length}');
    for (int x = 0; x < result.length; x++) {

        print('names: $names NameofItem: ${nameItem[x]}');

        print('X: $x price: ${name[x]}');
        sum = sum + double.parse(name[x]);
        print('sum is $sum');



    }

    sums = sum;


  }

  final List<TransactionModel> _expense = [];

  List<TransactionModel> get expense => _expense;

  void updateExpense(int index, TransactionModel transModel) {
    expense[index] = transModel;
    notifyListeners();
  }

  final monthlyData = DatabaseHelpers.getInstances().getAllItems();

  double DailyTotal(double price) {
    total += price;
    return total;
  }

  double updateDailySum(double price, double updatePrice) {
    total -= price;
    total += updatePrice;
    return total;
  }

  void removeExpense(
    int index,
  ) {
    expense.removeAt(index);
    notifyListeners();
  }

  double deleteExpense(double price) {
    total -= price;
    return total;
  }

  double monthlyBudget(double price) {
    monthMoney += price;
    return monthMoney;
  }

  int monthlyProgress(double tot) {
    double sum = (tot / monthMoney) * 100;
    progress = sum.ceil();
    return progress;
  }

  int monthlyUpdatedProgress(double tot) {
    double sum = (tot / monthMoney) * 100;
    progress = sum.ceil();
    return progress;
  }

  int monthlyDeletedProgress(double price) {
    total -= (total - price);
    double sum = (total / monthMoney) * 100;
    progress = sum.ceil();
    return progress;
  }
}
