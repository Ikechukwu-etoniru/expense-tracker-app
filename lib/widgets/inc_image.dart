import 'package:flutter/material.dart';

import '/models/income.dart';



class IncImage extends StatelessWidget {
  final IncomeType category;

  const IncImage(this.category, {Key? key}) : super(key: key);

  String get cate {
    var finalCate = '';
    if (category == IncomeType.business) {
      finalCate = 'images/Business.png';
    } else if (category == IncomeType.gift) {
      finalCate = 'images/gift.png';
    } else if (category == IncomeType.salary) {
      finalCate = 'images/salary.png';
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