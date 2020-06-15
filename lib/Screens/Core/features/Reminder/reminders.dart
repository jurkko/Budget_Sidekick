import 'package:budget_sidekick/Screens/Core/features/Reminder/reminderCard.dart';
import 'package:budget_sidekick/Screens/Core/features/Reminder/addReminderCustomDialog.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:budget_sidekick/Screens/Core/loading.dart';
import 'package:flutter/material.dart';
import 'package:budget_sidekick/Models/reminder.dart';
import 'package:budget_sidekick/Models/account.dart';
import 'package:budget_sidekick/Models/user.dart';
import 'package:provider/provider.dart';
import 'package:budget_sidekick/Services/database.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Reminders extends StatefulWidget {
  static const String id = "reminders";
  @override
  RemindersState createState() => RemindersState();
}

class RemindersState extends State<Reminders> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  Future<bool> _weekly;
  Future<bool> _daily;
  Reminder deletedReminder;
  List<Reminder> listOfReminders = [];

  @override
  void initState() {
    super.initState();
    _weekly= _prefs.then((SharedPreferences prefs) {
      return (prefs.getBool('weekly') ?? 0);
    });
    _daily= _prefs.then((SharedPreferences prefs) {
      return (prefs.getBool('daily') ?? 0);
    });
  }  

  Future<void> _incrementCounter() async {
    final SharedPreferences prefs = await _prefs;
    final bool weekly = (prefs.getBool('weekly') ?? 0);
    final bool daily = (prefs.getBool('daily') ?? 0);

    setState(() {
      _weekly = prefs.setBool("weekly", weekly).then((bool success) {
        return weekly;
      });
      _daily = prefs.setBool("daily", daily).then((bool success) {
        return daily;
      });      
    });
  }

  _dialogAddReminder() {
    showDialog(
        context: context,
        builder: (context) {
          return AddReminderCustomDialog();
        });
  }
  _dialogEditReminder(Reminder reminder) {
    showDialog(
        context: context,
        builder: (context) {
          return AddReminderCustomDialog(re: reminder);
        });
  }  

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
    backgroundColor: Colors.white,
    key: _scaffoldKey,
    body: StreamBuilder<Account>(
        stream: DatabaseService(uid: user.uid).account,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
              return Container(
                child: SingleChildScrollView(
                  physics: NeverScrollableScrollPhysics(),
                  child: Column(
                    children: <Widget>[
                      Stack(
                        children: <Widget>[
                          Container(
                            width: double.infinity,
                            height: height * 0.334, //300,
                            color: Colors.white,
                          ),
                          Positioned(
                            top: 0,
                            left: 0,
                            right: 0,
                            child: Container(
                                width: double.infinity,
                                height: height * 0.28, //250,
                                decoration: BoxDecoration(
                                  color: Colors.blue, //Colors.indigo[400],
                                )),
                          ),
                          Positioned(
                            top: width * 0.11, //70
                            left: width * 0.2, //30,
                            child: Text(
                              "Reminders",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: width * 0.06 //30
                                  ),
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            left: width * 0.07, // 30,
                            right: width * 0.07, // 30,
                            child: Container(
                              height: height * 0.16, //150,
                              width: width * 0.1, // 70,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.grey[400],
                                        blurRadius: 5,
                                        offset: Offset(0, 2))
                                  ]),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Padding(
                                    padding: EdgeInsets.only(
                                      left: width * 0.06,
                                      top: width * 0.04,
                                      bottom: width * 0.02,
                                    ),
                                    child: Text(
                                      "Number of reminders",
                                      style: TextStyle(
                                          color: Colors.grey[600],
                                          fontSize: width * 0.05),
                                    ),
                                  ),
                                Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Padding(
                                        padding: EdgeInsets.only(
                                          left: width * 0.06,
                                          top: width * 0.04,
                                          bottom: width * 0.02,
                                        ),
                                        child: Text(
                                          listOfReminders.length.toString(),
                                          style: TextStyle(
                                              color: Colors.grey[600],
                                              fontSize: width * 0.05),
                                        ),
                                      ),                                  
                                Padding(
                                  padding: EdgeInsets.only(
                                      right: width * 0.04),
                                  child: GestureDetector(
                                    onTap: () {
                                      //Check if there are any categories
                                      _dialogAddReminder();
                                    },
                                    child: Container(
                                      width: width * 0.12,
                                      height: width * 0.12, //65,
                                      decoration: BoxDecoration(
                                          color: Colors.lightBlue[
                                              700], //Colors.indigo[400],
                                          borderRadius:
                                              BorderRadius.circular(50),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.grey,
                                              blurRadius: 7,
                                              offset: Offset(2, 2),
                                            )
                                          ]),
                                      child: Icon(
                                        Icons.add,
                                        size: width * 0.07,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                )                                  
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                          padding: EdgeInsets.only(
                            bottom: 0,
                            left: width * 0.00,
                            right: width * 0.00,
                          ),
                          child: SizedBox(
                              width: width,
                              height: height * 0.666,
                              child: MediaQuery.removePadding(
                                removeTop: true,
                                context: context,
                                child: StreamBuilder<List<Reminder>>(
                                    stream:
                                        DatabaseService(uid: user.uid).reminder,
                                    builder: (context, snapshot) {
                                      if (snapshot.hasData) {
                                        listOfReminders = snapshot.data;
                                        listOfReminders.sort(
                                            (a, b) => b.dateOfNotif.compareTo(a.dateOfNotif));
                                        return ListView.builder(
                                            itemCount: listOfReminders.length,
                                            itemBuilder: (context, index) {
                                              Reminder e = listOfReminders[index];
                                              return InkWell(
                                                onLongPress: () {
                                                  _dialogEditReminder(e);
                                                },
                                                child: Dismissible(
                                                  direction: DismissDirection
                                                      .endToStart,
                                                  onDismissed: (direction) {
                                                    deletedReminder =
                                                        listOfReminders[index];
                                                    setState(() {
                                                      listOfReminders
                                                          .removeAt(index);
                                                    });
                                                    DatabaseService(
                                                            uid: user.uid)
                                                        .removeReminder(e);
                                                    final snackBar = SnackBar(
                                                      content: Container(
                                                        padding:
                                                            EdgeInsets.only(
                                                                bottom: width *
                                                                    0.025),
                                                        alignment: Alignment
                                                            .bottomLeft,
                                                        height: height * 0.05,
                                                        child: Text(
                                                          "Reminder deleted",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              //fontWeight: FontWeight.bold,
                                                              fontSize:
                                                                  width * 0.05),
                                                        ),
                                                      ),
                                                      duration:
                                                          Duration(seconds: 2),
                                                      backgroundColor:
                                                          Colors.blue,
                                                      action: SnackBarAction(
                                                        label: "Undo",
                                                        textColor: Colors.white,
                                                        onPressed: () {
                                                          setState(() {
                                                            listOfReminders.insert(
                                                                index,
                                                                deletedReminder);
                                                          });
                                                          DatabaseService(
                                                                  uid: user.uid)
                                                              .addReminder(
                                                                  deletedReminder);
                                                        },
                                                      ),
                                                    );
                                                    _scaffoldKey.currentState
                                                        .showSnackBar(snackBar);
                                                  },
                                                  key: ValueKey(e.id),
                                                  background: Container(
                                                    padding: EdgeInsets.only(
                                                        right: 10,
                                                        top: width * 0.045),
                                                    alignment:
                                                        Alignment.topRight,
                                                    color: Colors.red,
                                                    child: Icon(
                                                      Icons.delete_outline,
                                                      color: Colors.white,
                                                      size: width * 0.07,
                                                    ),
                                                  ),
                                                   child: ReminderCard(
                                                     reminder: e,
                                                   ),
                                                ),
                                              );
                                            });
                                      } else {
                                        return Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Container(
                                              width: double.infinity,
                                              //300,
                                              color: Colors.white,
                                              child: SpinKitRing(
                                                color: Colors.blue,
                                                size: 100.0,
                                                   )),
                                        );
                                      }
                                    }),
                              ))),
                    ],
                  ),
                ),
              );
          } else {
            return Loading();
          }
        }),
    );
  }
}


