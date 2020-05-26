import 'package:flutter/material.dart';
import 'package:budget_sidekick/core/menu.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: Menu());
  }
}
