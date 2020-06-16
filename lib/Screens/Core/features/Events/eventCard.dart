import 'package:budget_sidekick/Models/event.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EventCard extends StatelessWidget {
  final Event event;

  const EventCard({Key key, this.event}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    
    return Column(
      children: <Widget>[
        GestureDetector(
          onTap: () {
            //Edit
          },
          child: Container(
            //padding: EdgeInsets.all(width * 0.005),
            width: width,
            height: height * 0.08321,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Padding(
                        padding: EdgeInsets.only(left: width * 0.04),
                        child: Container(
                            child: Icon(
                          IconData(event.iconCode,
                              fontFamily: 'MaterialIcons'),
                          color: Colors.grey[600],
                          size: width * 0.054,
                        ))),
                    Padding(
                        padding: EdgeInsets.only(left: width * 0.01),
                        child: Container(
                          child: Text(
                            DateFormat('dd.MM.yyy')
                                .format(event.dueDate),
                            //overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontWeight: FontWeight.bold,
                              fontSize: width * 0.035,
                            ),
                          ),
                        )),
                    Padding(
                        padding: EdgeInsets.only(left: width * 0.02),
                        child: Container(
                          child: Text(
                            event.name,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              color: Colors.grey[600],
                              //fontWeight: FontWeight.bold,
                              fontSize: width * 0.044,
                            ),
                          ),
                        )),
                  ],
                ),               
                Padding(
                  padding: EdgeInsets.only(right: width * 0.05),
                  child: Text(
                    (event.profit ? "+" : "-") +
                        event.target.toString() +
                        "€",
                    style: TextStyle(
                      color: event.profit == true
                          ? Colors.green[700]
                          : Colors.red[700],
                      fontWeight: FontWeight.bold,
                      fontSize: width * 0.044,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
