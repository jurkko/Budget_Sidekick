import 'package:budget_sidekick/Services/database.dart';
import 'package:flutter/material.dart';
import 'package:budget_sidekick/Models/expense.dart';
import 'package:budget_sidekick/Models/category.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:budget_sidekick/Models/user.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

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
  String initialCat;
  bool profit = true;
  int _profit = 1;
  int preAmount;
  bool preProfit;
  int iconCode;
  List<Category> listOfCategories;
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
      initialCat = widget.e.category;
      iconCode = widget.e.iconCode;
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
    double height = MediaQuery.of(context).size.width;
    final user = Provider.of<User>(context);
    return StreamBuilder<List<Category>>(
        stream: DatabaseService(uid: user.uid).categories,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data.length != 0) {
              listOfCategories = snapshot.data;
              initialCat = initialCat ?? listOfCategories[0].id;
              iconCode = iconCode ?? listOfCategories[0].iconCode;
              return SingleChildScrollView(
                child: AlertDialog(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(width * 0.050)),
                    title: Text(
                      edit ? "Update Expense" : "New Expense",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    backgroundColor: _colorContainer,
                    content: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          TextField(
                              textCapitalization: TextCapitalization.sentences,
                              cursorColor: Colors.white,
                              controller: _controllerName,
                              maxLength: 20,
                              style: TextStyle(
                                  fontSize: width * 0.05, color: Colors.white),
                              keyboardType: TextInputType.text,
                              maxLines: 1,
                              textAlign: TextAlign.start,
                              decoration: new InputDecoration(
                                labelText: "Name",
                                labelStyle: TextStyle(color: Colors.white),
                                contentPadding: EdgeInsets.only(
                                    left: width * 0.04,
                                    top: width * 0.041,
                                    bottom: width * 0.041,
                                    right: width * 0.04),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.circular(width * 0.04),
                                  borderSide: BorderSide(
                                    color: Colors.white,
                                    width: 2.0,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.circular(width * 0.04),
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
                                      color: Colors.white,
                                      fontSize: width * 0.07),
                                ),
                              ),
                              Flexible(
                                child: TextField(
                                    controller: _controllerAmount,
                                    maxLength: 7,
                                    style: TextStyle(fontSize: width * 0.05),
                                    keyboardType:
                                        TextInputType.numberWithOptions(
                                            decimal: true),
                                    maxLines: 1,
                                    textAlign: TextAlign.end,
                                    decoration: new InputDecoration(
                                      hintText: "0.00",
                                      hintStyle:
                                          TextStyle(color: Colors.white54),
                                      contentPadding: EdgeInsets.only(
                                          left: width * 0.04,
                                          top: width * 0.041,
                                          bottom: width * 0.041,
                                          right: width * 0.04), //15),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(width * 0.04),
                                        borderSide: BorderSide(
                                          color: Colors.white,
                                          width: 2.0,
                                        ),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(width * 0.04),
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
                                      color: Colors.white,
                                      fontSize: width * 0.04),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                  left: 3,
                                ),
                                child: new Theme(
                                  data: Theme.of(context)
                                      .copyWith(canvasColor: _colorContainer),
                                  child: DropdownButton<String>(
                                    value: initialCat,
                                    onChanged: (String newValue) {
                                      setState(() {
                                        initialCat = newValue;
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
                                    items: listOfCategories
                                        .map<DropdownMenuItem<String>>(
                                            (Category cat) {
                                      return DropdownMenuItem<String>(
                                        onTap: () {
                                          iconCode = cat.iconCode;
                                        },
                                        value: cat.id,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Text(cat.name),
                                            Icon(
                                                IconData(cat.iconCode,
                                                    fontFamily:
                                                        'MaterialIcons'),
                                                color: Colors.white),
                                          ],
                                        ),
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

                                      if (_controllerAmount.text
                                          .contains(",")) {
                                        amount = _controllerAmount.text
                                            .replaceAll(RegExp(","), ".");
                                      } else {
                                        amount = _controllerAmount.text;
                                      }
                                      name = _controllerName.text;

                                      expense.amount = int.parse(amount);
                                      expense.name = name;
                                      expense.category = initialCat;
                                      expense.profit = profit;
                                      expense.user_id = user.uid;
                                      expense.date = DateTime.now();
                                      expense.iconCode = iconCode;
                                      print("ADDING EXPENSE");
                                      if (edit) {
                                        expense.id = widget.e.id;
                                        print(expense.id.toString());
                                        DatabaseService(uid: user.uid)
                                            .updateExpense(
                                                expense, preProfit, preAmount);
                                      } else {
                                        DatabaseService(uid: user.uid)
                                            .addExpense(expense);
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
                    )),
              );
            } else {
              //No Categories
              return Container(
                child: AlertDialog(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(width * 0.050)),
                  title: Text(
                    "No Categories",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.grey[700]),
                  ),
                  backgroundColor: Colors.white,
                  content: Text(
                    "Whoops, looks like you have no categories set.",
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                  actions: <Widget>[
                    FlatButton(
                      child: Text(
                        "Ok",
                        style: TextStyle(color: Colors.blue),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
              );
            }
          } else {
            //Snapshot doesn't exist
            return Container(
                width: double.infinity,
                height: height * 0.4665, //300,
                color: Colors.transparent,
                child: SpinKitRing(
                  color: Colors.blue,
                  size: 100.0,
                ));
          }
        });
  }
}
