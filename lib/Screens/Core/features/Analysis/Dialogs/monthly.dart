import 'package:budget_sidekick/Models/account.dart';
import 'package:budget_sidekick/Models/expense.dart';
import 'package:budget_sidekick/Models/category.dart';
import 'package:budget_sidekick/Screens/Core/features/Analysis/DataRetrieval/months.dart';
import 'package:budget_sidekick/Screens/Core/features/Categories/categories.dart';
import 'package:budget_sidekick/Services/database.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:budget_sidekick/Models/user.dart';

class MonthlyAnalysisDialog extends StatefulWidget {
  @override
  _MonthlyAnalysisDialogState createState() => _MonthlyAnalysisDialogState();
}

class _MonthlyAnalysisDialogState extends State<MonthlyAnalysisDialog> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    final user = Provider.of<User>(context);
    final height = MediaQuery.of(context).size.height;
    var choosenMonth = '5';
    var choosenYear = '2020';

    List<Expense> listOfExpenses = [];
    List<Category> listOfCategories = [];

    var data = [
      ClicksPerYear('2016', 12, Colors.red),
      ClicksPerYear('2017', 42, Colors.yellow),
      ClicksPerYear('2018', 2, Colors.green),
    ];

    var series = [
      charts.Series(
        domainFn: (ClicksPerYear clickData, _) => clickData.year,
        measureFn: (ClicksPerYear clickData, _) => clickData.clicks,
        colorFn: (ClicksPerYear clickData, _) => clickData.color,
        id: 'Clicks',
        data: data,
      ),
    ];

    var chart = charts.BarChart(
      series,
      animate: true,
    );

    var chartWidget = Padding(
      padding: EdgeInsets.all(32.0),
      child: SizedBox(
        height: 200.0,
        child: chart,
      ),
    );

    return AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(width * 0.050)),
      title: Text(
        "Analysis",
        textAlign: TextAlign.center,
      ),
      backgroundColor: Colors.purple,
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
                          if (snapshot.hasData) {
                            listOfCategories = snapshot.data;
                            Map graphData = toGraphdata(
                                listOfExpenses, choosenMonth, choosenYear);
                            print(listOfCategories);
                            return Container(
                                child: Column(
                              children: [
                                DropdownButton<String>(
                                  value: choosenMonth,
                                  onChanged: (String newValue) {
                                    setState(() {
                                      choosenMonth = newValue;
                                      print(' 1   ' + choosenMonth);
                                    });
                                  },
                                  style: TextStyle(color: Colors.black),
                                  underline: Container(
                                    height: 1,
                                    color: Colors.white,
                                  ),
                                  icon: Icon(
                                    Icons.arrow_drop_down,
                                    color: Colors.white,
                                  ),
                                  items: <String>[
                                    '1',
                                    '2',
                                    '3',
                                    '4',
                                    '5',
                                    '6',
                                    '7',
                                    '8',
                                    '9',
                                    '10',
                                    '11',
                                    '12',
                                  ].map<DropdownMenuItem<String>>(
                                      (String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                ),
                                DropdownButton<String>(
                                  value: choosenYear,
                                  onChanged: (String newValue) {
                                    setState(() {
                                      choosenYear = newValue;
                                      print(' 1    ' + choosenYear);
                                    });
                                  },
                                  style: TextStyle(color: Colors.black),
                                  underline: Container(
                                    height: 1,
                                    color: Colors.white,
                                  ),
                                  icon: Icon(
                                    Icons.arrow_drop_down,
                                    color: Colors.white,
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

                                //return chartWidget
                              ],
                            ));
                          } else {
                            return SizedBox(
                                child: Text("Neki jebejo kategorije kolega"));
                          }
                        },
                      );
                    } else {
                      return SizedBox(
                          child: Text("Neki jebejo expensi kolega"));
                    }
                  });
            } else {
              return SizedBox(
                child: Text("Accounta ni ljega"),
              );
            }
          }),
    );
  }
}

class ClicksPerYear {
  final String year;
  final int clicks;
  final charts.Color color;

  ClicksPerYear(this.year, this.clicks, Color color)
      : this.color = charts.Color(
            r: color.red, g: color.green, b: color.blue, a: color.alpha);
}
