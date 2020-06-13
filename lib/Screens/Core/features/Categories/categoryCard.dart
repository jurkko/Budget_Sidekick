import 'package:flutter/material.dart';
import 'package:budget_sidekick/Models/category.dart';
import 'package:intl/intl.dart';

class CategoryCard extends StatelessWidget {
  final Category category;

  const CategoryCard({Key key, this.category}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    return Column(
      children: <Widget>[
        Container(
          //padding: EdgeInsets.all(width * 0.005),
          width: width,
          height: height * 0.074,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Padding(
                      padding: EdgeInsets.only(left: width * 0.05),
                      child: Container(
                          child: Icon(
                        IconData(category.iconCode,
                            fontFamily: 'MaterialIcons'),
                        color: Colors.grey[600],
                        size: width * 0.07,
                      ))),
                  Padding(
                      padding: EdgeInsets.only(left: width * 0.05),
                      child: Container(
                        child: Text(
                          category.name,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            color: Colors.grey[600],
                            //fontWeight: FontWeight.bold,
                            fontSize: width * 0.05,
                          ),
                        ),
                      )),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
