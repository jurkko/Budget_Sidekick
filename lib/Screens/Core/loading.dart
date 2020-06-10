import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Container(
      child: SingleChildScrollView(
        physics: NeverScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Stack(
              children: <Widget>[
                Container(
                  width: double.infinity,
                  height: height * 0.28, //300,
                  color: Colors.blue,
                ),
              ],
            ),
            Stack(
              children: <Widget>[
                Container(
                  width: double.infinity,
                  height: height * 0.78, //300,
                  color: Colors.white,
                  child: SpinKitRing(
                    color: Colors.blue,
                    size: 100.0,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
