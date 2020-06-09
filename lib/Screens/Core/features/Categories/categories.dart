import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:budget_sidekick/Models/account.dart';
import 'package:budget_sidekick/Models/user.dart';
import 'package:budget_sidekick/Services/database.dart';

class Category extends StatefulWidget {
  @override
  CategoryState createState() => CategoryState();
}

class CategoryState extends State<Category> {
  var _balance;
  String stringBalance;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    return StreamBuilder<Account>(
        stream: DatabaseService(uid: user.uid).account,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            _balance = snapshot.data.balance;
            return Container(
                child: Center(
                    child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(25.0),
                  child: SizedBox(
                    height: 100,
                    child:
                        Text(stringBalance ?? snapshot.data.balance.toString()),
                  ),
                ),
                RaisedButton(
                    child: Text(
                      'Add 50',
                      style: TextStyle(
                        color: Colors.white,
                        letterSpacing: 1.5,
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'OpenSans',
                      ),
                    ),
                    padding: EdgeInsets.all(25.0),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        side: BorderSide(color: Colors.white)),
                    onPressed: () async {
                      print("Adding 50");
                      await DatabaseService(uid: user.uid)
                          .handleBalance(50, true);
                    }),
                RaisedButton(
                    child: Text(
                      'Reduce 50',
                      style: TextStyle(
                        color: Colors.white,
                        letterSpacing: 1.5,
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'OpenSans',
                      ),
                    ),
                    padding: EdgeInsets.all(25.0),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        side: BorderSide(color: Colors.white)),
                    onPressed: () async {
                      print("Reducing 50");
                      await DatabaseService(uid: user.uid)
                          .handleBalance(50, false);
                    })
              ],
            )));
          } else {
            return SizedBox(
              child: Text("Jebat ga, nalaga alpa ne"),
            );
          }
        });
  }
}
