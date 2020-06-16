import 'package:budget_sidekick/Screens/Core/features/Reminder/reminderCard.dart';
import 'package:budget_sidekick/Screens/Core/features/Reminder/addReminderCustomDialog.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
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


  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
  var initialisationSettingAndroid;
  var initialisationSettingIOS;
  var initialisationSettings;


  
  Future<bool> _weekly;
  Future<bool> _daily;
  bool weekly;
  bool daily;
  Reminder deletedReminder;
  List<Reminder> listOfReminders = [];

  @override
  void initState() {
    super.initState();
    _weekly = _prefs.then((SharedPreferences prefs) {
      return (prefs.getBool('weekly') ?? 0);
    });
    _daily = _prefs.then((SharedPreferences prefs) {
      return (prefs.getBool('daily') ?? 0);
    });  
    initialisationSettingAndroid = new AndroidInitializationSettings('app_icon'); 
    initialisationSettingIOS = new IOSInitializationSettings( onDidReceiveLocalNotification: onDidReceiveLocalNotification);
    initialisationSettings = new InitializationSettings((initialisationSettingAndroid), initialisationSettingIOS);
    flutterLocalNotificationsPlugin.initialize(initialisationSettings, onSelectNotification: onSelectNotification);
 
  }

  Future onSelectNotification(String payload) async {
  }

  Future doWeeklyNotification(bool enabled) async {
    if(weekly){
    var time = Time(12, 0, 0);
    var androidPlatformChannelSpecifics =
        AndroidNotificationDetails('show weekly channel id',
            'show weekly channel name', 'show weekly description');
    var iOSPlatformChannelSpecifics =
        IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.showWeeklyAtDayAndTime(
        0,
        'Budget Sidekick',
        'Your expenses and events are waiting for you!',
        Day.Sunday,
        time,
        platformChannelSpecifics);
        }
    else{
        await flutterLocalNotificationsPlugin.cancelAll(); 
        doDailyNotification(daily); 
        scheduleFewReminders(listOfReminders);

      }
  }

  Future doDailyNotification(bool enabled) async {
    if(enabled){
      var time = Time(17, 40, 0);
      var androidPlatformChannelSpecifics =
          AndroidNotificationDetails('repeatDailyAtTime channel id',
              'repeatDailyAtTime channel name', 'repeatDailyAtTime description');
      var iOSPlatformChannelSpecifics =
          IOSNotificationDetails();
      var platformChannelSpecifics = NotificationDetails(
          androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
      await flutterLocalNotificationsPlugin.showDailyAtTime(
          0,
          'Budget Sidekick',
          'Your Daily expense report is waiting',
          time,
          platformChannelSpecifics);
    }
    else{
        await flutterLocalNotificationsPlugin.cancelAll();  
        doWeeklyNotification(weekly);
        scheduleFewReminders(listOfReminders);
    }
  }  

  Future onDidReceiveLocalNotification(int id, String title, String body, String payload) async{}

  Future<bool> getPrefValue(String prefsKey) async {
      var prefs = await SharedPreferences.getInstance();
      if (prefs.getBool(prefsKey) == null){
          return true;
      }
      return prefs.getBool(prefsKey);
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
  void weeklyNotifications(bool enabled) async{
      var prefs = await SharedPreferences.getInstance();
      prefs.setBool('weekly', enabled);
      doWeeklyNotification(enabled);
  }
  void dailyNotifications(bool enabled) async{
      var prefs = await SharedPreferences.getInstance();
      prefs.setBool('daily', enabled);
      doDailyNotification(enabled);
  }  
  void scheduleFewReminders(List<Reminder> reminders) async {
    if(reminders.isNotEmpty){
      if(reminders.length <= 5){
        for (Reminder re in reminders){
          var scheduledNotificationDateTime = re.dateOfNotif;
          var androidPlatformChannelSpecifics =
              AndroidNotificationDetails('your other channel id',
                  'your other channel name', 'your other channel description');
          var iOSPlatformChannelSpecifics =
              IOSNotificationDetails();
          NotificationDetails platformChannelSpecifics = NotificationDetails(
              androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
          await flutterLocalNotificationsPlugin.schedule(
              0,
              re.name,
              re.message,
              scheduledNotificationDateTime,
              platformChannelSpecifics);          
        }
      }
    }
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
                            right: width * 0.17, // 30,
                            child: Container(
                              height: height * 0.2, //150,
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
                                      top: width * 0.0,
                                      bottom: width * 0.02,
                                    ),
                                  ), 
                                FutureBuilder<bool>(
                                    future: getPrefValue("weekly"),
                                    builder: (context, AsyncSnapshot<bool> snapshot) {
                                        if (snapshot.hasData){
                                          return SwitchListTile(
                                            value: snapshot.data,
                                            title: Text("Enable weekly notifications"),
                                            onChanged: (value) {
                                              setState(() {
                                                
                                              weekly = value;
                                              weeklyNotifications(value);
                                              });
                                            },
                                          );
                                        } else{
                                            return Container();
                                        }

                                    }
                                ), 
                                FutureBuilder<bool>(
                                    future: getPrefValue("daily"),
                                    builder: (context, AsyncSnapshot<bool> snapshot) {
                                        if (snapshot.hasData){
                                          return SwitchListTile(
                                            value: snapshot.data,
                                            title: Text("Enable daily notifications"),
                                            onChanged: (value) {
                                              setState(() {
                                              daily = value;
                                              dailyNotifications(value);
                                              });
                                            },
                                          );
                                        } else{
                                            return Container();
                                        }

                                    }
                                ),                                                                                                                                     
                                ],
                              ),
                          ),
                          ),
                          Positioned(
                            top: width * 0.40, //70
                            left: width * 0.84, //30,                            
                            child: GestureDetector(
                              onTap: () {
                                //Check if there are any categories
                                _dialogAddReminder();
                              },
                              child: Container(
                                width: width * 0.12,
                                height: width * 0.12, //65,
                                decoration: BoxDecoration(
                                    color: Colors.lightGreen[
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
                          ),                          ],
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
                                        scheduleFewReminders(listOfReminders);
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


