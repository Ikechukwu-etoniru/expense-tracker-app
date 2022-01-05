import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '/models/transaction.dart' as tx;

class FirebaseProvider with ChangeNotifier {
  final user = FirebaseAuth.instance.currentUser;

  Future<DateTime> addExpense(List<tx.Transaction> expenses) async {
    for (var element in expenses) {
      await FirebaseFirestore.instance
          .collection('user')
          .doc(user!.uid)
          .collection('expense')
          .doc(element.id)
          .set({
        'id': element.id,
        'title': element.title,
        'date': element.date.toIso8601String(),
        'amount': element.amount,
        'description': element.description,
        'category': element.category.toString()
      });
    }

    notifyListeners();

    return DateTime.now();
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getExpense() async {
    final data = await FirebaseFirestore.instance
        .collection('user')
        .doc(user!.uid)
        .collection('expense')
        .get();

    notifyListeners();
    return data;
  }
}
