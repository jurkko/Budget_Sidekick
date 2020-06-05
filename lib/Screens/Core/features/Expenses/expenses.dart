import 'package:budget_sidekick/Screens/Core/features/Expenses/expenseWidget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:budget_sidekick/Screens/Core/features/Expenses/addExpense.dart';

class Expenses extends StatefulWidget {
  static const String id = 'expenses';
  @override
  ExpensesState createState() => ExpensesState();
}

class ExpensesState extends State<Expenses> {
  String id;
  @override
  void initState() {
    getCurrentUser();
  }

  final _auth = FirebaseAuth.instance;
  final _firestore = Firestore.instance;
  FirebaseUser loggedInUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: Column(
        children: <Widget>[
        
          StreamBuilder(
              stream: _firestore
                  .collection('Expenses')
                  .where('user', isEqualTo: id)
                  .snapshots(),
              builder: (context, snapshot) {
                List<ExpenseContainer> expenseWidgets = [];
                if (snapshot.hasData) {
                  final expenses = snapshot.data.documents;
                  for (var expense in expenses) {
                    final expenseName = expense.data['name'];
                    final expenseAmount = expense.data['amount'];
                    final expenseCategory = expense.data['category'];
                    final expenseWidget = ExpenseContainer(
                      name: expenseName,
                      amount: expenseAmount,
                      category: expenseCategory,
                    );
                    expenseWidgets.add(expenseWidget);
                  }
                  return Expanded(
                    
                    child: ListView(
                      children: expenseWidgets,
                    ),
                  );
                }
              })
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.of(context).push(
              new MaterialPageRoute(builder: (context) => new AddExpense()));
          getCurrentUser();
        },
        label: Text('New expense'),
        icon: Icon(Icons.add),
        backgroundColor: Colors.green,
      ),
    );
  }

  void getCurrentUser() async {
    try {
      final user = await _auth.currentUser();
      if (user != null) {
        loggedInUser = user;
        getExpensesStream(loggedInUser);
        id = user.uid;
        print(user.uid);
      }
    } catch (E) {}
  }

  void getExpensesStream(FirebaseUser loggedInUser) async {
    await for (var snapshot in _firestore
        .collection('Expenses')
        .where('user', isEqualTo: id)
        .snapshots()) {
      for (var message in snapshot.documents) {
        print(message.data);
      }
    }
  }
}
