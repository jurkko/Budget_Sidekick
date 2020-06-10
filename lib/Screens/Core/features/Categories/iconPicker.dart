import 'package:flutter/material.dart';

class IconPicker extends StatelessWidget {
  static List<IconData> icons = [
    Icons.edit,
    Icons.access_time,
    Icons.build,
    Icons.attach_money,
    Icons.brush,
    Icons.business_center,
    Icons.cake,
    Icons.call,
    Icons.computer,
    Icons.email,
    Icons.local_dining,
    Icons.favorite,
    Icons.info,
    Icons.local_airport,
    Icons.local_cafe,
    Icons.local_bar,
    Icons.local_gas_station,
    Icons.local_grocery_store,
    Icons.local_shipping,
    Icons.phone_android,

    // all the icons you want to include
  ];

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Wrap(
        spacing: 20,
        alignment: WrapAlignment.center,
        children: icons.map((icon) {
          return GestureDetector(
              onTap: () => Navigator.pop(context, icon),
              child: Padding(
                padding: const EdgeInsets.all(2.0),
                child: Icon(
                  icon,
                  size: width * 0.1,
                  color: Colors.white,
                ),
              ));
        }).toList());
  }
}
