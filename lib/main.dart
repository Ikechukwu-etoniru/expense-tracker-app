import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/screens/export_expense.dart';
import '/providers/income_provider.dart';
import '/screens/expense_history_screen.dart';
import '/screens/income_history_screen.dart';
import '/providers/tx_provider.dart';
import '/screens/add_expense_screen.dart';
import '/screens/add_income_screen.dart';
import '/screens/dashboard_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (BuildContext context) => TxProvider(),
        ),
        ChangeNotifierProvider(
          create: (BuildContext context) => Incomes(),
        )
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Thrifty Expense',
        theme: ThemeData(
          unselectedWidgetColor: Colors.yellow,
          fontFamily: 'Poppins',
          primarySwatch: Colors.yellow,
        ),
        home: const DashboardScreen(),
        routes: {
          // '/' : (ctx) => const DashboardScreen(),
          AddExpenseScreen.routeName: (ctx) => const AddExpenseScreen(),
          AddIncomeScreen.routeName: (ctx) => const AddIncomeScreen(),
          ExpenseHistoryScreen.routeName: (ctx) =>  const ExpenseHistoryScreen(),
          IncomeHistoryScreen.routeName: (ctx) =>  const IncomeHistoryScreen(),
          ExportExpenseScreen.routeName: (ctx) =>  const ExportExpenseScreen()

        },
      ),
    );
  }
}
