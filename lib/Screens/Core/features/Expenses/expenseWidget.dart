import 'package:flutter/material.dart';

class ExpenseContainer extends StatelessWidget {
  ExpenseContainer({this.name, this.amount, this.category});
  final String name;
  final double amount;
  final String category;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Row(
        children: <Widget>[
          Container(
              width: MediaQuery.of(context).size.height / 2,
              height: 85,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
              ),
              child: Column(
                children: <Widget>[
                  Container(
                     
                      alignment: Alignment.centerLeft,
                      padding: new EdgeInsets.fromLTRB(20,5,0,0),
                      child: Text('$name',
                          style: TextStyle(fontSize: 18),
                          textAlign: TextAlign.left)),
                  Container(
                  
                    alignment: Alignment.centerRight,
                    padding: new EdgeInsets.fromLTRB(0,0,15,0),
                    child: Text('$amount €',
                        style: TextStyle(fontSize: 30),
                        textAlign: TextAlign.right),
                  ),
                  Container(
                    alignment: Alignment.center,
                    child: Text('$category',
                        style: TextStyle(fontSize: 16),
                        textAlign: TextAlign.left),
                  ),
                ],
              ))
        ],
      ),
    );
  }
}
