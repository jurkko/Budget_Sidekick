import 'package:budget_sidekick/Models/expense.dart';
import 'package:budget_sidekick/Screens/Core/features/Categories/categories.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

List<String> categories = [];

Map toGraphdata(listOfExpenses, month, year) {
  Map graphData;

 
  for (var i = 0; i < listOfExpenses.length; i++) {
    Expense tempExpense = listOfExpenses[i];
    DateTime date = tempExpense.date;
    String dateYear = date.year.toString();
    String dateMonth = date.month.toString();
  

    if(dateYear==year && dateMonth == month){

      categories.add(tempExpense.category);
      print(tempExpense.category);
      print('henlo fren');
    }      
    
    

  }
 
  return graphData;
}

