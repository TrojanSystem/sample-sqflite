import 'package:example/database/names_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'database/expense_database.dart';
import 'input_form/transaction_form_item.dart';
import 'model/name_model.dart';
import 'model/transaction_model.dart';
import 'model/transaction_model_data.dart';

class ScreenOne extends StatefulWidget {
  const ScreenOne({Key key}) : super(key: key);

  @override
  State<ScreenOne> createState() => _ScreenOneState();
}

class _ScreenOneState extends State<ScreenOne> {
  double sum = 0;
  String nameofItem = '';

  query() async {
    // get a reference to the database
    final db = await DatabaseHelper.getInstance();
    List<Map<String, dynamic>> x = await db.rawQueryNames();
    List nameofofItem = (x.map(
      (e) => e['name'],
    )).toList();
    List v = (nameofofItem.toSet()).toList();
    // raw query
    for (int c = 0; c < v.length; c++) {
      List<Map<String, dynamic>> result = await db.rawQuery(
        TransactionModel(
          date: DateTime.now().toString(),
          description: 'Food',
          price: '120',
          name: v[c],
        ),
      );

      List name = (result.map(
        (e) => e['price'],
      )).toList();
      List nameItem = (result.map(
        (e) => e['name'],
      )).toList();

      nameofItem = nameItem[0].toString();
      for (int x = 0; x < result.length; x++) {
        sum += double.parse(name[x]);
      }

      nameItem.toSet();
      print(v);
      print('all db ${nameofofItem.toSet()}');
      print('${nameItem.toSet()}');
      print("The total sum is $sum");
      Provider.of<TransactionModelData>(context, listen: false).total = sum;
    }
    return sum;
  }

  @override
  void initState() {
    query();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final sum = Provider.of<TransactionModelData>(context, listen: false).total;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sqflite Example'),
      ),
      body: SizedBox(
        height: double.infinity,
        width: double.infinity,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              flex: 1,
              child: Container(
                child: Center(
                  child: Text(
                    'The name is $nameofItem and Sum is $sum',
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 40,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                color: Colors.red,
              ),
            ),
            Expanded(
              flex: 1,
              child: StreamBuilder(
                stream: DatabaseHelper.getInstance().getAllItems(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: Colors.red,
                      ),
                    );
                  }
                  final items = snapshot.data;
                  return ListView.builder(
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(
                          items[index].name,
                        ),
                        trailing: Text(items[index].price),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            builder: (_) => const TransactionForm(),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
