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
  bool profit = true;
  int _profit = 1;
  Color _colorContainer = Colors.green[400];
  List<charts.Series> seriesList;
  List<MonthlyExpense> neki;
  List<String> listOfYears = ['2018', '2019', '2020'];
  List<Expense> listOfExpenses = [];
  List<Category> listOfCategories = [];
  String type = 'Inflow';

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

  String choosenYear = '2020';

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    final user = Provider.of<User>(context);
    final height = MediaQuery.of(context).size.height;

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

                          neki = toGraphdataYearly(listOfCategories,
                              listOfExpenses, choosenYear, profit);

                          //seriesList = populateChart(neki);

                          if (snapshot.hasData) {
                            return Container(
                                height: height * 0.65,
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Theme(
                                          data: Theme.of(context).copyWith(canvasColor: _colorContainer),
                                          child: DropdownButton<String>(
                                            value: choosenYear,
                                            onChanged: (String newValue) {
                                              setState(() {
                                                choosenYear = newValue;
                                              });
                                            },
                                            style:
                                                TextStyle(color: Colors.black,fontSize: 20),
                                            underline: Container(
                                              height: 1,
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
                                    Center(
                                        child: Container(
                                            child: SfCartesianChart(
                                                title: ChartTitle(
                                                    text: 'Yearly ' + type),
                                                tooltipBehavior:
                                                    TooltipBehavior(
                                                        enable: true,
                                                        header: 'Monthly'),
                                                // Initialize category axis
                                                primaryXAxis: CategoryAxis(
                                                    title: AxisTitle(
                                                        text: 'Months',
                                                        textStyle:
                                                            ChartTextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontFamily:
                                                                    'Roboto',
                                                                fontSize: 16,
                                                                fontStyle:
                                                                    FontStyle
                                                                        .italic,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w300))),

                                                //primaryYAxis: LogarithmicAxis(),
                                                series: <
                                                    LineSeries<MonthlyExpense,
                                                        String>>[
                                          LineSeries<MonthlyExpense, String>(
                                            // Bind data source
                                            enableTooltip: true,
                                            dataSource: neki,
                                            xValueMapper:
                                                (MonthlyExpense sales, _) =>
                                                    sales.month,
                                            yValueMapper:
                                                (MonthlyExpense sales, _) =>
                                                    sales.amount,
                                            markerSettings: MarkerSettings(
                                                isVisible: true,
                                                // Marker shape is set to diamond
                                                shape: DataMarkerType.diamond),
                                            dataLabelSettings:
                                                DataLabelSettings(
                                              isVisible: true,
                                              // Positioning the data label
                                              useSeriesColor: true,
                                            ),
                                          )
                                        ]))),
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
