import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '/models/income.dart';
import '/providers/income_provider.dart';
import '/widgets/inc_image.dart';
import '/widgets/my_drawer.dart';

class IncomeHistoryScreen extends StatefulWidget {
  static const routeName = '/income_history_screen';
  const IncomeHistoryScreen({Key? key}) : super(key: key);

  @override
  State<IncomeHistoryScreen> createState() => _IncomeHistoryScreenState();
}

class _IncomeHistoryScreenState extends State<IncomeHistoryScreen> {
  final appBarr = AppBar(
    iconTheme: const IconThemeData(color: Colors.white),
    backgroundColor: const Color(0xff010a42),
    elevation: 40,
    title: const Text(
      'All Income',
      style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
    ),
  );
  DateTime? selectedDate;
  void _pickDate() {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2020),
            lastDate: DateTime.now())
        .then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      setState(() {
        selectedDate = pickedDate;
      });
    });
  }

  bool expand = false;

  @override
  Widget build(BuildContext context) {
    final income = Provider.of<Incomes>(context);
    final incomeList = selectedDate == null
        ? income.incomeList
        : income.filterByDate(selectedDate!);
    final deviceHeight = (MediaQuery.of(context).size.height -
        appBarr.preferredSize.height -
        MediaQuery.of(context).padding.top);
    return Scaffold(
      backgroundColor: const Color(0xff010a42),
      drawer: const MyDrawer(),
      appBar: appBarr,
      body: Column(
        children: incomeList.isEmpty && selectedDate == null
            ? [
                const SizedBox(
                  height: 30,
                ),
                const Center(
                  child: Text(
                    'You haven\'t added any income',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 20,
                        fontFamily: 'Raleway',
                        fontWeight: FontWeight.bold,
                        color: Colors.white60),
                  ),
                )
              ]
            : [
                Expanded(
                  child: selectedDate != null && incomeList.isEmpty
                      ? const Center(
                          child: Text(
                            'NO INCOME WAS ADDED ON THIS DAY',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'Raleway',
                                fontWeight: FontWeight.bold,
                                wordSpacing: 3,
                                fontSize: 25),
                          ),
                        )
                      : ListView.builder(
                          itemCount: incomeList.length,
                          itemBuilder: (context, i) {
                            return IncomeListView(incomeList[i], deviceHeight);
                          }),
                ),
                AnimatedContainer(
                    height: expand ? 200 : 50,
                    duration: const Duration(milliseconds: 300),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              TextButton(
                                onPressed: () {
                                  setState(() {
                                    expand = !expand;
                                  });
                                },
                                child: const Text(
                                  'Sort List',
                                  style: TextStyle(fontSize: 17),
                                ),
                              ),
                              Icon(
                                !expand
                                    ? Icons.arrow_upward
                                    : Icons.arrow_downward,
                                color: Colors.yellow,
                                size: 15,
                              )
                            ],
                          ),
                          if (expand)
                            Container(
                              margin: const EdgeInsets.symmetric(horizontal: 9),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        selectedDate != null
                                            ? DateFormat.MMMMEEEEd()
                                                .format(selectedDate!)
                                            : 'Sort by date',
                                        style: const TextStyle(
                                            color: Colors.white),
                                      ),
                                      const Spacer(),
                                      ElevatedButton(
                                        onPressed: _pickDate,
                                        child: const Text('Sort by date'),
                                      ),
                                    ],
                                  ),
                                  if (expand && selectedDate != null)
                                    TextButton(
                                      onPressed: () {
                                        setState(() {
                                          selectedDate = null;
                                        });
                                      },
                                      child: const Text('Clear date Filter'),
                                    )
                                ],
                              ),
                            ),
                        ],
                      ),
                    ))
              ],
      ),
    );
  }
}

class IncomeListView extends StatelessWidget {
  final Income i;
  final double dH;
  const IncomeListView(this.i, this.dH, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 3, horizontal: 10),
      decoration: BoxDecoration(
          border: Border.all(
            color: Colors.black,
          ),
          borderRadius: BorderRadius.circular(15)),
      height: dH / 8.5,
      child: ListTile(
        leading: CircleAvatar(
          child: IncImage(i.category),
        ),
        title: Text(
          'NGN ${i.amount}',
          style: const TextStyle(
              fontWeight: FontWeight.bold, color: Colors.white, wordSpacing: 3),
        ),
        subtitle: Text(
          DateFormat.yMMMMEEEEd().format(i.date),
          style: const TextStyle(
            color: Colors.grey,
          ),
        ),
        trailing: IconButton(
            onPressed: () {
              Provider.of<Incomes>(context, listen: false).deleteIncome(i.id);
            },
            icon: const Icon(
              Icons.delete,
              color: Colors.red,
              size: 20,
            )),
      ),
    );
  }
}
