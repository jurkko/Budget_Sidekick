import 'dart:collection';

import 'package:budget_sidekick/Models/account.dart';
import 'package:budget_sidekick/Models/expense.dart';
import 'package:budget_sidekick/Models/category.dart';

import 'package:budget_sidekick/Screens/Core/features/Analysis/DataRetrieval/monthlyData.dart';
import 'package:budget_sidekick/Screens/Core/features/Categories/categories.dart';
import 'package:budget_sidekick/Screens/Core/loading.dart';
import 'package:budget_sidekick/Services/database.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:pie_chart/pie_chart.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:budget_sidekick/Models/user.dart';

class MonthlyAnalysisDialog extends StatefulWidget {
  @override
  _MonthlyAnalysisDialogState createState() => _MonthlyAnalysisDialogState();
}

class _MonthlyAnalysisDialogState extends State<MonthlyAnalysisDialog> {
  Color _colorContainer = Colors.green[400];
  bool profit = true;
  int _profit = 1;
  int i = 0;
  String choosenMonth = 'June';
  String choosenYear = '2020';
  String type = 'Inflow';
  bool dataShownInPercentages = true;

  @override
  void initState() {
    super.initState();
    if (profit) {
      _profit = 1;
    } else {
      _profit = 2;
      _colorContainer = Colors.red[300];
    }
  }

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
  List<String> listOfYears = ['2018', '2019', '2020'];

  List<Category> listOfCategories = [];

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    final user = Provider.of<User>(context);
    final height = MediaQuery.of(context).size.height;
    List<Expense> listOfExpenses = [];
    return AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(width * 0.050)),
      title: Text(
        type + " analysis",
        textAlign: TextAlign.center,
      ),
      backgroundColor: _colorContainer,
      content: StreamBuilder<Account>(
          stream: DatabaseService(uid: user.uid).account,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              Account account = snapshot.data;
              return StreamBuilder<List<Expense>>(
                  stream: DatabaseService(uid: user.uid).expenses,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      listOfExpenses = snapshot.data;

                      //print(listOfExpenses);
                      return StreamBuilder<List<Category>>(
                        stream: DatabaseService(uid: user.uid).categories,
                        builder: (context, snapshot) {
                          listOfCategories = snapshot.data;
                          var neki = toGraphdataMonthly(
                              listOfCategories,
                              listOfExpenses,
                              choosenMonth,
                              choosenYear,
                              profit);

                          Map<String, double> map = neki.map(
                              (a, b) => MapEntry(a as String, b as double));
                          if (snapshot.hasData && map.isNotEmpty) {
                            return Container(
                                height: height * 0.8,
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(
                                        top: height * 0.03,
                                      ),
                                    ),
                                    Center(
                                      child: Text('Choose the desired time:',style: TextStyle(fontSize: 19),),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Theme(
                                          data: Theme.of(context).copyWith(
                                              canvasColor: _colorContainer),
                                          child: DropdownButton<String>(
                                            value: choosenMonth,
                                            onChanged: (String newValue) {
                                              setState(() {
                                                choosenMonth = newValue;
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
                                              canvasColor: _colorContainer),
                                          child: DropdownButton<String>(
                                            value: choosenYear,
                                            onChanged: (String newValue) {
                                              setState(() {
                                                choosenYear = newValue;
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
                                    Padding(
                                      padding: EdgeInsets.only(
                                          bottom: height * 0.02),
                                    ),

                                    PieChart(
                                      dataMap: map,
                                      animationDuration:
                                          Duration(milliseconds: 800),
                                      chartLegendSpacing: 32.0,
                                      chartRadius:
                                          MediaQuery.of(context).size.width /
                                              2.7,
                                      showChartValuesInPercentage:
                                          dataShownInPercentages,
                                      showChartValues: true,
                                      showChartValuesOutside: false,
                                      chartValueBackgroundColor:
                                          Colors.grey[200],
                                      showLegends: true,
                                      legendPosition: LegendPosition.right,
                                      decimalPlaces: 1,
                                      showChartValueLabel: true,
                                      initialAngle: 0,
                                      chartValueStyle:
                                          defaultChartValueStyle.copyWith(
                                        color: Colors.blueGrey[900]
                                            .withOpacity(0.9),
                                      ),
                                      chartType: ChartType.disc,
                                    ),
                                    Row(
                                      children: <Widget>[
                                        Radio(
                                          activeColor: Colors.green[900],
                                          value: 1,
                                          groupValue: _profit,
                                          onChanged: (value) {
                                            setState(() {
                                              profit = true;
                                              _profit = value;
                                              _colorContainer =
                                                  Colors.green[400];
                                              type = 'Inflow';
                                            });
                                          },
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(
                                              left: width * 0.01),
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
                                              _colorContainer = Colors.red[300];
                                              type = 'Outflow';
                                            });
                                          },
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(
                                              left: width * 0.01),
                                          child: Text("Outflow"),
                                        )
                                      ],
                                    ),
                                    Padding(
                                      padding:
                                          EdgeInsets.only(top: height * 0.03),
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Center(
                                          child:
                                              Text('Show data in percentages:',style: TextStyle(fontSize: 14)),
                                        ),
                                        Theme(
                                          data: Theme.of(context).copyWith(
                                              canvasColor: _colorContainer),
                                          child: DropdownButton<bool>(
                                            value: dataShownInPercentages,
                                            onChanged: (bool newValue) {
                                              setState(() {
                                                dataShownInPercentages =
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
                                            items: <bool>[true, false]
                                                .map<DropdownMenuItem<bool>>(
                                                    (bool value) {
                                              return DropdownMenuItem<bool>(
                                                value: value,
                                                child: Text(value.toString(),style: TextStyle(fontSize: 14)),
                                              );
                                            }).toList(),
                                          ),
                                        ),
                                      ],
                                    ),

                                    //return chartWidget
                                  ],
                                ));
                          } else {
                            return Loading();
                          }
                        },
                      );
                    } else {
                      return Loading();
                    }
                  });
            } else {
              return Loading();
            }
          }),
    );
  }
}
