import 'package:budget_sidekick/Models/event.dart';
import 'package:flutter/material.dart';

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
            height: height * 0.08,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Padding(
                          padding: EdgeInsets.all(width * 0.03),
                          child: (event.current/event.target) == 1
                              ? Icon(
                                  Icons.arrow_upward,
                                  color: Colors.green,
                                  size: width * 0.06,
                                )
                              : Icon(Icons.arrow_downward,
                                  color: Colors.blue, size: width * 0.06)),
                    ),
                    Padding(
                        padding: EdgeInsets.only(left: width * 0.03),
                        child: Container(
                          width: width * 0.4,
                          child: Text(
                            event.name,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              color: (event.current/event.target) == 1
                                  ? Colors.green[700]
                                  : Colors.blue[700],
                              fontWeight: FontWeight.bold,
                              fontSize: width * 0.044,
                            ),
                          ),
                        )),
                  ],
                ),
                Text(
                  event.current.toString(),
                  style: TextStyle(
                    color: (event.current/event.target) == 1
                        ? Colors.green[700]
                        : Colors.blue[700],
                    fontWeight: FontWeight.bold,
                    fontSize: width * 0.044,
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
