import 'dart:convert';

import 'package:budget_sidekick/Models/category.dart';
import 'package:budget_sidekick/Models/expense.dart';
import 'package:budget_sidekick/Screens/Core/features/Categories/categories.dart';
import 'package:budget_sidekick/Screens/Core/features/Expenses/expenses.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

Map<String, double> finalMap;

Map toGraphdataMonthly(listOfCategories, listOfExpensesUnfiltered, month, year, profit) {
  List<Expense> listOfExpenses =
      filterData(listOfExpensesUnfiltered, month, year, profit);

  Map<Category, double> graphData = new Map.fromIterable(listOfCategories,
      key: (category) => category, value: (category) => 0);

  for (var i = 0; i < listOfExpenses.length; i++) {
    Expense tempExpense = listOfExpenses[i];

    graphData.forEach((key, value) {
      if (key.id == tempExpense.category) {
        graphData.update(key, (value) => value + tempExpense.amount);
      }
    });
  }

  Map graphData2 = Map.from(graphData);
  graphData2.clear();

  List userCopy = graphData.entries.toList();
  for (var entry in graphData.entries) {
    if (graphData.containsKey(entry.key)) {
      graphData2.update(entry.key.name.toString(), (v) => entry.value,
          ifAbsent: () => entry.value);
    }
    //var threeValue = finalMap.putIfAbsent(entry.key.name.toString(), () => entry.value.roundToDouble());
    //finalMap.update(entry.key.name, (v) =>  entry.value, ifAbsent: () =>  entry.value);
    //print(graphData2);

  }
  //TODO: Remove empty categories ==> Throws error tho
  //graphData2.removeWhere((key, value) => value==0.0);
  print(graphData2);
  return graphData2;
}

List<Expense> filterData(listOfExpensesUnfiltered, month, year, profit) {
  List<Expense> listOfExpenses = [];
  for (var j = 0; j < listOfExpensesUnfiltered.length; j++) {
    Expense tempExpense = listOfExpensesUnfiltered[j];
    month = changeMonthToNumber(month);
    DateTime date = tempExpense.date;
    String dateYear = date.year.toString();
    String dateMonth = date.month.toString();
    
    if (dateYear == year && dateMonth == month && tempExpense.profit == profit) {
      listOfExpenses.add(tempExpense);
    }
  }

  return listOfExpenses;
}

//ŠROOOOOOOOOOOOOOOT
String changeMonthToNumber(month) {
  switch (month) {
    case 'January':
      {
        month = '1';
      }
      break;
    case 'February':
      {
        month = '2';
      }
      break;
    case 'March':
      {
        month = '3';
      }
      break;
    case 'April':
      {
        month = '4';
      }
      break;
    case 'May':
      {
        month = '5';
      }
      break;

    case 'June':
      {
        month = '6';
      }
      break;

    case 'July':
      {
        month = '7';
      }
      break;
    case 'August':
      {
        month = '8';
      }
      break;
    case 'September':
      {
        month = '9';
      }
      break;
    case 'October':
      {
        month = '10';
      }
      break;
    case 'November':
      {
        month = '11';
      }
      break;
    case 'December':
      {
        month = '12';
      }
      break;

    default:
      {
        
      }
      break;
  }
  return month;
}
