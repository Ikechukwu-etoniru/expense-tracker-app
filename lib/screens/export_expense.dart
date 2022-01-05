import 'dart:io';

import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';

import '/models/transaction.dart';
import '/screens/load_csv_screen.dart';
import '/providers/tx_provider.dart';
import '/widgets/my_drawer.dart';

class ExportExpenseScreen extends StatefulWidget {
  static const routeName = '/export_expense';
  const ExportExpenseScreen({Key? key}) : super(key: key);

  @override
  State<ExportExpenseScreen> createState() => _ExportExpenseScreenState();
}

class _ExportExpenseScreenState extends State<ExportExpenseScreen> {
  Future<bool?> confirmCreateCSVDialog() {
    return showDialog<bool>(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            backgroundColor: const Color(0xff010a42),
            title: const Text(
              'Confirm generating CSV file for all expenses',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                  fontFamily: 'Raleway'),
            ),
            content: Text(
              'Doing this will fetch all expenses stored before ${DateTime.now().hour.toString()}:${DateTime.now().minute.toString()} on ${DateFormat.yMEd().format(DateTime.now())} and create a CSV file',
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

  generateCsv(List<Transaction> data, BuildContext context) async {
    final confirm = await confirmCreateCSVDialog();
    if (confirm == false) {
      return;
    }
    if (data.isEmpty) {
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
                  'You have not saved any expenses !!!!!!!!!! \n Save some expenses, then try again',
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
    List<List<String>> expenseData = data
        .map((e) => [
              e.title,
              e.amount.toString(),
              e.date.toIso8601String(),
              e.id.toString(),
              e.category.toString(),
              e.description
            ])
        .toList();

    String csvData = const ListToCsvConverter().convert(expenseData);
    final String directory = (await getExternalStorageDirectory())!.path;
    final path = "$directory/csv-${DateTime.now()}.csv";
    final File file = File(path);
    await file.writeAsString(csvData);

    var snackBar = SnackBar(
      content: Text(
        'Expense CSV has been generated and can be found in $path',
        textAlign: TextAlign.center,
        softWrap: true,
        style: const TextStyle(
            color: Colors.white,
            fontFamily: 'Raleway',
            fontWeight: FontWeight.bold,
            fontSize: 17),
      ),
      duration: const Duration(seconds: 25),
      backgroundColor: Colors.redAccent,
      elevation: 30,
      action: SnackBarAction(
          label: 'Close',
          onPressed: () {
            ScaffoldMessenger.of(context).removeCurrentSnackBar();
          }),
      dismissDirection: DismissDirection.endToStart,
    );
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  loadCsvFromStorage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowedExtensions: ['csv'],
      type: FileType.custom,
    );
    if (result == null) {
      return;
    }
    String? path = result.files.first.path;
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) {
          return LoadCsvDataScreen(path: path.toString());
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var expenseList = Provider.of<TxProvider>(context).tx;
    return Builder(
      builder: (ctx) => Scaffold(
        backgroundColor: const Color(0xff010a42),
        drawer: const MyDrawer(),
        appBar: AppBar(
          backgroundColor: const Color(0xff010a42),
          elevation: 30,
          iconTheme: const IconThemeData(color: Colors.white),
          centerTitle: true,
          title: const Text(
            'Export/Import Expense',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
          ),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () {
                generateCsv(expenseList, ctx);
              },
              child: const Text('Export All Expenses as CSV'),
            ),
            const SizedBox(
              height: 10,
            ),
            ElevatedButton(
              onPressed: () {
                loadCsvFromStorage();
              },
              child: const Text("Import Expenses From Phone Storage"),
            )
          ],
        ),
      ),
    );
  }
}
