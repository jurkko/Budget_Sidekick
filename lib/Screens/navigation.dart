import 'package:budget_sidekick/Screens/Core/features/Expenses/expenses.dart';
import 'package:flutter/material.dart';

import 'Auth/login.dart';

class BudgetTracker extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LoginScreen(),
      initialRoute: 'Start',
      routes: {
        Expenses.id: (context) => Expenses(),
      },
    );
  }
}
