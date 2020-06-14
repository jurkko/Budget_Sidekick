import 'dart:convert';

import 'package:budget_sidekick/Models/category.dart';
import 'package:budget_sidekick/Models/expense.dart';
import 'package:budget_sidekick/Screens/Core/features/Categories/categories.dart';
import 'package:budget_sidekick/Screens/Core/features/Expenses/expenses.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

Map<String, double> finalMap;

Map toGraphdata(listOfCategories, listOfExpensesUnfiltered, month, year) {
  List<Expense> listOfExpenses =
      filterData(listOfExpensesUnfiltered, month, year);

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
    print(entry.key);
    print(entry.value);
  }

  Map <String,double> graphData3 = parseValues(graphData2);
  return graphData3;
}

Map parseValues(graphData2) {
  Map <String,double>graphData3;
   for (var entry in graphData2.entries) {
 
     double value2 = double.parse(entry.value);
     String key2 = entry.key.name.toString();
      var threeValue = graphData3.putIfAbsent(key2, () => value2);
   
    //var threeValue = finalMap.putIfAbsent(entry.key.name.toString(), () => entry.value.roundToDouble());
    //finalMap.update(entry.key.name, (v) =>  entry.value, ifAbsent: () =>  entry.value);
 
    print(entry.key);
    print(entry.value);
  }
     print(graphData3);
  return graphData3;
}

List<Expense> filterData(listOfExpensesUnfiltered, month, year) {
  List<Expense> listOfExpenses = [];
  for (var j = 0; j < listOfExpensesUnfiltered.length; j++) {
    Expense tempExpense = listOfExpensesUnfiltered[j];
    DateTime date = tempExpense.date;
    String dateYear = date.year.toString();
    String dateMonth = date.month.toString();
    if (dateYear == year && dateMonth == month) {
      listOfExpenses.add(tempExpense);
    }
  }

  return listOfExpenses;
}
