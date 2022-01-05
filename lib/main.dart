import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:thrifty_expense/providers/notification_provider.dart';
import 'package:thrifty_expense/screens/dashboard_screen.dart';

import '/providers/firebase_provider.dart';
import '/screens/home_page.dart';
import '/screens/store_online.dart';
import '/providers/login_screen_provider.dart';
import '/screens/export_expense.dart';
import '/providers/income_provider.dart';
import '/screens/expense_history_screen.dart';
import '/screens/income_history_screen.dart';
import '/providers/tx_provider.dart';
import '/screens/add_expense_screen.dart';
import '/screens/add_income_screen.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
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
        ),
        ChangeNotifierProvider(
          create: (BuildContext context) => GoogleSigninProvider(),
        ),
        ChangeNotifierProvider(
          create: (BuildContext context) => FirebaseProvider(),
        ),
        ChangeNotifierProvider(
          create: (BuildContext context) => NotificationService(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Thrifty Expense',
        theme: ThemeData(
          unselectedWidgetColor: Colors.yellow,
          fontFamily: 'Poppins',
          primarySwatch: Colors.yellow,
        ),
        home: const HomePage(),
        routes: {
          DashboardScreen.routeName : (ctx) => const DashboardScreen(),
          AddExpenseScreen.routeName: (ctx) => const AddExpenseScreen(),
          AddIncomeScreen.routeName: (ctx) => const AddIncomeScreen(),
          ExpenseHistoryScreen.routeName: (ctx) => const ExpenseHistoryScreen(),
          IncomeHistoryScreen.routeName: (ctx) => const IncomeHistoryScreen(),
          ExportExpenseScreen.routeName: (ctx) => const ExportExpenseScreen(),
          StoreOnlineScreen.routename: (ctx) => const StoreOnlineScreen()
        },
      ),
    );
  }
}
