import 'package:budget_sidekick/Services/auth.dart';
import 'package:budget_sidekick/screens/core/features/Analysis/analysis.dart';
import 'package:budget_sidekick/screens/core/features/Coupons/coupons.dart';
import 'package:budget_sidekick/screens/core/features/Events/events.dart';
import 'package:budget_sidekick/screens/core/features/Expenses/expenses.dart';
import 'package:budget_sidekick/screens/core/features/Reminder/reminder.dart';
import 'package:flutter/material.dart';

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
    Coupons()
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
                Icons.exit_to_app,
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
                Color(0xFF73AEF5),
                Color(0xFF61A4F1),
                Color(0xFF478DE0),
                Color(0xFF398AE5),
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
        ));
  }
}

class MyDrawer extends StatelessWidget {
  final Function onTap;

  MyDrawer({this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: MediaQuery.of(context).size.width * 0.8,
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
                    Text('Sound Fractures',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w400,
                            color: Colors.white)),
                    SizedBox(
                      height: 15,
                    ),
                    Text('Current Balance: 500€',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: Colors.white)),
                    SizedBox(
                      height: 15,
                    ),
                    Text(
                      'Neki se maybe',
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
              leading: Icon(Icons.home),
              title: Text('Expenses'),
              onTap: () => onTap(context, 0),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Events'),
              onTap: () => onTap(context, 1),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Reminder'),
              onTap: () => onTap(context, 2),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Analysis'),
              onTap: () => onTap(context, 3),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Coupons'),
              onTap: () => onTap(context, 4),
            ),
          ],
        )));
  }
}
