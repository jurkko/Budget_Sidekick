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
    listOfCategories, listOfExpensesUnfiltered, year, profit) {
  List<Expense> listOfExpenses =
      filterData(listOfExpensesUnfiltered, year, profit);

  List<MonthlyExpense> graphData2 = fillLIstWithMonths();

  print(profit);
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
  graphData2 = shrotSwitchForRename(graphData2);
  return graphData2;
}

List<MonthlyExpense> shrotSwitchForRename(graphData2) {
  for (var i = 0; i < graphData2.length; i++) {
    MonthlyExpense temp = graphData2[i];
    if (temp.month == '1') {
      temp.month = 'January';
    } else if (temp.month == '2') {
      temp.month = 'February';
    } else if (temp.month == '3') {
      temp.month = 'March';
    } else if (temp.month == '4') {
      temp.month = 'April';
    } else if (temp.month == '5') {
      temp.month = 'May';
    } else if (temp.month == '6') {
      temp.month = 'June';
    } else if (temp.month == '7') {
      temp.month = 'July';
    } else if (temp.month == '8') {
      temp.month = 'August';
    } else if (temp.month == '9') {
      temp.month = 'September';
    } else if (temp.month == '10') {
      temp.month = 'October';
    } else if (temp.month == '11') {
      temp.month = 'November';
    } else if (temp.month == '12') {
      temp.month = 'December';
    }
  }
  return graphData2;
}

List<MonthlyExpense> fillLIstWithMonths() {
  List<MonthlyExpense> tempList = [];
  for (var i = 1; i <= 12; i++) {
    var temp = new MonthlyExpense();
    temp.month = i.toString();

    temp.amount = 0.0;
    tempList.add(temp);
  }
  return tempList;
}

List<Expense> filterData(listOfExpensesUnfiltered, year, profit) {
  List<Expense> listOfExpenses = [];
  for (var j = 0; j < listOfExpensesUnfiltered.length; j++) {
    Expense tempExpense = listOfExpensesUnfiltered[j];

    DateTime date = tempExpense.date;
    String dateYear = date.year.toString();

    if (dateYear == year && tempExpense.profit == profit) {
      listOfExpenses.add(tempExpense);
    }
  }

  return listOfExpenses;
}
