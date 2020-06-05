import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:budget_sidekick/Models/expense.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddExpense extends StatefulWidget {
  static const String id = 'addexpense';
  @override
  _AddExpenseState createState() => _AddExpenseState();
}

class _AddExpenseState extends State<AddExpense> {
  @override
  void initState() {
    getCurrentUser();
  }

  final _auth = FirebaseAuth.instance;
  final _firestore = Firestore.instance;

  FirebaseUser loggedInUser;

  String name;
  double amount;
  String category;

  List<String> categories = ['other', 'food', 'clothes', 'drugs', 'alcohol'];
  void getCurrentUser() async {
    try {
      final user = await _auth.currentUser();
      if (user != null) {
        loggedInUser = user;

        print(user.uid);
      }
    } catch (E) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: Column(
        children: <Widget>[
          SizedBox(
            height: 50,
          ),
          Text('enter a expense name'),
          Padding(
            padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
            child: TextField(
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  border: new OutlineInputBorder(
                    borderRadius: const BorderRadius.all(
                      const Radius.circular(15.0),
                    ),
                  ),
                ),
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.black),
                onChanged: (value) {
                  name = value;
                }),
          ),
          Text('enter a expense amount'),
          Padding(
            padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
            child: TextField(
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  border: new OutlineInputBorder(
                    borderRadius: const BorderRadius.all(
                      const Radius.circular(15.0),
                    ),
                  ),
                ),
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.black),
                onChanged: (value) {
                  amount = double.parse(value);
                }),
          ),
          Text('enter a expense category (Tu itak pride slajder)'),
          Padding(
            padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
            child: TextField(
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  border: new OutlineInputBorder(
                    borderRadius: const BorderRadius.all(
                      const Radius.circular(15.0),
                    ),
                  ),
                ),
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.black),
                onChanged: (value) {
                  category = value;
                }),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          String uid = loggedInUser.uid;
          Expense expense = new Expense(name, amount, category);
          _firestore.collection('Expenses').add({
            'name': expense.name,
            'amount': expense.amount,
            'category': expense.category,
            'user': uid,
          });
        },
        label: Text('Add'),
        icon: Icon(Icons.add),
        backgroundColor: Colors.green,
      ),
    );
  }
}
