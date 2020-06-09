import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:budget_sidekick/Models/category.dart';
import 'package:budget_sidekick/Models/user.dart';
import 'package:budget_sidekick/Services/database.dart';
import 'package:flutter_iconpicker/flutter_iconpicker.dart';
import 'iconPicker.dart';

class Categories extends StatefulWidget {
  @override
  CategoriesState createState() => CategoriesState();
}

class CategoriesState extends State<Categories> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<Category> listOfCategories;
  TextEditingController _controllerName = TextEditingController();
  String name;
  IconData icon;
  int iconCode;
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return StreamBuilder<List<Category>>(
        stream: DatabaseService().categories,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            print(snapshot.data);
            listOfCategories = snapshot.data;
            return Scaffold(
              backgroundColor: Colors.white,
              key: _scaffoldKey,
              body: SingleChildScrollView(
                physics: NeverScrollableScrollPhysics(),
                child: Column(
                  children: <Widget>[
                    Stack(
                      children: <Widget>[
                        Container(
                          width: double.infinity,
                          height: height * 0.25, //300,
                          color: Colors.blue,
                        ),
                        Positioned(
                          top: width * 0.11, //70
                          left: width * 0.2, //30,
                          child: Text(
                            "Categories",
                            style: TextStyle(
                                color: Colors.white, fontSize: width * 0.06 //30
                                ),
                          ),
                        ),
                        Column(
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(
                                  left: width * 0.2,
                                  right: width * 0.1,
                                  top: width * 0.25),
                              child: TextField(
                                  textCapitalization:
                                      TextCapitalization.sentences,
                                  cursorColor: Colors.white,
                                  controller: _controllerName,
                                  maxLength: 20,
                                  style: TextStyle(fontSize: width * 0.05),
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
                            ),
                          ],
                        ),
                        Positioned(
                          top: width * 0.25, //70
                          left: 0, //30,
                          child: GestureDetector(
                            onTap: () {
                              _showIconPickerDialog();
                            },
                            child: Container(
                              width: width * 0.16,
                              height: width * 0.14, //65,
                              decoration: BoxDecoration(
                                color: Colors.blue, //Colors.indigo[400],
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Icon(
                                  IconData(iconCode ?? 58740,
                                      fontFamily: 'MaterialIcons'),
                                  size: width * 0.08,
                                  color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              floatingActionButton: FloatingActionButton(
                onPressed: () {
                  if (_controllerName.text.isNotEmpty && iconCode != null) {
                    print("Adding Category");
                    DatabaseService(uid: user.uid)
                        .addCategory(_controllerName.text, iconCode);
                    setState(() {
                      iconCode = null;
                    });
                    _controllerName.clear();
                  }
                },
                child: Icon(Icons.add),
                backgroundColor: Colors.blue,
                tooltip: "Add Category",
              ),
            );
          } else {
            return SizedBox(
              child: Text("Jebat ga, neki nalaga ane"),
            );
          }
        });
  }

  Future<void> _showIconPickerDialog() async {
    final width = MediaQuery.of(context).size.width;
    IconData iconPicked = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.blue,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(width * 0.050)),
          title: Center(
            child: Text(
              'Category Icon',
              style: TextStyle(color: Colors.white),
            ),
          ),
          content: IconPicker(),
        );
      },
    );

    if (iconPicked != null) {
      debugPrint('Icon changed to $iconPicked');
      setState(() {
        print(iconCode);
        icon = iconPicked;
        iconCode = iconPicked.codePoint;
      });
    }
  }
}
