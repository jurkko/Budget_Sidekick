import 'package:budget_sidekick/Models/event.dart';
import 'package:budget_sidekick/Models/expense.dart';
import 'package:budget_sidekick/Models/account.dart';
import 'package:budget_sidekick/Screens/Core/features/Expenses/expenseCard.dart';
import 'package:budget_sidekick/Screens/Core/loading.dart';
import 'package:dartz/dartz_unsafe.dart';
import 'package:flutter/material.dart';
import 'package:budget_sidekick/Models/user.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:budget_sidekick/Services/database.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:fluttertoast/fluttertoast.dart';

List<Event> listOfEvents = [];

class Mail extends StatefulWidget {
  static const String id = 'Mail';
  @override
  MailState createState() => MailState();
}

class MailState extends State<Mail> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  Expense deletedExpense;
  List<Expense> listOfExpenses = [];
  String initialEvent;
  String initialeEventName;
  String mailRecipient;
  final recipientController = TextEditingController();
  //Future<Iterable<Contact>> contacts = getContacts();

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.blue,
      key: _scaffoldKey,
      body: StreamBuilder<Account>(
          stream: DatabaseService(uid: user.uid).account,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              Account account = snapshot.data;
              return Container(
                child: SingleChildScrollView(
                  physics: NeverScrollableScrollPhysics(),
                  child: Column(
                    children: <Widget>[
                      Stack(
                        children: <Widget>[
                          Container(
                            width: double.infinity,
                            height: height * 0.45, //300
                            color: Colors.blue,
                          ),
                          /*       Positioned(
                            top: 0,
                            left: 0,
                            right: 0,
                            child: Container(
                                width: double.infinity,
                                height: height * 0.29, //250,
                                decoration: BoxDecoration(
                                  color: Colors.blue, //Colors.indigo[400],
                                )),
                          ), */
                          Positioned(
                            top: width * 0.11, //70
                            left: width * 0.2, //30,
                            child: Text(
                              "Send event ",
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
                              height: height * 0.32, //150,
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Padding(
                                        padding: EdgeInsets.only(
                                          left: width * 0.06,
                                          bottom: width * 0.02,
                                        ),
                                        child: Text(
                                          "Choose event:",
                                          style: TextStyle(
                                              color: Colors.grey[600],
                                              fontSize: width * 0.05),
                                        ),
                                      ),
                                      Expanded(
                                        child: StreamBuilder<List<Event>>(
                                            stream:
                                                DatabaseService(uid: user.uid)
                                                    .event,
                                            builder: (context, snapshot) {
                                              if (snapshot.hasData) {
                                                listOfEvents = snapshot.data;

                                                listOfEvents.sort((a, b) => b
                                                    .dueDate
                                                    .compareTo(a.dueDate));
                                                initialEvent = initialEvent ??
                                                    listOfEvents[0].id;
                                                print(listOfEvents);
                                                return Column(
                                                  children: [
                                                    DropdownButton<String>(
                                                      value: initialEvent,
                                                      onChanged:
                                                          (String newValue) {
                                                        setState(() {
                                                          initialEvent =
                                                              newValue;
                                                        });
                                                      },
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 15),
                                                      underline: Container(),
                                                      icon: Icon(
                                                        Icons.arrow_drop_down,
                                                        color: Colors.black,
                                                      ),
                                                      items: listOfEvents.map<
                                                              DropdownMenuItem<
                                                                  String>>(
                                                          (Event event) {
                                                        return DropdownMenuItem<
                                                            String>(
                                                          value: event.id,
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: <Widget>[
                                                              Text(event.name),
                                                            ],
                                                          ),
                                                        );
                                                      }).toList(),
                                                    ),
                                                  ],
                                                );
                                              } else {
                                                return Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
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
                                      ),
                                    ],
                                  ),
                                  Center(
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                        bottom: width * 0.02,
                                      ),
                                      child: Text(
                                        "Recipient mail address:",
                                        style: TextStyle(
                                            color: Colors.grey[600],
                                            fontSize: width * 0.05),
                                      ),
                                    ),
                                  ),
                                  Center(
                                    child: TextField(
                                        controller: recipientController,
                                        style:
                                            TextStyle(fontSize: width * 0.05),
                                        keyboardType:
                                            TextInputType.emailAddress,
                                        maxLines: 1,
                                        textAlign: TextAlign.center,
                                        decoration: new InputDecoration(
                                          hintText: "example@gmail.com",
                                          hintStyle:
                                              TextStyle(color: Colors.grey),
                                          contentPadding: EdgeInsets.only(
                                              left: width * 0.04,
                                              top: width * 0.041,
                                              bottom: width * 0.041,
                                              right: width * 0.04), //15),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(
                                                width * 0.04),
                                            borderSide: BorderSide(
                                              color: Colors.white,
                                              width: 2.0,
                                            ),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(
                                                width * 0.04),
                                            borderSide: BorderSide(
                                              color: Colors.white,
                                              width: 2.0,
                                            ),
                                          ),
                                        )),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        left: width * 0.64,
                                        bottom: width * 0.03),
                                    child: GestureDetector(
                                      onTap: () {
                                        mailRecipient =
                                            recipientController.text;
                                        sendMail(mailRecipient, initialEvent);
                                      },
                                      child: Container(
                                        width: width * 0.15,
                                        height: width * 0.15, //65,
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
                                          Icons.send,
                                          size: width * 0.09,
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

  Future<void> sendMail(mailRecipient, initialEvent) async {
    String username = 'BudgetSidekick@gmail.com';
    String password = 'BudgetSidekick123';

    final smtpServer = gmail(username, password);

    final message = Message()
      ..from = Address(username)
      ..recipients.add(mailRecipient)
      ..subject = 'I am notifing you about incoming event '
      ..text = 'Name of event\ni' + initialEvent + '';

    try {
      final sendReport = await send(message, smtpServer);
      print('Message sent: ' + sendReport.toString());
      Fluttertoast.showToast(
        msg: "E-mail was sent succesfully",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.white,
        textColor: Colors.blue,
        fontSize: 20.0,
        
    );
    } on MailerException catch (e) {
      print('Message not sent. \n' + e.toString());
      Fluttertoast.showToast(
        msg: "Tehre was a problem with sending an email",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 20.0
    );
    }
  }
}
