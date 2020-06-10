import 'package:budget_sidekick/Models/account.dart';
import 'package:budget_sidekick/Models/user.dart';
import 'package:budget_sidekick/Screens/Core/features/Categories/categories.dart';
import 'package:budget_sidekick/Services/auth.dart';
import 'package:budget_sidekick/Services/database.dart';
import 'package:budget_sidekick/screens/core/features/Analysis/analysis.dart';
import 'package:budget_sidekick/screens/core/features/Events/events.dart';
import 'package:budget_sidekick/screens/core/features/Expenses/expenses.dart';
import 'package:budget_sidekick/screens/core/features/Reminder/reminder.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Menu extends StatefulWidget {
  @override
  _MenuState createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  final AuthService _auth = AuthService();

  int index = 0;
  List<Widget> viewList = [
    Expenses(),
    Events(),
    Reminder(),
    Analysis(),
    Categories()
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: <Widget>[
          FlatButton.icon(
            icon: Icon(
              Icons.person,
            ),
            label: Text(
              'Sign Out',
              style: TextStyle(color: Colors.white),
            ),
            textColor: Colors.white,
            onPressed: () async {
              await _auth.signOut();
            },
          )
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.white,
              Colors.white,
              Colors.white,
              Colors.white,
            ],
            stops: [0.1, 0.4, 0.7, 0.9],
          ),
        ),
        child: viewList[index],
      ),
      drawer: MyDrawer(
        onTap: (ctx, i) {
          setState(() {
            index = i;
            Navigator.pop(ctx);
          });
        },
      ),
    );
  }
}

class MyDrawer extends StatelessWidget {
  final Function onTap;

  MyDrawer({this.onTap});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    return StreamBuilder<Account>(
        stream: DatabaseService(uid: user.uid).account,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            Account account = snapshot.data;
            //print("Menu | account balance: " + account.balance.toString());
            return SizedBox(
                width: MediaQuery.of(context).size.width * 0.7,
                child: Drawer(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    DrawerHeader(
                      decoration: BoxDecoration(color: Colors.blue),
                      child: Padding(
                        padding: EdgeInsets.all(6),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Text(user.email,
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.white)),
                            SizedBox(
                              height: 15,
                            ),
                            Text("Balance: " + account.balance.toString() + "€",
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.white)),
                            SizedBox(
                              height: 15,
                            ),
                            Text(
                              'Upcoming Events: 5',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ),
                    ListTile(
                      leading: Icon(Icons.attach_money),
                      title: Text('Expenses'),
                      onTap: () => onTap(context, 0),
                    ),
                    ListTile(
                      leading: Icon(Icons.event),
                      title: Text('Events'),
                      onTap: () => onTap(context, 1),
                    ),
                    ListTile(
                      leading: Icon(Icons.alarm),
                      title: Text('Reminder'),
                      onTap: () => onTap(context, 2),
                    ),
                    ListTile(
                      leading: Icon(Icons.show_chart),
                      title: Text('Analysis'),
                      onTap: () => onTap(context, 3),
                    ),
                    ListTile(
                      leading: Icon(Icons.list),
                      title: Text('Categories'),
                      onTap: () => onTap(context, 4),
                    ),
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
