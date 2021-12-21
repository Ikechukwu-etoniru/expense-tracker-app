import 'dart:convert';
import 'dart:io';

import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/models/csv_data_model.dart';
import '/providers/tx_provider.dart';

class LoadCsvDataScreen extends StatelessWidget {
  final String path;

  const LoadCsvDataScreen({Key? key, required this.path}) : super(key: key);

  void saveCsvData(
      AsyncSnapshot<List<dynamic>> snapshot, BuildContext context) {
    List<CsvExpData> csvExpList = snapshot.data!
        .map((data) => CsvExpData(
            description: data[5],
            title: data[0],
            amount: data[1],
            cate: data[4],
            date: data[2],
            id: data[3]))
        .toList();

    for (var element in csvExpList) {
      Provider.of<TxProvider>(context, listen: false).addCSVExpense(
          element.title,
          element.amount,
          element.description,
          element.date,
          element.cate,
          element.id);
    }
  }

  Widget text(String data, String data2) {
    return Text(
      '$data : $data2',
      style: const TextStyle(
        color: Colors.white,
        fontSize: 17,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff010a42),
      appBar: AppBar(
        title: const Text(
          "CSV DATA",
          style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xff010a42),
      ),
      body: FutureBuilder(
        future: loadingCsvData(path),
        builder: (ctx, AsyncSnapshot<List<dynamic>> snapshot) {
          return snapshot.hasData
              ? Column(
                  children: [
                    Expanded(
                      child: ListView(
                        children: snapshot.data!
                            .map((data) => Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(
                                        color: Colors.black,
                                        width: 2,
                                      )),
                                  padding: const EdgeInsets.all(10),
                                  margin: const EdgeInsets.all(10),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      text('Title', data[0]),
                                      text('Amount', data[1].toString()),
                                      text('Date', data[2]),
                                      text('Expense ID', data[3]),
                                      text('Expense Category', data[4]),
                                      text('Description', data[5]),
                                    ],
                                  ),
                                ))
                            .toList(),
                      ),
                    ),
                    Center(
                      child: ElevatedButton(
                          onPressed: () {
                            saveCsvData(snapshot, context);
                            Navigator.of(context).pop();
                            ScaffoldMessenger.of(ctx).hideCurrentSnackBar();
                            var snackBar1 = const SnackBar(
                              content: Text(
                                'CVS data imported successfully',
                                softWrap: true,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'Raleway',
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              backgroundColor: Colors.redAccent,
                            );
                            ScaffoldMessenger.of(ctx).showSnackBar(snackBar1);
                          },
                          child: const Text('Add CSV data to your expenses')),
                    )
                  ],
                )
              : const Center(
                  child: CircularProgressIndicator(),
                );
        },
      ),
    );
  }

  Future<List<List<dynamic>>> loadingCsvData(String path) async {
    final csvFile = File(path).openRead();
    return await csvFile
        .transform(utf8.decoder)
        .transform(
          const CsvToListConverter(),
        )
        .toList();
  }
}
