import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/providers/login_screen_provider.dart';
import '/screens/store_online.dart';
import '/screens/export_expense.dart';
import '/screens/expense_history_screen.dart';
import '/screens/income_history_screen.dart';
import '/widgets/line_design.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({Key? key}) : super(key: key);

  Future<bool?> _confirmLogoutDialog(BuildContext context) {
    return showDialog<bool>(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            backgroundColor: const Color(0xff010a42),
            title: const Text(
              'Confirm Logout',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                  fontFamily: 'Raleway'),
            ),
            content: const Text(
              'Doing this will require an internet connection.',
              textAlign: TextAlign.left,
              style: TextStyle(
                  height: 1.5,
                  fontSize: 15,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                  fontFamily: 'Raleway'),
            ),
            elevation: 30,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
                child: const Text(
                  'Cancel',
                  style: TextStyle(color: Colors.red),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
                child: const Text('Proceed'),
              )
            ],
          );
        });
  }

  Future<bool> _checkInternetConnection() async {
    late bool connectStatus;
    try {
      final response = await InternetAddress.lookup('www.kindacode.com');
      if (response.isNotEmpty) {
        connectStatus = true;
      }
    } on SocketException catch (err) {
      connectStatus = false;
    }
    return connectStatus;
  }

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
                'Export/Import Expense in CSV Format',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
              leading: const Icon(
                Icons.import_export,
                color: Colors.white,
              ),
              onTap: () {
                Navigator.of(context)
                    .pushReplacementNamed(ExportExpenseScreen.routeName);
              },
            ),
            const Divider(
              color: Colors.white,
            ),
            ListTile(
                title: const Text(
                  'Export/Import Expenses to Online Database',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
                leading:
                    const Icon(Icons.online_prediction, color: Colors.white),
                onTap: () {
                  Navigator.of(context)
                      .pushReplacementNamed(StoreOnlineScreen.routename);
                }),
            const Divider(
              color: Colors.white,
            ),
            ListTile(
                title: const Text(
                  'Logout',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
                leading: const Icon(Icons.logout, color: Colors.white),
                onTap: () async {
                  final _confirmLogout = await _confirmLogoutDialog(context);
                  if (_confirmLogout == false) {
                    return;
                  }
                  final _internetConnection = await _checkInternetConnection();
                  if (_internetConnection) {
                    Navigator.of(context).pop();
                    Provider.of<GoogleSigninProvider>(context, listen: false)
                        .googleLogout();
                  } else {
                    showDialog<void>(
                        context: context,
                        builder: (_) {
                          return AlertDialog(
                              backgroundColor: const Color(0xff010a42),
                              title: const Text(
                                'An error occured',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1.2,
                                    fontFamily: 'Raleway'),
                              ),
                              content: const Text(
                                'Cheeck your internet connection.',
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    height: 1.5,
                                    fontSize: 15,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1.5,
                                    fontFamily: 'Raleway'),
                              ),
                              elevation: 30,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15)),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text(
                                    'Cancel',
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ),
                              ]);
                        });
                  }
                }),
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
