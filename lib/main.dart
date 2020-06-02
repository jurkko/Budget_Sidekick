import 'package:budget_sidekick/Models/user.dart';
import 'package:budget_sidekick/Services/auth.dart';
import 'package:budget_sidekick/screens/wrapper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<User>.value(
        value: AuthService().user, child: MaterialApp(home: Wrapper()));
  }
}
