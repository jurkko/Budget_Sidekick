import 'package:flutter/material.dart';
import 'package:budget_sidekick/Models/expense.dart';
import 'package:intl/intl.dart';

class CustomDialog extends StatefulWidget {
  final Expense e;
  const CustomDialog({Key key, this.e}) : super(key: key);
  @override
  _CustomDialogState createState() => _CustomDialogState();
}

class _CustomDialogState extends State<CustomDialog> {
  var formatter = new DateFormat('dd-MM-yyyy');
  @override
  void initState() {
    super.initState();
    if (widget.e != null) {
      edit = true;
    } else {
      edit = false;
    }
  }

  bool edit;
  int _profit = 1;
  Color _colorContainer = Colors.green[400];
  Color _colorTextButtom = Colors.green;

  TextEditingController _controllerAmount = TextEditingController();
  TextEditingController _controllerName = TextEditingController();
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

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
              Row(
                children: <Widget>[
                  Text(
                    "€ ",
                    style:
                        TextStyle(color: Colors.white, fontSize: width * 0.06),
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
                  Radio(
                    activeColor: Colors.green[900],
                    value: 1,
                    groupValue: _profit,
                    onChanged: (value) {
                      print(value);
                      setState(() {
                        _profit = value;
                        _colorContainer = Colors.green[400];
                        _colorTextButtom = Colors.green;
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
                  Radio(
                    activeColor: Colors.red[900],
                    value: 2,
                    groupValue: _profit,
                    onChanged: (value) {
                      print(value);
                      setState(() {
                        _profit = value;
                        _colorContainer = Colors.red[300];
                        _colorTextButtom = Colors.red[300];
                      });
                    },
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: width * 0.01),
                    child: Text("Inflow"),
                  )
                ],
              ),
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
                          Expense mov = Expense();
                          String amount;
                          if (_controllerAmount.text.contains(",")) {
                            amount = _controllerAmount.text
                                .replaceAll(RegExp(","), ".");
                          } else {
                            amount = _controllerAmount.text;
                          }
                          /*
                          //mov.data = formatter.format(DateTime.now());
                          mov.name = _controllerName.text;

                          if (_profit == 1) {
                            mov.amount = double.parse(amount);
                            mov.tipo = "r";
                            if (widget.mov != null) {
                              mov.id = widget.mov.id;
                            }
                            edit == false
                                ? _movHelper.saveMovimentacao(mov)
                                : _movHelper.updateMovimentacao(mov);
                          }
                          if (_profit == 2) {
                            mov.amount = double.parse("-" + amount);
                            mov.tipo = "d";
                            if (widget.mov != null) {
                              mov.id = widget.mov.id;
                            }
                            edit == false
                                ? _movHelper.saveMovimentacao(mov)
                                : _movHelper.updateMovimentacao(mov);
                          }*/
                          Navigator.pop(context);
                          //initState();
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
