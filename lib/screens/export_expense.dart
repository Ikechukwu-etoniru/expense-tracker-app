import 'dart:io';

import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:thrifty_expense/models/transaction.dart';
import 'package:thrifty_expense/screens/load_csv_screen.dart';

import '/providers/tx_provider.dart';
import '/widgets/my_drawer.dart';

class ExportExpenseScreen extends StatefulWidget {
  static const routeName = '/export_expense';
  const ExportExpenseScreen({Key? key}) : super(key: key);

  @override
  State<ExportExpenseScreen> createState() => _ExportExpenseScreenState();
}

class _ExportExpenseScreenState extends State<ExportExpenseScreen> {
  generateCsv(List<Transaction> data, BuildContext context) async {
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
    String? path = result!.files.first.path;
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) {
          return LoadCsvDataScreen(path: path.toString());
        },
      ),
    );
  }

  void showSnackbar(BuildContext context) {}

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
                  'Export Expense',
                  style:
                      TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
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
            ));
  }
}
