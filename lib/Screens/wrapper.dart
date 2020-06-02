import 'package:budget_sidekick/Screens/Auth/authenticate.dart';
import 'package:budget_sidekick/Screens/Auth/signup.dart';
import 'package:flutter/material.dart';
import 'package:budget_sidekick/Models/user.dart';
import 'package:provider/provider.dart';
import 'package:budget_sidekick/Screens/Auth/login.dart';
import 'package:budget_sidekick/screens/Core/menu.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    if (user == null) {
      return Authenticate();
    } else {
      return Menu();
    }
  }
}
