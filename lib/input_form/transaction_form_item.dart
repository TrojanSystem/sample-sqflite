import 'package:example/database/expense_database.dart';
import 'package:example/database/names_database.dart';
import 'package:example/model/transaction_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../model/name_model.dart';

class TransactionForm extends StatefulWidget {
  const TransactionForm({Key key}) : super(key: key);

  @override
  State<TransactionForm> createState() => _TransactionFormState();
}

class _TransactionFormState extends State<TransactionForm> {
  final _formKey = GlobalKey<FormState>();
  String description = '';
  String name = '';
  String price = '';
  DateTime date = DateTime.now();

  void showDate() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(DateTime.now().month - 1),
      lastDate: DateTime(DateTime.now().year + 1),
    ).then((val) {
      setState(() {
        date = val;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Scaffold(
        body: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Enter Valid Name';
                  } else {
                    return null;
                  }
                },
                decoration: InputDecoration(
                  label: const Text('Name'),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                onSaved: (value) {
                  name = value;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Enter Valid Description';
                  } else {
                    return null;
                  }
                },
                decoration: InputDecoration(
                  label: const Text('Description'),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                onSaved: (value) {
                  description = value;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                validator: (value) {
                  final pattern = RegExp("^[0-9]{1,10}");
                  if (value.isEmpty) {
                    return 'Enter the price';
                  } else if (!pattern.hasMatch(value)) {
                    return 'Enter Valid valid price';
                  } else {
                    return null;
                  }
                },
                decoration: InputDecoration(
                  label: const Text('Item Price'),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                onSaved: (value) {
                  price = value;
                },
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  onPressed: showDate,
                  icon: const Icon(
                    Icons.calendar_today_rounded,
                    color: Colors.blue,
                  ),
                ),
                Text(
                  DateFormat.yMMMEd().format(date),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: RaisedButton(
                onPressed: () async {
                  if (_formKey.currentState.validate()) {
                    _formKey.currentState.save();

                    await DatabaseHelper.getInstance().insert(
                      TransactionModel(
                        name: name,
                        description: description,
                        price: price,
                        date: date.toString(),
                      ),
                    );
                    await DatabaseHelperName.getInstances().insertName(
                      NameModel(
                        name: name,
                      ),
                    );
                    Navigator.of(context).pop();
                  }
                },
                child: const Text('Save Input'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
