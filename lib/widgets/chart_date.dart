import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ChartDate extends StatelessWidget {
  final double myWidth;
 const ChartDate(this.myWidth,{Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(7, (index) {
        final weekDay = DateTime.now().subtract(Duration(days: index));
        return SizedBox(
          width: myWidth / 7,
          child: Center(
            child: Text(
              DateFormat.E().format(weekDay),
              style: const TextStyle(color: Colors.white, fontSize: 15),
            ),
          ),
        );
      }).reversed.toList(),
    );
  }
}
