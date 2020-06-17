import 'package:budget_sidekick/Models/account.dart';
import 'package:budget_sidekick/Screens/Core/features/Analysis/DataRetrieval/monthlyData.dart';
import 'package:flutter/material.dart';
import 'package:budget_sidekick/Models/expense.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
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
  final foramterDate = new DateFormat('dd.MM.yyyy');

  String choosenMonth = 'June';
  String choosenYear = '2020';

  bool profit = true;
  int _profit = 1;
  List<String> listOfMonths = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December'
  ];
  List<Expense> listOfExpenses = [];
  List<Expense> listOfExpensesTable = [];
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
                      listOfExpensesTable = toTableDataMonthly(
                          listOfExpenses, choosenMonth, choosenYear, profit);
                      listOfExpensesTable
                          .sort((a, b) => a.date.compareTo(b.date));
                      return Container(
                        child: SingleChildScrollView(
                          child: Column(
                            children: <Widget>[
                              Stack(
                                children: <Widget>[
                                  Container(
                                    width: double.infinity,
                                    height: height * 0.15, //300,
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
                              Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Text(
                                        "Choose the time:",
                                        style: TextStyle(
                                            color: Colors.grey[600],
                                            fontSize: width * 0.05),
                                      ),
                                      Theme(
                                        data: Theme.of(context).copyWith(
                                            canvasColor: Colors.white),
                                        child: DropdownButton<String>(
                                          value: choosenMonth,
                                          onChanged: (String newValue) {
                                            setState(() {
                                              choosenMonth = newValue;
                                            });
                                          },
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: width * 0.045),
                                          underline: Container(),
                                          icon: Icon(
                                            Icons.arrow_drop_down,
                                            color: Colors.black,
                                          ),
                                          items: listOfMonths
                                              .map<DropdownMenuItem<String>>(
                                                  (String value) {
                                            return DropdownMenuItem<String>(
                                              value: value,
                                              child: Text(value),
                                            );
                                          }).toList(),
                                        ),
                                      ),
                                      Theme(
                                        data: Theme.of(context).copyWith(
                                            canvasColor: Colors.white),
                                        child: DropdownButton<String>(
                                          value: choosenYear,
                                          onChanged: (String newValue) {
                                            setState(() {
                                              choosenYear = newValue;
                                            });
                                          },
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: width * 0.045),
                                          underline: Container(),
                                          icon: Icon(
                                            Icons.arrow_drop_down,
                                            color: Colors.black,
                                          ),
                                          items: <String>[
                                            '2019',
                                            '2020',
                                          ].map<DropdownMenuItem<String>>(
                                              (String value) {
                                            return DropdownMenuItem<String>(
                                              value: value,
                                              child: Text(value),
                                            );
                                          }).toList(),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Radio(
                                        activeColor: Colors.green[900],
                                        value: 1,
                                        groupValue: _profit,
                                        onChanged: (value) {
                                          setState(() {
                                            profit = true;
                                            _profit = value;
                                          });
                                        },
                                      ),
                                      Padding(
                                        padding:
                                            EdgeInsets.only(left: width * 0.01),
                                        child: Text("Inflow"),
                                      ),
                                      Radio(
                                        activeColor: Colors.red[900],
                                        value: 2,
                                        groupValue: _profit,
                                        onChanged: (value) {
                                          setState(() {
                                            profit = false;
                                            _profit = value;
                                          });
                                        },
                                      ),
                                      Padding(
                                        padding:
                                            EdgeInsets.only(left: width * 0.01),
                                        child: Text("Outflow"),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                              Container(
                                height: height * 0.25,
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.vertical,
                                  child: DataTable(
                                    columns: const <DataColumn>[
                                      DataColumn(
                                        label: Text(
                                          'Name:',
                                          style: TextStyle(
                                              fontStyle: FontStyle.italic),
                                        ),
                                      ),
                                      DataColumn(
                                        label: Text(
                                          'Amount:',
                                          style: TextStyle(
                                              fontStyle: FontStyle.italic),
                                        ),
                                      ),
                                      DataColumn(
                                        label: Text(
                                          'Date',
                                          style: TextStyle(
                                              fontStyle: FontStyle.italic),
                                        ),
                                      ),
                                    ],
                                    rows: listOfExpensesTable
                                        .map((e) => DataRow(cells: [
                                              DataCell(Text(e.name)),
                                              DataCell(Text(
                                                  e.amount.toString() + ' €')),
                                              DataCell(Text(
                                                  foramterDate.format(e.date))),
                                            ]))
                                        .toList(),
                                  ),
                                ),
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
                                      height: height * 0.15, //150,
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          Row(
                                            children: <Widget>[
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                  left: 10,
                                                ),
                                                child: Icon(
                                                  Icons.insert_chart,
                                                  color: Colors.white,
                                                  size: width * 0.23,
                                                ),
                                              ),
                                              Column(
                                                children: [
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                      top: width * 0.03,
                                                      left: width * 0.025,
                                                      right: width * 0.025,
                                                    ),
                                                    child: Text(
                                                      'Yearly',
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          //fontWeight: FontWeight.bold,
                                                          fontSize:
                                                              width * 0.08),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                      top: width * 0.01,
                                                      left: width * 0.025,
                                                      right: width * 0.025,
                                                    ),
                                                    child: Text(
                                                      'Analyze your yearly expenses ',
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          //fontWeight: FontWeight.bold,
                                                          fontSize:
                                                              width * 0.04),
                                                    ),
                                                  ),
                                                ],
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
                                      height: height * 0.15, //150,
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          Row(
                                            children: <Widget>[
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                  left: 10,
                                                ),
                                                child: Icon(
                                                  Icons.pie_chart,
                                                  color: Colors.white,
                                                  size: width * 0.23,
                                                ),
                                              ),
                                              Column(
                                                children: [
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                      top: width * 0.03,
                                                      left: width * 0.025,
                                                      right: width * 0.025,
                                                    ),
                                                    child: Text(
                                                      'Monthly',
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          //fontWeight: FontWeight.bold,
                                                          fontSize:
                                                              width * 0.08),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                      top: width * 0.01,
                                                      left: width * 0.025,
                                                      right: width * 0.025,
                                                    ),
                                                    child: Text(
                                                      'Analyze your yearly expenses ',
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          //fontWeight: FontWeight.bold,
                                                          fontSize:
                                                              width * 0.04),
                                                    ),
                                                  ),
                                                ],
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
