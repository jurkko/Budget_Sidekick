import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:budget_sidekick/Models/category.dart';
import 'package:budget_sidekick/Models/user.dart';
import 'package:budget_sidekick/Services/database.dart';

class Categories extends StatefulWidget {
  @override
  CategoriesState createState() => CategoriesState();
}

class CategoriesState extends State<Categories> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<Category> listOfCategories;
  TextEditingController _controllerName = TextEditingController();
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
                          height: height * 0.3, //300,
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
                      ],
                    ),
                    Stack(
                      children: <Widget>[
                        Container(
                          width: double.infinity,
                          height: height * 0.8, //300,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          } else {
            return SizedBox(
              child: Text("Jebat ga, neki nalaga ane"),
            );
          }
        });
  }
}
