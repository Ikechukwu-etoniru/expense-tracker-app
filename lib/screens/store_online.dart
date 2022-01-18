import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '/providers/notification_provider.dart';
import '/screens/dashboard_screen.dart';
import '/models/csv_data_model.dart';
import '/models/db_database.dart';
import '/providers/firebase_provider.dart';
import '/providers/tx_provider.dart';
import '/widgets/my_drawer.dart';

class StoreOnlineScreen extends StatefulWidget {
  static const routename = '/store_online_screen';
  const StoreOnlineScreen({Key? key}) : super(key: key);

  @override
  State<StoreOnlineScreen> createState() => _StoreOnlineScreenState();
}

class _StoreOnlineScreenState extends State<StoreOnlineScreen> {
  DateTime? lastDate;
  var isLoading = false;

  Future<void> _getLastDate() async {
    final dateData = await DbDatabase.instance.getDate();
    if (dateData.isEmpty) {
      return lastDate = null;
    }
    setState(() {
      lastDate = DateTime.parse(dateData[0][DbDatabase.date]);
    });
  }

  Future<bool?> confirmDialog(DateTime? lastDate) {
    return showDialog<bool>(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            backgroundColor: const Color(0xff010a42),
            title: const Text(
              'Confirm sending expenses online',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 22,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                  fontFamily: 'Raleway'),
            ),
            content: Text(
              lastDate != null
                  ? 'Doing this will:\n1. Require an internet connection.\n2. Save all expenses added after ${lastDate.hour.toString()}:${lastDate.minute.toString()} on ${DateFormat.yMEd().format(lastDate)}  to your online database'
                  : 'Doing this will:\n1. Require an internet connection.\n2. Save all expenses added to your online database',
              textAlign: TextAlign.left,
              style: const TextStyle(
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
                child: const Text('Confirm'),
              )
            ],
          );
        });
  }

  Future<bool?> confirmFetchExpenseDialog(DateTime? lastDate) {
    return showDialog<bool>(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            backgroundColor: const Color(0xff010a42),
            title: const Text(
              'Confirm fetching expenses from online database',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                  fontFamily: 'Raleway'),
            ),
            content: Text(
              'Doing this will:\n1. Require an internet connection.\n2. Fetch all expenses stored before ${lastDate!.hour.toString()}:${lastDate.minute.toString()} on ${DateFormat.yMEd().format(lastDate)} to your online database',
              textAlign: TextAlign.left,
              style: const TextStyle(
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
                child: const Text('Confirm'),
              )
            ],
          );
        });
  }

  @override
  void initState() {
    super.initState();
    _getLastDate();
    Provider.of<NotificationService>(context, listen: false).initialize();
  }

  Future<bool> _checkInternetConnection() async {
    late bool connectStatus;
    try {
      final response = await InternetAddress.lookup('www.kindacode.com');
      if (response.isNotEmpty) {
        connectStatus = true;
      }
    // ignore: unused_catch_clause
    } on SocketException catch (err) {
      connectStatus = false;
    }
    return connectStatus;
  }

  void _sendExFirstTime() async {
    var confirmStatus = await confirmDialog(lastDate);
    if (confirmStatus == false) {
      return;
    }

    var internetStatus = await _checkInternetConnection();
    if (internetStatus == false) {
      return showDialog(
          context: context,
          builder: (_) {
            return AlertDialog(
                backgroundColor: const Color(0xff010a42),
                title: const Text(
                  'Network Error',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 22,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
                      fontFamily: 'Raleway'),
                ),
                content: const Text(
                  'Check your network connection, then try again',
                  textAlign: TextAlign.left,
                  softWrap: true,
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
                      'close',
                      style: TextStyle(color: Colors.red),
                    ),
                  )
                ]);
          });
    }
    final expenseList = Provider.of<TxProvider>(context, listen: false).tx;
    if (expenseList.isEmpty) {
      return showDialog(
          context: context,
          builder: (_) {
            return AlertDialog(
                backgroundColor: const Color(0xff010a42),
                title: const Text(
                  'Something went wrong',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 22,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
                      fontFamily: 'Raleway'),
                ),
                content: const Text(
                  'You have not added any expense yet !!!!!!!!!',
                  textAlign: TextAlign.left,
                  softWrap: true,
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
                      'close',
                      style: TextStyle(color: Colors.red),
                    ),
                  )
                ]);
          });
    }
    setState(() {
      isLoading = true;
    });

    final date = await Provider.of<FirebaseProvider>(context, listen: false)
        .addExpense(expenseList);

    setState(() {
      lastDate = date;
    });

    await Provider.of<NotificationService>(context, listen: false)
        .stylishNotification('Good Job',
            'You have stored your first set of expensess on our online database');

    await DbDatabase.instance.insertDate({
      DbDatabase.dateId: 'one',
      DbDatabase.date: lastDate!.toIso8601String()
    });

    setState(() {
      isLoading = false;
    });
  }

  void _sendExNotFirstTime() async {
    var confirmStatus = await confirmDialog(lastDate);
    if (confirmStatus == false) {
      return;
    }
    var internetStatus = await _checkInternetConnection();
    if (internetStatus == false) {
      return showDialog(
          context: context,
          builder: (_) {
            return AlertDialog(
                backgroundColor: const Color(0xff010a42),
                title: const Text(
                  'Network Error',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 22,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
                      fontFamily: 'Raleway'),
                ),
                content: const Text(
                  'Check your network connection, then try again',
                  textAlign: TextAlign.left,
                  softWrap: true,
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
                      'Close',
                      style: TextStyle(color: Colors.red),
                    ),
                  )
                ]);
          });
    }

    final expenseList =
        Provider.of<TxProvider>(context, listen: false).sortByDate(lastDate!);
    if (expenseList.isEmpty) {
      return showDialog(
          context: context,
          builder: (_) {
            return AlertDialog(
                backgroundColor: const Color(0xff010a42),
                title: const Text(
                  'Something went wrong',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 22,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
                      fontFamily: 'Raleway'),
                ),
                content: Text(
                  'You have not added any expense since  ${lastDate!.hour.toString()}:${lastDate!.minute.toString()} on ${DateFormat.yMEd().format(lastDate!)}!!!!!!!!!',
                  textAlign: TextAlign.left,
                  softWrap: true,
                  style: const TextStyle(
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
                      'close',
                      style: TextStyle(color: Colors.red),
                    ),
                  )
                ]);
          });
    }
    setState(() {
      isLoading = true;
    });
    final date = await Provider.of<FirebaseProvider>(context, listen: false)
        .addExpense(expenseList);

    setState(() {
      lastDate = date;
      isLoading = false;
    });
    await Provider.of<NotificationService>(context, listen: false)
        .stylishNotification('Good Job',
            'You have sent some transactions to our online database');

    await DbDatabase.instance.updateDate({
      DbDatabase.dateId: 'one',
      DbDatabase.date: lastDate!.toIso8601String()
    });
  }

  _fetchFirebaseExpenses() async {
    var confirmStatus = await confirmFetchExpenseDialog(lastDate);
    if (confirmStatus == false) {
      return;
    }
    var internetStatus = await _checkInternetConnection();
    if (internetStatus == false) {
      return showDialog(
          context: context,
          builder: (_) {
            return AlertDialog(
                backgroundColor: const Color(0xff010a42),
                title: const Text(
                  'Network Error',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 22,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
                      fontFamily: 'Raleway'),
                ),
                content: const Text(
                  'Check your network connection, then try again',
                  textAlign: TextAlign.left,
                  softWrap: true,
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
                      'Close',
                      style: TextStyle(color: Colors.red),
                    ),
                  )
                ]);
          });
    }
    setState(() {
      isLoading = true;
    });
    final data = await Provider.of<FirebaseProvider>(context, listen: false)
        .getExpense();
    for (var element in data.docs) {
      final expenseData = element.data();
      final newExpense = CsvExpData(
          amount: expenseData['amount'],
          title: expenseData['title'],
          description: expenseData['description'],
          cate: expenseData['category'],
          date: expenseData['date'],
          id: expenseData['id']);
      Provider.of<TxProvider>(context, listen: false).addFirebaseExpense(
          newExpense.title,
          newExpense.amount,
          newExpense.description,
          newExpense.date,
          newExpense.cate,
          newExpense.id);
    }
    setState(() {
      isLoading = false;
    });
    Provider.of<NotificationService>(context, listen: false)
        .stylishNotification(
            'Kudos', 'You have retrived your transactions from our database');
    Navigator.of(context).pushReplacementNamed(DashboardScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (ctx) {
      return Scaffold(
        drawer: const MyDrawer(),
        backgroundColor: const Color(0xff010a42),
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.white),
          centerTitle: true,
          elevation: 0,
          title: const Text(
            'Manage Expense Online',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
          ),
          backgroundColor: const Color(0xff010a42),
        ),
        body: isLoading
            ? const Center(child: CircularProgressIndicator())
            : Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                    onPressed: lastDate == null
                        ? () {
                            _sendExFirstTime();
                          }
                        : () {
                            _sendExNotFirstTime();
                          },
                    child: const Text('Store Expenses Online'),
                  ),
                  if (lastDate != null)
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 5),
                      padding: const EdgeInsets.symmetric(
                          vertical: 5, horizontal: 5),
                      height: 70,
                      decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(15)),
                      child: Text(
                        'You last stored your expenses online at ${lastDate!.hour.toString()}:${lastDate!.minute.toString()} on ${DateFormat.yMEd().format(lastDate!)}',
                        softWrap: true,
                        style: const TextStyle(color: Colors.white),
                      ),
                      alignment: Alignment.center,
                    ),
                  ElevatedButton(
                    onPressed: lastDate == null
                        ? () {
                            showDialog(
                                context: context,
                                builder: (_) {
                                  return AlertDialog(
                                      backgroundColor: const Color(0xff010a42),
                                      title: const Text(
                                        'Something went wrong',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: 22,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            letterSpacing: 1.5,
                                            fontFamily: 'Raleway'),
                                      ),
                                      content: const Text(
                                        'You have not added any expense online!!!!!!!!!',
                                        textAlign: TextAlign.left,
                                        softWrap: true,
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
                                          borderRadius:
                                              BorderRadius.circular(15)),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: const Text(
                                            'close',
                                            style: TextStyle(color: Colors.red),
                                          ),
                                        )
                                      ]);
                                });
                          }
                        : () {
                            _fetchFirebaseExpenses();
                          },
                    child: const Text("Import Expenses From Online Database"),
                  )
                ],
              ),
      );
    });
  }
}
