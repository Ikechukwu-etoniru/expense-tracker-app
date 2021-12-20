import 'package:flutter/material.dart';

import '/models/transaction.dart';

class TxImage extends StatelessWidget {
  final ExpenseType category;

  const TxImage(this.category, {Key? key}) : super(key: key);

  String get cate {
    var finalCate = '';
    if (category == ExpenseType.business) {
      finalCate = 'images/Business.png';
    } else if (category == ExpenseType.food) {
      finalCate = 'images/Food.png';
    } else if (category == ExpenseType.education) {
      finalCate = 'images/education.png';
    } else if (category == ExpenseType.luxury) {
      finalCate = 'images/Luxury.png';
    } else if (category == ExpenseType.travel) {
      finalCate = 'images/Travel.png';
    } else if (category == ExpenseType.miscellaneous) {
      finalCate = 'images/miscellaneous.png';
    }
    return finalCate;
  }

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      cate,
      fit: BoxFit.contain,
      alignment: Alignment.center,
    );
  }
}
