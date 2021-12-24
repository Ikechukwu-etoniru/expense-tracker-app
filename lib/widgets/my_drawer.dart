import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thrifty_expense/providers/login_screen_provider.dart';

import '/screens/export_expense.dart';
import '/screens/expense_history_screen.dart';
import '/screens/income_history_screen.dart';
import '/widgets/line_design.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        width: double.infinity,
        height: double.infinity,
        color: const Color(0xff010a42),
        child: Column(
          children: [
            const SizedBox(
                width: double.infinity, height: 150, child: LineDesign()),
            const SizedBox(height: 10),
            ListTile(
              title: const Text(
                'Dashboard',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
              leading: const Icon(Icons.dashboard, color: Colors.white),
              onTap: () {
                Navigator.of(context).pushReplacementNamed('/');
              },
            ),
            const Divider(
              color: Colors.white,
              height: 2,
            ),
            ListTile(
              title: const Text(
                'Expense History',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
              leading: const Icon(Icons.history, color: Colors.white),
              onTap: () {
                Navigator.of(context)
                    .pushReplacementNamed(ExpenseHistoryScreen.routeName);
              },
            ),
            const Divider(
              color: Colors.white,
              height: 2,
            ),
            ListTile(
              title: const Text(
                'Income History',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
              leading:
                  const Icon(Icons.history_edu_rounded, color: Colors.white),
              onTap: () {
                Navigator.of(context)
                    .pushReplacementNamed(IncomeHistoryScreen.routeName);
              },
            ),
            const Divider(
              color: Colors.white,
            ),
            ListTile(
              title: const Text(
                'Export/Import Expense in CSV',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
              leading: const Icon(Icons.import_export, color: Colors.white,),
              onTap:  () {
                Navigator.of(context)
                    .pushReplacementNamed(ExportExpenseScreen.routeName);
              },
            ),
            const Divider(
              color: Colors.white,
            ),
             ListTile(
              title: const Text(
                'Logout',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
              leading: const Icon(Icons.logout, color: Colors.white),
              onTap: () {
                Provider.of<GoogleSigninProvider>(context, listen: false).googleLogout();
              }
            ),
            const Divider(
              color: Colors.white,
              height: 2,
            ),

          ],
        ),
      ),
    );
  }
}
