import 'package:budget_sidekick/Models/category.dart';
import 'package:flutter/material.dart';
import 'package:budget_sidekick/Models/event.dart';
import 'package:budget_sidekick/Models/user.dart';
import 'package:provider/provider.dart';
import 'package:budget_sidekick/Services/database.dart';
import 'package:intl/intl.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class AddEventCustomDialog extends StatefulWidget {
  final Event e;
  const AddEventCustomDialog({Key key, this.e}) : super(key: key);
  @override
  _addEventCustomDialogState createState() => _addEventCustomDialogState();
}

class _addEventCustomDialogState extends State<AddEventCustomDialog> {
  // todo actually use dates
  // this shit doesnt actually work yet, keep in mind
  var formatter = new DateFormat('dd-MM-yyyy');
  int _profit = 1;
  bool profit = true;
  bool preProfit;
  List<Category> listOfCategories;
  String initialCat;
  int iconCode;
  @override
  void initState() {
    super.initState();
    if (widget.e != null) {
      edit = true;
      _controllerName.text = widget.e.name;
      _controllerTarget.text = widget.e.target.toString();
      _controllerCurrent.text = widget.e.current.toString();
      _date.text = widget.e.dueDate.toString();
      profit = widget.e.profit;
      preProfit = profit;
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
  Color _colorContainer = Colors.green[400];
  Color _colorTextButtom = Colors.green;

  DateTime selectedDate = DateTime.now();
  TextEditingController _date = new TextEditingController();
  TextEditingController _controllerName = new TextEditingController();
  TextEditingController _controllerTarget = new TextEditingController();
  TextEditingController _controllerCurrent = new TextEditingController();
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
              return AlertDialog(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(width * 0.05)),
                  title: Text(
                    edit ? "Update Event" : "New Event",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  backgroundColor: _colorContainer,
                  content: SingleChildScrollView(
                    physics: NeverScrollableScrollPhysics(),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Flexible(
                              child: TextField(
                                  controller: _controllerName,
                                  //maxLength: 7,
                                  style: TextStyle(fontSize: width * 0.05),
                                  keyboardType:
                                      TextInputType.text,
                                  maxLines: 1,
                                  textAlign: TextAlign.start,
                                  decoration: new InputDecoration(
                                    hintText: "Name",
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
                            Flexible(
                              child: GestureDetector(
                              onTap: () => _selectDate(context),
                              child: AbsorbPointer(
                                child: TextFormField(
                                  controller: _date,
                                  keyboardType: TextInputType.datetime,
                                  decoration: InputDecoration(
                                    hintText: "Date of event",
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
                                    ),
                                ),
                              ),
                            ),
                          ),
                          ],
                        ),                                                                          
                        Row(
                          children: <Widget>[
                            Flexible(
                              child: TextField(
                                  enabled: !profit,
                                  controller: _controllerCurrent,
                                  style: TextStyle(fontSize: width * 0.05),
                                  keyboardType:
                                      TextInputType.number,
                                  maxLines: 1,
                                  textAlign: TextAlign.start,
                                  decoration: new InputDecoration(
                                    hintText: "Current progress",
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
                            Flexible(
                              child: TextField(
                                  controller: _controllerTarget,
                                  style: TextStyle(fontSize: width * 0.05),
                                  keyboardType:
                                      TextInputType.number,
                                  maxLines: 1,
                                  textAlign: TextAlign.start,
                                  decoration: new InputDecoration(
                                    hintText: "Target",
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
                                                  fontFamily: 'MaterialIcons'),
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
                                  if (_date.text.isNotEmpty &&
                                      _controllerName.text.isNotEmpty && _controllerTarget.text.isNotEmpty) {
                                    Event ev = Event();
                                    ev.name = _controllerName.text;
                                    if (_controllerCurrent.text.isEmpty) {
                                      ev.current = 0;
                                    } else {
                                      ev.current = double.parse(_controllerCurrent.text);
                                    }
                                    ev.target = double.parse(_controllerTarget.text);
                                    ev.dueDate = selectedDate;
                                    ev.uid = user.uid;
                                    ev.profit = profit;
                                    ev.iconCode = iconCode;
                                    ev.category = initialCat;
                                    print("Insert in db");
                                    if (edit) {
                                    //if edditing
                                    } else {
                                      DatabaseService(uid: user.uid)
                                          .addEvent(ev);
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
            } else {
              //No Categories
              return Container(
                child: AlertDialog(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(width * 0.050)),
                  title: Text(
                    "O marija pomagi",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.grey[700]),
                  ),
                  backgroundColor: Colors.white,
                  content: Text(
                    "Pa se JEZUSA bom poklicu! Koji kurac delas tu brez kategorij?",
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                  actions: <Widget>[
                    FlatButton(
                      child: Text(
                        "Kurba sm glup",
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
  Future<Null> _selectDate(BuildContext context) async {
      final DateTime picked = await showDatePicker(
          context: context,
          initialDate: selectedDate,
          firstDate: DateTime(1901, 1),
          lastDate: DateTime(2100));
      if (picked != null && picked != selectedDate)
        setState(() {
          selectedDate = picked;
          _date.value = TextEditingValue(text: formatter.format(picked));
        });
    }
}