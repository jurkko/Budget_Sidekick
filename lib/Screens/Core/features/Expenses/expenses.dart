import 'package:budget_sidekick/Models/expense.dart';
import 'package:budget_sidekick/Models/account.dart';
import 'package:budget_sidekick/Screens/Core/features/Expenses/expenseCard.dart';
import 'package:flutter/material.dart';
import 'package:budget_sidekick/Models/user.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'textAnimate.dart';
import 'package:budget_sidekick/Services/database.dart';
import 'customDialog.dart';

class Expenses extends StatefulWidget {
  static const String id = 'expenses';
  @override
  ExpensesState createState() => ExpensesState();
}

class ExpensesState extends State<Expenses> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  Expense deletedExpense;
  String dataFormatada;
  List<Expense> listOfExpenses = [];
  _dialogAddExpense() {
    showDialog(
        context: context,
        builder: (context) {
          return CustomDialog();
        });
  }

  _dialogEditExpense(Expense exp) {
    showDialog(
        context: context,
        builder: (context) {
          return CustomDialog(e: exp);
        });
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      key: _scaffoldKey,
      body: StreamBuilder<Account>(
          stream: DatabaseService(uid: user.uid).account,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              Account account = snapshot.data;
              return StreamBuilder<List<Expense>>(
                  stream: DatabaseService(uid: user.uid).expenses,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      listOfExpenses = snapshot.data;
                      return Container(
                        child: SingleChildScrollView(
                          physics: NeverScrollableScrollPhysics(),
                          child: Column(
                            children: <Widget>[
                              Stack(
                                children: <Widget>[
                                  Container(
                                    width: double.infinity,
                                    height: height * 0.284, //300,
                                    color: Colors.white,
                                  ),
                                  Positioned(
                                    top: 0,
                                    left: 0,
                                    right: 0,
                                    child: Container(
                                        width: double.infinity,
                                        height: height * 0.25, //250,
                                        decoration: BoxDecoration(
                                          color:
                                              Colors.blue, //Colors.indigo[400],
                                        )),
                                  ),
                                  Positioned(
                                    top: width * 0.11, //70
                                    left: width * 0.2, //30,
                                    child: Text(
                                      "Expenses",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: width * 0.06 //30
                                          ),
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 0,
                                    top: width * 0.25,
                                    left: width * 0.07, // 30,
                                    right: width * 0.07, // 30,
                                    child: Container(
                                      height: height * 0.16, //150,
                                      width: width * 0.1, // 70,
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          boxShadow: [
                                            BoxShadow(
                                                color: Colors.grey[400],
                                                blurRadius: 5,
                                                offset: Offset(0, 2))
                                          ]),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          Padding(
                                            padding: EdgeInsets.only(
                                              left: width * 0.06,
                                              top: width * 0.04,
                                              bottom: width * 0.02,
                                            ),
                                            child: Text(
                                              "Balance",
                                              style: TextStyle(
                                                  color: Colors.grey[600],
                                                  fontSize: width * 0.05),
                                            ),
                                          ),
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              Padding(
                                                padding: EdgeInsets.only(
                                                    left: width * 0.05),
                                                child: Container(
                                                    width: width * 0.6,
                                                    child: TextAnimate<String>(
                                                      initialData: account
                                                              .balance
                                                              .toString() ??
                                                          "",
                                                      data: account.balance
                                                          .toString(),
                                                      builder: (value) => Text(
                                                        value + "€",
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: TextStyle(
                                                            color: Colors
                                                                    .lightBlue[
                                                                700], //Colors.indigo[400],
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize:
                                                                width * 0.1
                                                            //width * 0.1 //_saldoTamanho(saldoAtual)
                                                            ),
                                                      ),
                                                    )),
                                              ),
                                              Padding(
                                                padding: EdgeInsets.only(
                                                    right: width * 0.04),
                                                child: GestureDetector(
                                                  onTap: () {
                                                    _dialogAddExpense();
                                                  },
                                                  child: Container(
                                                    width: width * 0.12,
                                                    height: width * 0.12, //65,
                                                    decoration: BoxDecoration(
                                                        color: Colors.lightBlue[
                                                            700], //Colors.indigo[400],
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(50),
                                                        boxShadow: [
                                                          BoxShadow(
                                                            color: Colors.grey,
                                                            blurRadius: 7,
                                                            offset:
                                                                Offset(2, 2),
                                                          )
                                                        ]),
                                                    child: Icon(
                                                      Icons.add,
                                                      size: width * 0.07,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                          SizedBox(
                                            height: height * 0.008,
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                  padding: EdgeInsets.only(
                                    bottom: 0,
                                    left: width * 0.00,
                                    right: width * 0.00,
                                  ),
                                  child: SizedBox(
                                      width: width,
                                      height: height * 0.75,
                                      child: ListView.builder(
                                          itemCount: listOfExpenses.length,
                                          itemBuilder: (context, index) {
                                            Expense e = listOfExpenses[index];
                                            return InkWell(
                                              onLongPress: () {
                                                _dialogEditExpense(e);
                                              },
                                              child: Dismissible(
                                                direction:
                                                    DismissDirection.endToStart,
                                                onDismissed: (direction) {
                                                  deletedExpense =
                                                      listOfExpenses[index];
                                                  setState(() {
                                                    listOfExpenses
                                                        .removeAt(index);
                                                  });
                                                  print(e.user_id);
                                                  DatabaseService(uid: user.uid)
                                                      .removeExpense(e);
                                                  DatabaseService(uid: user.uid)
                                                      .handleBalance(
                                                          e.amount, !e.profit);
                                                  final snackBar = SnackBar(
                                                    content: Container(
                                                      padding: EdgeInsets.only(
                                                          bottom:
                                                              width * 0.025),
                                                      alignment:
                                                          Alignment.bottomLeft,
                                                      height: height * 0.05,
                                                      child: Text(
                                                        "Expense deleted",
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            //fontWeight: FontWeight.bold,
                                                            fontSize:
                                                                width * 0.05),
                                                      ),
                                                    ),
                                                    duration:
                                                        Duration(seconds: 2),
                                                    backgroundColor:
                                                        Colors.blue,
                                                    action: SnackBarAction(
                                                      label: "Undo",
                                                      textColor: Colors.white,
                                                      onPressed: () {
                                                        setState(() {
                                                          listOfExpenses.insert(
                                                              index,
                                                              deletedExpense);
                                                        });
                                                        DatabaseService(
                                                                uid: user.uid)
                                                            .addExpense(
                                                                deletedExpense);
                                                      },
                                                    ),
                                                  );
                                                  _scaffoldKey.currentState
                                                      .showSnackBar(snackBar);
                                                },
                                                key: ValueKey(e.id),
                                                background: Container(
                                                  padding: EdgeInsets.only(
                                                      right: 10,
                                                      top: width * 0.04),
                                                  alignment: Alignment.topRight,
                                                  color: Colors.red,
                                                  child: Icon(
                                                    Icons.delete_outline,
                                                    color: Colors.white,
                                                    size: width * 0.07,
                                                  ),
                                                ),
                                                child: ExpenseCard(
                                                  expense: e,
                                                ),
                                              ),
                                            );
                                          }))),
                            ],
                          ),
                        ),
                      );
                    } else {
                      print(snapshot);
                      return SizedBox(
                          child: Text("Neki jebejo expensi kolega"));
                    }
                  });
            } else {
              return SizedBox(
                child: Text("Accounta ni ljega"),
              );
            }
          }),
    );
  }
}
