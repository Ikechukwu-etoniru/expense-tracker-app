import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '/models/db_database.dart';
import '/models/transaction.dart';

class TxProvider with ChangeNotifier {
  List<Transaction> _tx = [];

  List<Transaction> get tx {
    return [..._tx];
  }

  List<Transaction> get _tx7 {
    return _tx
        .where((element) => element.date
            .isAfter(DateTime.now().subtract(const Duration(days: 7))))
        .toList();
  }

  List<Transaction> get tx20 {
    if (_tx.length < 20) {
      return _tx;
    }
    return _tx.sublist(0, 19);
  }

  List<Transaction> filterByDate(DateTime date) {
    return _tx.where((element) {
      return element.date.day == date.day &&
          element.date.month == date.month &&
          element.date.year == date.year;
    }).toList();
  }

  List<Transaction> sortByDate(DateTime date) {
    return _tx.where((element) {
      var elementDate = DateTime.parse(element.id);
      return elementDate.isAfter(date);
    }).toList();
  }

  List<Map<String, dynamic>> get expenseChartData {
    return List.generate(7, (index) {
      final id = index + 1;
      final weekDay = DateTime.now().subtract(Duration(days: index));
      var totalSum = 0.0;

      for (var i = 0; i < _tx7.length; i++) {
        if (_tx7[i].date.day == weekDay.day &&
            _tx7[i].date.month == weekDay.month &&
            _tx7[i].date.year == weekDay.year) {
          totalSum += _tx7[i].amount;
        }
      }

      return {
        'day': DateFormat.E().format(weekDay),
        'amount': totalSum,
        'id': id
      };
    }).reversed.toList();
  }

  double get amountInLast7days {
    double totalAmount = 0;
    for (var element in _tx7) {
      totalAmount = totalAmount + element.amount;
    }
    return totalAmount;
  }

  void deleteExpense(String id) async {
    await DbDatabase.instance.deleteExpense(id);
    _tx.removeWhere((element) => element.id == id);
    notifyListeners();
  }

  void addExpense(String title, int amount, String description, DateTime date,
      String cate) async {
    ExpenseType categ() {
      if (cate == 'Food') {
        return ExpenseType.food;
      } else if (cate == 'Business') {
        return ExpenseType.business;
      } else if (cate == 'Education') {
        return ExpenseType.education;
      } else if (cate == 'Luxury') {
        return ExpenseType.luxury;
      } else if (cate == 'Travel') {
        return ExpenseType.travel;
      } else {
        return ExpenseType.miscellaneous;
      }
    }

    var _newTransaction = Transaction(
        id: DateTime.now().toString(),
        title: title,
        amount: amount,
        description: description,
        category: categ(),
        date: date);

    await DbDatabase.instance.insertExpense({
      DbDatabase.exId: _newTransaction.id,
      DbDatabase.exTitle: _newTransaction.title,
      DbDatabase.exAmount: _newTransaction.amount,
      DbDatabase.exDate: _newTransaction.date.toIso8601String(),
      DbDatabase.exDescription: _newTransaction.description,
      DbDatabase.exCategory: cate
    });

    _tx.add(_newTransaction);
    notifyListeners();
  }

  void addCSVExpense(String title, int amount, String description, String date,
      String cate, String id) async {
    ExpenseType categ() {
      if (cate == 'ExpenseType.food') {
        return ExpenseType.food;
      } else if (cate == 'ExpenseType.business') {
        return ExpenseType.business;
      } else if (cate == 'ExpenseType.education') {
        return ExpenseType.education;
      } else if (cate == 'ExpenseType.luxury') {
        return ExpenseType.luxury;
      } else if (cate == 'ExpenseType.travel') {
        return ExpenseType.travel;
      } else {
        return ExpenseType.miscellaneous;
      }
    }

    String category() {
      if (cate == 'ExpenseType.food') {
        return 'Food';
      } else if (cate == 'ExpenseType.business') {
        return 'Business';
      } else if (cate == 'ExpenseType.education') {
        return 'Education';
      } else if (cate == 'ExpenseType.luxury') {
        return 'Luxury';
      } else if (cate == 'ExpenseType.travel') {
        return 'Travel';
      } else {
        return 'Miscellaneous';
      }
    }

    var _newTransaction = Transaction(
        id: id,
        title: title,
        amount: amount,
        description: description,
        category: categ(),
        date: DateTime.parse(date));
    if (_tx.every((element) => element.id != _newTransaction.id)) {
      await DbDatabase.instance.insertExpense({
      DbDatabase.exId: _newTransaction.id,
      DbDatabase.exTitle: _newTransaction.title,
      DbDatabase.exAmount: _newTransaction.amount,
      DbDatabase.exDate: _newTransaction.date.toIso8601String(),
      DbDatabase.exDescription: _newTransaction.description,
      DbDatabase.exCategory: category()
    });

    _tx.insert(0, _newTransaction);
    notifyListeners();
    }

    
  }

  void getExpenses() async {
    final expenseList = await DbDatabase.instance.getExpenses();

    _tx = expenseList
        .map(
          (e) => Transaction(
            id: e[DbDatabase.exId],
            amount: e[DbDatabase.exAmount],
            title: e[DbDatabase.exTitle],
            category: (e[DbDatabase.exCategory] == 'Food')
                ? ExpenseType.food
                : (e[DbDatabase.exCategory] == 'Luxury')
                    ? ExpenseType.luxury
                    : (e[DbDatabase.exCategory] == 'Travel')
                        ? ExpenseType.travel
                        : (e[DbDatabase.exCategory] == 'Business')
                            ? ExpenseType.business
                            : (e[DbDatabase.exCategory] == 'Education')
                                ? ExpenseType.education
                                : ExpenseType.miscellaneous,
            date: DateTime.parse(e[DbDatabase.exDate]),
          ),
        )
        .toList();
    notifyListeners();
  }

  void addFirebaseExpense(String title, int amount, String description,
      String date, String cate, String id) async {
    ExpenseType categ() {
      if (cate == 'ExpenseType.food') {
        return ExpenseType.food;
      } else if (cate == 'ExpenseType.business') {
        return ExpenseType.business;
      } else if (cate == 'ExpenseType.education') {
        return ExpenseType.education;
      } else if (cate == 'ExpenseType.luxury') {
        return ExpenseType.luxury;
      } else if (cate == 'ExpenseType.travel') {
        return ExpenseType.travel;
      } else {
        return ExpenseType.miscellaneous;
      }
    }

    String category() {
      if (cate == 'ExpenseType.food') {
        return 'Food';
      } else if (cate == 'ExpenseType.business') {
        return 'Business';
      } else if (cate == 'ExpenseType.education') {
        return 'Education';
      } else if (cate == 'ExpenseType.luxury') {
        return 'Luxury';
      } else if (cate == 'ExpenseType.travel') {
        return 'Travel';
      } else {
        return 'Miscellaneous';
      }
    }

    var _newTx = Transaction(
        id: id,
        title: title,
        amount: amount,
        description: description,
        category: categ(),
        date: DateTime.parse(date));

    if (_tx.every((element) => element.id != _newTx.id)) {
      _tx.add(_newTx);
      DbDatabase.instance.insertExpense({
        DbDatabase.exId: _newTx.id,
        DbDatabase.exTitle: _newTx.title,
        DbDatabase.exAmount: _newTx.amount,
        DbDatabase.exDate: _newTx.date.toIso8601String(),
        DbDatabase.exDescription: _newTx.description,
        DbDatabase.exCategory: category()
      });
    } else {
      return;
    }
  }
}
