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
        appBar: AppBar(
          title: Text("Navigation"),
        ),
        body: viewList[index],
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
