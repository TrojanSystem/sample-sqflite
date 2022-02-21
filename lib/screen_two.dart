import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'database/expense_database.dart';
import 'input_form/transaction_form_item.dart';
import 'model/transaction_model_data.dart';

class ScreenTwo extends StatefulWidget {
  const ScreenTwo({Key key}) : super(key: key);

  @override
  State<ScreenTwo> createState() => _ScreenTwoState();
}

class _ScreenTwoState extends State<ScreenTwo> {
  List v = [];

  extract() async {
    final db = await DatabaseHelper.getInstance();
    List<Map<String, dynamic>> x = await db.rawQueryNames();
    List nameofofItem = (x.map(
      (e) => e['name'],
    )).toList();
    v = (nameofofItem.toSet()).toList();

    return v;
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
              child: FutureBuilder(
                future: extract(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: Colors.red,
                      ),
                    );
                  }
                  final itemss = snapshot.data;
                  final output = Provider.of<TransactionModelData>(context);
                  return ListView.builder(
                    itemCount: itemss.length,
                    itemBuilder: (context, index) {
                      output.query(itemss[index], index);
                      return Column(
                        children: [
                          ListTile(
                            title: Text(
                              itemss[index].toString(),
                            ),
                            trailing: Text(output.sums.toStringAsFixed(2)),
                          ),
                          // ListTile(
                          //   title: Text(
                          //     itemss[0].toString(),
                          //   ),
                          //   trailing: Text(
                          //       Provider.of<TransactionModelData>(context).sum.toString()),
                          // ),
                        ],
                      );
                    },
                  );
                },
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
