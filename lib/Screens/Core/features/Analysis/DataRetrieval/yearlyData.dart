import 'dart:convert';

import 'package:budget_sidekick/Models/category.dart';
import 'package:budget_sidekick/Models/expense.dart';
import 'package:budget_sidekick/Models/monthlyExpense.dart';
import 'package:budget_sidekick/Screens/Core/features/Analysis/Dialogs/monthlyInflow.dart';
import 'package:budget_sidekick/Screens/Core/features/Categories/categories.dart';
import 'package:budget_sidekick/Screens/Core/features/Expenses/expenses.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

List<MonthlyExpense> toGraphdataYearly(
    listOfCategories, listOfExpensesUnfiltered, year) {
  List<Expense> listOfExpenses = filterData(listOfExpensesUnfiltered, year);

  List<MonthlyExpense> graphData2 = fillLIstWithMonths();
  print(graphData2);

  for (var j = 0; j < listOfExpenses.length; j++) {
    Expense tempExpense = listOfExpenses[j];
    DateTime date = tempExpense.date;
    String dateMonth = date.month.toString();
    for (var i = 0; i < graphData2.length; i++) {
      if (dateMonth == graphData2[i].month) {
        graphData2[i].amount = graphData2[i].amount + tempExpense.amount;
        print('issa match');
      }
    }
  }

  return graphData2;
}

List<MonthlyExpense> fillLIstWithMonths() {
  List<MonthlyExpense> tempList = [];
  for (var i = 0; i <= 12; i++) {
    var temp = new MonthlyExpense();
    temp.month = i.toString();

    temp.amount = 0.0;
    tempList.add(temp);
  }
  return tempList;
}

List<Expense> filterData(listOfExpensesUnfiltered, year) {
  List<Expense> listOfExpenses = [];
  for (var j = 0; j < listOfExpensesUnfiltered.length; j++) {
    Expense tempExpense = listOfExpensesUnfiltered[j];

    DateTime date = tempExpense.date;
    String dateYear = date.year.toString();

    if (dateYear == year && tempExpense.profit == true) {
      listOfExpenses.add(tempExpense);
    }
  }

  return listOfExpenses;
}
