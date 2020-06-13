import 'package:budget_sidekick/Models/account.dart';
import 'package:budget_sidekick/Models/category.dart';
import 'package:budget_sidekick/Services/database.dart';
import 'package:flutter/material.dart';
import 'package:budget_sidekick/Models/expense.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:budget_sidekick/Models/user.dart';

class CustomDialog extends StatefulWidget {
  final Expense e;
  const CustomDialog({Key key, this.e}) : super(key: key);
  @override
  _CustomDialogState createState() => _CustomDialogState();
}

class _CustomDialogState extends State<CustomDialog> {
  var formatter = new DateFormat('dd-MM-yyyy');
  //Fields
  String name;
  String amount;
  String category = 'Other';
  bool profit = true;
  int _profit = 1;
  int preAmount;
  bool preProfit;

  Color _colorContainer = Colors.green[400];
  Color _colorTextButtom = Colors.green;

  List<Category> listOfCategories = [];

  @override
  void initState() {
    super.initState();
    if (widget.e != null) {
      edit = true;
      _controllerName.text = widget.e.name;
      _controllerAmount.text = widget.e.amount.toString();
      profit = widget.e.profit;
      preProfit = profit;
      preAmount = widget.e.amount;
      if (profit) {
        _profit = 1;
      } else {
        _profit = 2;
        _colorContainer = Colors.red[300];
        _colorTextButtom = Colors.red[300];
      }
      category = widget.e.category;
    } else {
      edit = false;
    }
  }

  bool edit;

  TextEditingController _controllerAmount = TextEditingController();
  TextEditingController _controllerName = TextEditingController();
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    final user = Provider.of<User>(context);
    return AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(width * 0.050)),
        title: Text(
          "New Expense",
          textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: _colorContainer,
        content: StreamBuilder<Account>(
            stream: DatabaseService(uid: user.uid).account,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return StreamBuilder<List<Category>>(
                    stream: DatabaseService(uid: user.uid).categories,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        listOfCategories = snapshot.data;
                      } else {
                           return SizedBox(child: Text("Nimaš kategorij kolega"));
                      }
                    });
              } else {
                return SizedBox(child: Text("Neki jebejo expensi kolega"));
              }
            }));
  }
}
