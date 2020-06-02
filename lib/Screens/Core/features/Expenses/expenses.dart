import 'package:flutter/material.dart';

class Expenses extends StatefulWidget {
  @override
  ExpensesState createState() => ExpensesState();
}

class ExpensesState extends State<Expenses> {
  @override
  Widget build(BuildContext context) {
    return Container(child: Center(child: Text("Expenses")));
  }
}
