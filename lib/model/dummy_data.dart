// import 'package:example/model/transaction_model.dart';
// import 'package:example/model/transaction_model_data.dart';
// import 'package:flutter/cupertino.dart';
//
// class DummyData extends ChangeNotifier {
//   double cateMonthMoney = 0;
//   int cateProgress = 0;
//
//   final List<TransactionModel> _model = [];
//
//   List<TransactionModel> get model => _model;
//
//   void addExpense(TransactionModel model) {
//     _model.insert(0, model);
//     notifyListeners();
//   }
//
//   List<TransactionModel> modelItems = [];
//
//   //List<TransactionModel> get modelItem => _modelItem;
//
//   final List<String> _listOfId = [];
//
//   List<String> get listOfId => _listOfId;
//
//   void addId(String id) {
//     if (!_listOfId.contains(id)) {
//       _listOfId.insert(0, id);
//     } else {
//       return;
//     }
//   }
//
//   List<TransactionModel> findById() {
//     for (int x = 0; x < listOfId.length; x++) {
//       modelItems =
//           model.where((element) => element.name == listOfId[x]).toList();
//       notifyListeners();
//     }
//     return modelItems;
//   }
//
//   List sumUp = [];
//
//   double totPrice() {
//     sumUp = findById();
//     double sums = 0;
//     sumUp.forEach((element) {
//       sums += element.price;
//     });
//     return sums;
//   }
//
//   double findByIdTest() {
//     double sumss = 0;
//     for (int x = 0; x < listOfId.length; x++) {
//       modelItems =
//           model.where((element) => element.name == listOfId[x]).toList();
//       modelItems.forEach((element) {
//         sumss += element.price;
//       });
//       return sumss;
//     }
//
//     notifyListeners();
//   }
//
//   List<double> listOfprice = [];
//
//   void addTotPrice(double price) {
//     listOfprice.insert(0, price);
//     notifyListeners();
//   }
//
//
//
//   double monthlyBudget(double price) {
//     cateMonthMoney += price;
//     return cateMonthMoney;
//   }
//
//   int categoryTotPrice() {
//     double cateSum = (findByIdTest() / cateMonthMoney) * 100;
//     cateProgress = cateSum.ceil();
//     return cateProgress;
//   }
// }
