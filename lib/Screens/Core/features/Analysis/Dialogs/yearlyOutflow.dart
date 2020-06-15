import 'dart:collection';

import 'package:budget_sidekick/Models/account.dart';
import 'package:budget_sidekick/Models/expense.dart';
import 'package:budget_sidekick/Models/category.dart';
import 'package:budget_sidekick/Models/monthlyExpense.dart';

import 'package:budget_sidekick/Screens/Core/features/Analysis/DataRetrieval/yearlyData.dart';
import 'package:budget_sidekick/Screens/Core/features/Categories/categories.dart';
import 'package:budget_sidekick/Services/database.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:budget_sidekick/Models/user.dart';

class YearlyAnalysisDialog extends StatefulWidget {
  @override
  _YearlyAnalysisDialogState createState() => _YearlyAnalysisDialogState();
}

class _YearlyAnalysisDialogState extends State<YearlyAnalysisDialog> {
  @override
  void initState() {
    super.initState();
  }

  String choosenYear;

  List<charts.Series> seriesList;
  List<MonthlyExpense> neki;
  List<String> listOfYears = ['2018', '2019', '2020'];
  List<Expense> listOfExpenses = [];
  List<Category> listOfCategories = [];

  List<Color> gradientColors = [
    const Color(0xff23b6e6),
    const Color(0xff02d39a),
  ];

  bool showAvg = false;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    final user = Provider.of<User>(context);
    final height = MediaQuery.of(context).size.height;

    return AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(width * 0.050)),
      title: Text(
        "Inflow analysis",
        textAlign: TextAlign.center,
      ),
      backgroundColor: Colors.green,
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

                          neki = toGraphdataYearly(
                              listOfCategories, listOfExpenses, choosenYear);
                              
                          //seriesList = populateChart(neki);

                          if (snapshot.hasData) {
                            return Container(
                                height: height * 0.6,
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        DropdownButton<String>(
                                          value: choosenYear,
                                          onChanged: (String newValue) {
                                            setState(() {
                                              choosenYear = newValue;
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
                                      ],
                                    ),
                                    Center(
                                        child: Container(
                                            child: SfCartesianChart(
                                                // Initialize category axis
                                                primaryXAxis: CategoryAxis(),
                                                series: <
                                                    LineSeries<MonthlyExpense,
                                                        String>>[
                                          LineSeries<MonthlyExpense,
                                              String>(
                                            // Bind data source
                                            dataSource: neki,
                                            xValueMapper:
                                                (MonthlyExpense sales, _) =>
                                                    sales.month,
                                            yValueMapper:
                                                (MonthlyExpense sales, _) =>
                                                    sales.amount,
                                          )
                                        ])))

                                    //return chartWidget
                                  ],
                                ));
                          } else {
                            return SizedBox(
                                child: Text(
                                    "Neki jebejo kategorije kolega al pa nimaš faking Expensov tele mamino"));
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
