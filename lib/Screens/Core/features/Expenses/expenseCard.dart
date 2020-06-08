import 'package:flutter/material.dart';
import 'package:budget_sidekick/Models/expense.dart';

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
            height: height * 0.08,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Padding(
                          padding: EdgeInsets.all(width * 0.03),
                          child: expense.profit == true
                              ? Icon(
                                  Icons.arrow_upward,
                                  color: Colors.green,
                                  size: width * 0.06,
                                )
                              : Icon(Icons.arrow_downward,
                                  color: Colors.red, size: width * 0.06)),
                    ),
                    Padding(
                        padding: EdgeInsets.only(left: width * 0.03),
                        child: Container(
                          width: width * 0.4,
                          child: Text(
                            expense.name,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              color: expense.profit == true
                                  ? Colors.green[700]
                                  : Colors.red[700],
                              fontWeight: FontWeight.bold,
                              fontSize: width * 0.044,
                            ),
                          ),
                        )),
                  ],
                ),
                Text(
                  expense.amount.toString() + "€",
                  style: TextStyle(
                    color: expense.profit == true
                        ? Colors.green[700]
                        : Colors.red[700],
                    fontWeight: FontWeight.bold,
                    fontSize: width * 0.044,
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
