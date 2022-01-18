import 'package:flutter/material.dart';

import '/models/db_database.dart';
import '/models/income.dart';

class Incomes with ChangeNotifier {
  List<Income> _incomeList = [
    // Income(
    //     amount: 20000,
    //     category: IncomeType.salary,
    //     date: DateTime.now(),
    //     id: DateTime.now().toString()),
    // Income(
    //     amount: 200000,
    //     category: IncomeType.business,
    //     date: DateTime.now(),
    //     id: DateTime.now().toString()),
    // Income(
    //     amount: 200000000,
    //     category: IncomeType.gift,
    //     date: DateTime.now(),
    //     id: DateTime.now().toString())
  ];

  List<Income> get incomeList {
    return [..._incomeList];
  }

  List<Income> filterByDate(DateTime date) {
    return _incomeList.where((element) {
      return element.date.day == date.day &&
          element.date.month == date.month &&
          element.date.year == date.year;
    }).toList();
  }

  List<Income> get income20 {
    if (_incomeList.length < 20) {
      return _incomeList;
    }
    return _incomeList.sublist(0, 19);
  }

  void addIncome(int amount, DateTime date, String cate) async {
    IncomeType categ() {
      if (cate == 'Salary') {
        return IncomeType.salary;
      } else if (cate == 'Gift') {
        return IncomeType.gift;
      } else {
        return IncomeType.business;
      }
    }

    var newIncome = Income(
        id: DateTime.now().toString(),
        amount: amount,
        category: categ(),
        date: date);

    await DbDatabase.instance.insertIncome({
      DbDatabase.inId: newIncome.id,
      DbDatabase.inDate: newIncome.date.toIso8601String(),
      DbDatabase.inAmount: newIncome.amount,
      DbDatabase.inCategory: cate
    });

    _incomeList.add(newIncome);
    notifyListeners();
  }

  void deleteIncome(String id) async {
    await DbDatabase.instance.deleteIncome(id);
    _incomeList.removeWhere((element) => element.id == id);
    notifyListeners();
  }

  void getIncome() async {
    final incomeList = await DbDatabase.instance.getIncome();

    _incomeList = incomeList
        .map(
          (e) => Income(
            id: e[DbDatabase.inId],
            amount: e[DbDatabase.inAmount],
            category: (e[DbDatabase.inCategory] == 'Salary')
                ? IncomeType.salary
                : (e[DbDatabase.exCategory] == 'Gift')
                    ? IncomeType.gift
                    : (e[DbDatabase.exCategory] == 'Business')
                        ? IncomeType.business
                        : IncomeType.business,
            date: DateTime.parse(e[DbDatabase.inDate]),
          ),
        )
        .toList();
    notifyListeners();
  }
}
