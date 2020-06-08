import 'package:budget_sidekick/Models/expense.dart';
import 'package:budget_sidekick/Models/account.dart';
import 'package:budget_sidekick/Screens/Core/features/Expenses/expenseCard.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:budget_sidekick/Models/user.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:budget_sidekick/Services/database.dart';

class Expenses extends StatefulWidget {
  static const String id = 'expenses';
  @override
  ExpensesState createState() => ExpensesState();
}

class ExpensesState extends State<Expenses> {
  Expense expense = Expense("Banana", 150, "Food", true);
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return StreamBuilder<Account>(
        stream: DatabaseService(uid: user.uid).account,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            Account account = snapshot.data;

            return Container(
              child: SingleChildScrollView(
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
                                    left: width * 0.05,
                                    top: width * 0.04,
                                    bottom: width * 0.02,
                                  ),
                                  child: Text(
                                    "Balance",
                                    style: TextStyle(
                                        color: Colors.grey[600],
                                        fontSize: width * 0.05),
                                  ),
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Padding(
                                      padding:
                                          EdgeInsets.only(left: width * 0.05),
                                      child: Container(
                                        width: width * 0.6,
                                        child: Text(
                                          account.balance.toString() + "€",
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              color: Colors.lightBlue[
                                                  700], //Colors.indigo[400],
                                              fontWeight: FontWeight.bold,
                                              fontSize: width * 0.1
                                              //width * 0.1 //_saldoTamanho(saldoAtual)
                                              ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding:
                                          EdgeInsets.only(right: width * 0.04),
                                      child: GestureDetector(
                                        onTap: () {
                                          //Add expense
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
                                SizedBox(
                                  height: height * 0.008,
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                        padding: EdgeInsets.only(
                            left: width * 0.04,
                            right: width * 0.04,
                            top: height * 0.01),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              "Traffic",
                              style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: width * 0.04),
                            ),
                            Padding(
                              padding: EdgeInsets.only(right: width * 0.02),
                            )
                          ],
                        )),
                    Padding(
                        padding: EdgeInsets.only(
                            left: width * 0.04, right: width * 0.04, top: 0),
                        child: SizedBox(
                            width: width,
                            height: height * 0.63,
                            child: ExpenseCard(
                              expense: expense,
                            ))),
                  ],
                ),
              ),
            );
          } else {
            return SizedBox(
              child: Text("Jebat ga, nalaga alpa ne"),
            );
          }
        });
  }
}
