import 'package:budget_sidekick/Screens/Core/features/Events/addEventCustomDialog.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:budget_sidekick/Screens/Core/features/Events/eventCard.dart';
import 'package:budget_sidekick/Screens/Core/loading.dart';
import 'package:flutter/material.dart';
import 'package:budget_sidekick/Models/event.dart';
import 'package:budget_sidekick/Models/account.dart';
import 'package:budget_sidekick/Models/user.dart';
import 'package:provider/provider.dart';
import 'package:budget_sidekick/Services/database.dart';

class Events extends StatefulWidget {
  static const String id = "events";
  @override
  EventsState createState() => EventsState();
}

class EventsState extends State<Events> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  
  Event deletedEvent;
  List<Event> listOfEvents = [];
  String list_length;
  _dialogAddEvent() {
    showDialog(
        context: context,
        builder: (context) {
          return AddEventCustomDialog();
        });
  }
  _dialogEditEvent(Event ev) {
    showDialog(
        context: context,
        builder: (context) {
          return AddEventCustomDialog(e: ev);
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
             print('=== data ===: ${snapshot.data}');
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
                                height: height * 0.14, //250,
                                decoration: BoxDecoration(
                                  color: Colors.blue, //Colors.indigo[400],
                                )),
                          ),
                          Positioned(
                            top: width * 0.11, //70
                            left: width * 0.2, //30,
                            child: Text(
                              "Events",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: width * 0.06 //30
                                  ),
                            ),
                          ),
                          Positioned(
                            top: width * 0.17, //70
                            left: width * 0.83, //30,                            
                            child: GestureDetector(
                              onTap: () {
                                //Check if there are any categories
                                _dialogAddEvent();
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
                                child: StreamBuilder<List<Event>>(
                                    stream:
                                        DatabaseService(uid: user.uid).event,
                                    builder: (context, snapshot) {
                                      if (snapshot.hasData) {
                                        listOfEvents = snapshot.data;
                                        print('=== data ===: ${snapshot.data}');

                                        listOfEvents.sort(
                                            (a, b) => b.dueDate.compareTo(a.dueDate));
                                        return ListView.builder(
                                            itemCount: listOfEvents.length,
                                            itemBuilder: (context, index) {
                                              Event e = listOfEvents[index];
                                              return InkWell(
                                                onLongPress: () {
                                                  _dialogEditEvent(e);
                                                },
                                                child: Dismissible(
                                                  direction: DismissDirection
                                                      .endToStart,
                                                  onDismissed: (direction) {
                                                    deletedEvent =
                                                        listOfEvents[index];
                                                    setState(() {
                                                      listOfEvents
                                                          .removeAt(index);
                                                    });
                                                    print(e.uid);
                                                    DatabaseService(
                                                            uid: user.uid)
                                                        .removeEvent(e);
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
                                                          "Event deleted",
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
                                                            listOfEvents.insert(
                                                                index,
                                                                deletedEvent);
                                                          });
                                                          DatabaseService(
                                                                  uid: user.uid)
                                                              .addEvent(
                                                                  deletedEvent);
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
                                                  child: EventCard(
                                                    event: e,
                                                  ),
                                                ),
                                              );
                                            });
                                        GestureDetector(
                                          onTap: () {
                                            //Check if there are any categories
                                            _dialogAddEvent();
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
                                        );                                         
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

