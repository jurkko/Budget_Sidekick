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
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                  controller: _controllerName,
                  maxLength: 20,
                  style: TextStyle(fontSize: width * 0.05),
                  keyboardType: TextInputType.text,
                  maxLines: 1,
                  textAlign: TextAlign.start,
                  decoration: new InputDecoration(
                    //hintText: "descrição",
                    labelText: "Name",
                    labelStyle: TextStyle(color: Colors.white54),
                    //hintStyle: TextStyle(color: Colors.grey[400]),
                    contentPadding: EdgeInsets.only(
                        left: width * 0.04,
                        top: width * 0.041,
                        bottom: width * 0.041,
                        right: width * 0.04),

                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(width * 0.04),
                      borderSide: BorderSide(
                        color: Colors.white,
                        width: 2.0,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(width * 0.04),
                      borderSide: BorderSide(
                        color: Colors.white,
                        width: 2.0,
                      ),
                    ),
                  )),
              Row(
                children: <Widget>[
                  Radio(
                    activeColor: Colors.green[900],
                    value: 1,
                    groupValue: _profit,
                    onChanged: (value) {
                      setState(() {
                        profit = true;
                        _profit = value;
                        _colorContainer = Colors.green[400];
                        _colorTextButtom = Colors.green;
                      });
                    },
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: width * 0.01),
                    child: Text("Inflow"),
                  ),
                  Radio(
                    activeColor: Colors.red[900],
                    value: 2,
                    groupValue: _profit,
                    onChanged: (value) {
                      setState(() {
                        profit = false;
                        _profit = value;
                        _colorContainer = Colors.red[300];
                        _colorTextButtom = Colors.red[300];
                      });
                    },
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: width * 0.01),
                    child: Text("Outflow"),
                  )
                ],
              ),
              Row(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "€ ",
                      style: TextStyle(
                          color: Colors.white, fontSize: width * 0.07),
                    ),
                  ),
                  Flexible(
                    child: TextField(
                        controller: _controllerAmount,
                        maxLength: 7,
                        style: TextStyle(fontSize: width * 0.05),
                        keyboardType:
                            TextInputType.numberWithOptions(decimal: true),
                        maxLines: 1,
                        textAlign: TextAlign.end,
                        decoration: new InputDecoration(
                          hintText: "0.00",
                          hintStyle: TextStyle(color: Colors.white54),
                          contentPadding: EdgeInsets.only(
                              left: width * 0.04,
                              top: width * 0.041,
                              bottom: width * 0.041,
                              right: width * 0.04), //15),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(width * 0.04),
                            borderSide: BorderSide(
                              color: Colors.white,
                              width: 2.0,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(width * 0.04),
                            borderSide: BorderSide(
                              color: Colors.white,
                              width: 2.0,
                            ),
                          ),
                        )),
                  )
                ],
              ),
              Row(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: Text(
                      "Category",
                      style: TextStyle(
                          color: Colors.white, fontSize: width * 0.05),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 13,
                    ),
                    child: new Theme(
                      data: Theme.of(context)
                          .copyWith(canvasColor: _colorContainer),
                      child: DropdownButton<String>(
                        value: category,
                        onChanged: (String newValue) {
                          setState(() {
                            category = newValue;
                          });
                        },
                        style: TextStyle(color: Colors.white),
                        underline: Container(
                          height: 1,
                          color: Colors.white,
                        ),
                        icon: Icon(
                          Icons.arrow_drop_down,
                          color: Colors.white,
                        ),
                        items: <String>[
                          'Food',
                          'Clothing',
                          'Repairs',
                          'Maintenance',
                          'Other',
                        ].map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ),
                  )
                ],
              ),
              Padding(
                padding: EdgeInsets.only(top: width * 0.09),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        "Back",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        if (_controllerAmount.text.isNotEmpty &&
                            _controllerName.text.isNotEmpty) {
                          Expense expense = Expense();

                          if (_controllerAmount.text.contains(",")) {
                            amount = _controllerAmount.text
                                .replaceAll(RegExp(","), ".");
                          } else {
                            amount = _controllerAmount.text;
                          }
                          name = _controllerName.text;
                          //date = neki

                          expense.amount = int.parse(amount);
                          expense.name = name;
                          expense.category = category;
                          expense.profit = profit;
                          expense.user_id = user.uid;
                          expense.date = DateTime.now();
                          print("ADDING EXPENSE");
                          if (edit) {
                            expense.id = widget.e.id;
                            print(expense.id.toString());
                            DatabaseService(uid: user.uid)
                                .updateExpense(expense, preProfit, preAmount);
                          } else {
                            DatabaseService(uid: user.uid).addExpense(expense);
                          }

                          Navigator.pop(context);
                        }
                      },
                      child: Container(
                        padding: EdgeInsets.only(
                            top: width * 0.02,
                            bottom: width * 0.02,
                            left: width * 0.03,
                            right: width * 0.03),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Colors.white,
                        ),
                        child: Center(
                          child: Text(
                            edit == false ? "Confirm" : "Update",
                            style: TextStyle(
                                color: _colorTextButtom,
                                fontWeight: FontWeight.bold,
                                fontSize: width * 0.05),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ));
  }
}
