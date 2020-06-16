import 'package:budget_sidekick/Models/account.dart';
import 'package:flutter/material.dart';
import 'package:budget_sidekick/Models/expense.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:budget_sidekick/Models/user.dart';
import 'package:budget_sidekick/Services/database.dart';

import 'Dialogs/monthlyInflow.dart';
import 'Dialogs/yearlyOutflow.dart';

class Analysis extends StatefulWidget {
  @override
  _AnalysisState createState() => _AnalysisState();
}

class _AnalysisState extends State<Analysis> {
  
  List<charts.Series> seriesList;
  
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;



    _dialogMonthlyAnalysis() {
      showDialog(
          context: context,
          builder: (context) {
            return MonthlyAnalysisDialog();
          });
    }

       _dialogYearlyAnalysis() {
      showDialog(
          context: context,
          builder: (context) {
            return YearlyAnalysisDialog();
          });
    }

    List<Expense> listOfExpenses = [];
    return Scaffold(
      backgroundColor: Colors.white,
      body: StreamBuilder<Account>(
          stream: DatabaseService(uid: user.uid).account,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              Account account = snapshot.data;
              return StreamBuilder<List<Expense>>(
                  stream: DatabaseService(uid: user.uid).expenses,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      listOfExpenses = snapshot.data;
                      return Container(
                        child: SingleChildScrollView(
                          child: Column(
                            children: <Widget>[
                              Stack(
                                children: <Widget>[
                                  Container(
                                    width: double.infinity,
                                    height: height * 0.18, //300,
                                    color: Colors.white,
                                  ),
                                  Positioned(
                                    top: 0,
                                    left: 0,
                                    right: 0,
                                    child: Container(
                                        width: double.infinity,
                                        height: height * 0.13, //250,
                                        decoration: BoxDecoration(
                                          color:
                                              Colors.blue, //Colors.indigo[400],
                                        )),
                                  ),
                                  Positioned(
                                    top: width * 0.11, //70
                                    left: width * 0.2, //30,
                                    child: Text(
                                      "Analysis",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: width * 0.06 //30
                                          ),
                                    ),
                                  ),
                                ],
                              ),

                                GestureDetector(
                                onTap: () {
                                  _dialogYearlyAnalysis();
                                },
                                child: Padding(
                                  padding: EdgeInsets.only(
                                    top: width * 0.03,
                                    bottom: width * 0.05,
                                  ),
                                  child: Positioned(
                                    left: width * 0.5, // 30,
                                    right: width * 0.07, // 30,
                                    child: Container(
                                      height: height * 0.19, //150,
                                      width: width * 0.85, // 70,
                                      decoration: BoxDecoration(
                                          color: Colors.blue,
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          boxShadow: [
                                            BoxShadow(
                                                color: Colors.grey[400],
                                                blurRadius: 5,
                                                offset: Offset(0, 2))
                                          ]),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          Row(
                                            children: <Widget>[
                                              Padding(
                                                padding: EdgeInsets.only(
                                                  top: width * 0.03,
                                                  left: width * 0.05,
                                                ),
                                                child: Text(
                                                  'Yearly expenses',
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      //fontWeight: FontWeight.bold,
                                                      fontSize: width * 0.07),
                                                ),
                                              ),
                                           
                                            ],
                                          ),
                                          SizedBox(
                                            height: height * 0.008,
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  _dialogMonthlyAnalysis();
                                },
                                child: Padding(
                                  padding: EdgeInsets.only(
                                    top: width * 0.03,
                                    bottom: width * 0.05,
                                  ),
                                  child: Positioned(
                                    left: width * 0.5, // 30,
                                    right: width * 0.07, // 30,
                                    child: Container(
                                      height: height * 0.19, //150,
                                      width: width * 0.85, // 70,
                                      decoration: BoxDecoration(
                                          color: Colors.blue,
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          boxShadow: [
                                            BoxShadow(
                                                color: Colors.grey[400],
                                                blurRadius: 5,
                                                offset: Offset(0, 2))
                                          ]),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          Row(
                                            children: <Widget>[
                                              Padding(
                                                padding: EdgeInsets.only(
                                                  top: width * 0.03,
                                                  left: width * 0.05,
                                                ),
                                                child: Text(
                                                  'Monthly analysis',
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      //fontWeight: FontWeight.bold,
                                                      fontSize: width * 0.07),
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: height * 0.008,
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    } else {
                      print(snapshot);
                      return SizedBox(child: Text("No expenses to analyze"));
                    }
                  });
            } else {
              return SizedBox(
                child: Text("No expenses to analyze"),
              );
            }
          }),
    );
  }
}
