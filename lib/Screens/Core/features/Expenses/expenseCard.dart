import 'package:flutter/material.dart';
import 'package:budget_sidekick/Models/expense.dart';
import 'package:intl/intl.dart';
import 'package:budget_sidekick/Services/database.dart';

class ExpenseCard extends StatelessWidget {
  final Expense expense;

  const ExpenseCard({Key key, this.expense}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    return Column(
      children: <Widget>[
        GestureDetector(
          onTap: () {
            //Edit
          },
          child: Container(
            //padding: EdgeInsets.all(width * 0.005),
            width: width,
            height: height * 0.08321,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Padding(
                        padding: EdgeInsets.only(left: width * 0.04),
                        child: Container(
                            child: Icon(
                          IconData(expense.iconCode,
                              fontFamily: 'MaterialIcons'),
                          color: Colors.grey[600],
                          size: width * 0.054,
                        ))),
                    Padding(
                        padding: EdgeInsets.only(left: width * 0.01),
                        child: Container(
                          child: Text(
                            DateFormat('dd.MM.yyy  hh:mm ')
                                .format(expense.date),
                            //overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontWeight: FontWeight.bold,
                              fontSize: width * 0.035,
                            ),
                          ),
                        )),
                    Padding(
                        padding: EdgeInsets.only(left: width * 0.02),
                        child: Container(
                          child: Text(
                            expense.name,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              color: Colors.grey[600],
                              //fontWeight: FontWeight.bold,
                              fontSize: width * 0.044,
                            ),
                          ),
                        )),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(right: width * 0.05),
                  child: Text(
                    (expense.profit ? "+" : "-") +
                        expense.amount.toString() +
                        "€",
                    style: TextStyle(
                      color: expense.profit == true
                          ? Colors.green[700]
                          : Colors.red[700],
                      fontWeight: FontWeight.bold,
                      fontSize: width * 0.044,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
