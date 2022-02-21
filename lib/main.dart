import 'package:example/screen_one.dart';
import 'package:example/screen_two.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'model/transaction_model_data.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (ctx)=>TransactionModelData(),
      child: const MaterialApp(
        home: ScreenTwo(),
      ),
    );
  }
}
