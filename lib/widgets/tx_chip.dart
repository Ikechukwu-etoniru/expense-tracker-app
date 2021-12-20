import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '/models/transaction.dart';

class TxChip extends StatelessWidget {
  final ExpenseType category;
  final DateTime date;

  const TxChip(this.category, this.date, {Key? key}) : super(key: key);
  Color get color {
    if (category == ExpenseType.business) {
      return Colors.blue;
    } else if (category == ExpenseType.education) {
      return Colors.yellow;
    } else if (category == ExpenseType.food) {
      return Colors.green;
    } else if (category == ExpenseType.luxury) {
      return Colors.indigo;
    } else if (category == ExpenseType.miscellaneous) {
      return Colors.brown;
    } else if (category == ExpenseType.travel) {
      return Colors.red;
    } else {
      return Colors.yellow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 3),
      height: 20,
      width: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(40),
        color: color,
      ),
      child: Row(
        children: [
          Container(
            margin: const EdgeInsets.all(1),
            padding: const EdgeInsets.all(2),
            child: const CircleAvatar(
              backgroundColor: Colors.white,
              child: FittedBox(child: Icon(Icons.arrow_forward)),
            ),
          ),
          FittedBox(
            fit: BoxFit.fill,
            child: Text(
              DateFormat.yMMMEd().format(date),
              style: const TextStyle(
                color: Colors.black54
              ),
            ),
          )
        ],
      ),
    );
  }
}
