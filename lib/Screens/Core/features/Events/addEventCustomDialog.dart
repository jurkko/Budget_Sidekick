import 'package:flutter/material.dart';
import 'package:budget_sidekick/Models/event.dart';
import 'package:budget_sidekick/Models/user.dart';
import 'package:provider/provider.dart';
import 'package:budget_sidekick/Services/database.dart';
import 'package:intl/intl.dart';

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
  Color _colorContainer = Colors.blue[400];
  Color _colorTextButtom = Colors.blue;

  DateTime selectedDate = DateTime.now();
  TextEditingController _date = new TextEditingController();
  TextEditingController _controllerName = new TextEditingController();
  TextEditingController _controllerTarget = new TextEditingController();
  TextEditingController _controllerCurrent = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    final user = Provider.of<User>(context);
    return AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(width * 0.05)),
        title: Text(
          "New Event",
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
