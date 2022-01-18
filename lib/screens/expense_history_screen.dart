import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '/widgets/tx_image.dart';
import '/models/transaction.dart';
import '/providers/tx_provider.dart';
import '/widgets/my_drawer.dart';

class ExpenseHistoryScreen extends StatefulWidget {
  static const routeName = '/expense_history_screen';
  const ExpenseHistoryScreen({Key? key}) : super(key: key);

  @override
  State<ExpenseHistoryScreen> createState() => _ExpenseHistoryScreenState();
}

class _ExpenseHistoryScreenState extends State<ExpenseHistoryScreen> {
  final appBarr = AppBar(
    iconTheme: const IconThemeData(color: Colors.white),
    backgroundColor: const Color(0xff010a42),
    elevation: 30,
    title: const Text(
      'All Expenses',
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
    final expense = Provider.of<TxProvider>(context);
    final expenseList =
        selectedDate == null ? expense.tx.reversed.toList() : expense.filterByDate(selectedDate!);
    final deviceHeight = (MediaQuery.of(context).size.height -
        appBarr.preferredSize.height -
        MediaQuery.of(context).padding.top);
    final deviceWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xff010a42),
      drawer: const MyDrawer(),
      appBar: appBarr,
      body: Column(
        children: expenseList.isEmpty && selectedDate == null
            ? [
                const SizedBox(
                  height: 30,
                ),
                const Center(
                  child: Text(
                    'You have no expenses',
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
                  child: selectedDate != null && expenseList.isEmpty
                      ? const Center(
                          child: Text(
                            'NO EXPENSE WAS MADE ON THIS DAY',
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
                          itemCount: expenseList.length,
                          itemBuilder: (context, i) => ExpenseListView(
                              expenseList[i], deviceHeight, deviceWidth),
                        ),
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
                                'Filter List',
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
                                          : 'Filter by date',
                                      style:
                                          const TextStyle(color: Colors.white),
                                    ),
                                    const Spacer(),
                                    ElevatedButton(
                                      onPressed: _pickDate,
                                      child: const Text('Filter by date'),
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
                                  ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                )
              ],
      ),
    );
  }
}

class ExpenseListView extends StatefulWidget {
  final Transaction tx;
  final double deviceHeight;
  final double deviceWidth;
  const ExpenseListView(this.tx, this.deviceHeight, this.deviceWidth,
      {Key? key})
      : super(key: key);

  @override
  State<ExpenseListView> createState() => _ExpenseListViewState();
}

class _ExpenseListViewState extends State<ExpenseListView>
    with SingleTickerProviderStateMixin {
  bool showMore = false;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(widget.tx.id),
      onDismissed: (direction) {
        if (direction == DismissDirection.startToEnd) {
          Provider.of<TxProvider>(context, listen: false)
              .deleteExpense(widget.tx.id);
        }
      },
      direction: DismissDirection.startToEnd,
      movementDuration: const Duration(milliseconds: 500),
      background: Container(
        alignment: Alignment.centerLeft,
        decoration: const BoxDecoration(color: Colors.white),
        margin: const EdgeInsets.symmetric(vertical: 3, horizontal: 10),
        height: showMore == false
            ? widget.deviceHeight / 6.5
            : widget.deviceHeight / 4.5,
        child: const Icon(
          Icons.delete,
          size: 40,
          color: Colors.red,
        ),
      ),
      child: AnimatedContainer(
        curve: Curves.easeIn,
        margin: const EdgeInsets.symmetric(vertical: 3, horizontal: 10),
        height: showMore == false
            ? widget.deviceHeight / 7.5
            : widget.deviceHeight / 5,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: Colors.black45, width: 3)),
        duration: const Duration(milliseconds: 500),
        child: ListView(padding: const EdgeInsets.all(8), children: [
          Row(
            children: [
              SizedBox(
                width: widget.deviceWidth * 0.1,
                child: CircleAvatar(
                  child: TxImage(widget.tx.category),
                ),
              ),
              SizedBox(
                width: widget.deviceWidth * 0.04,
              ),
              SizedBox(
                width: widget.deviceWidth * 0.35,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FittedBox(
                      child: Text(
                        widget.tx.title,
                        softWrap: true,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            wordSpacing: 3),
                      ),
                    ),
                    Text(
                      DateFormat.yMEd().format(widget.tx.date),
                      style: const TextStyle(color: Colors.grey, fontSize: 14),
                    )
                  ],
                ),
              ),
              SizedBox(
                width: widget.deviceWidth * 0.02,
              ),
              SizedBox(
                width: widget.deviceWidth * 0.18,
                child: FittedBox(
                  child: Text(
                    'NGN ${widget.tx.amount}',
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ),
              SizedBox(
                width: widget.deviceWidth * 0.1,
                child: IconButton(
                  onPressed: () {
                    setState(() {
                      showMore = !showMore;
                    });
                  },
                  icon: Icon(
                    showMore ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(
                width: widget.deviceWidth * 0.1,
                child: IconButton(
                  onPressed: () {
                    Provider.of<TxProvider>(context, listen: false)
                        .deleteExpense(widget.tx.id);
                  },
                  icon: const Icon(
                    Icons.delete,
                    color: Colors.red,
                    size: 20,
                  ),
                ),
              )
            ],
          ),
          if (showMore)
            Container(
              margin:
                  const EdgeInsets.only(top: 10, left: 5, right: 5, bottom: 1),
              height: widget.deviceHeight / 4.5 - widget.deviceHeight / 7.0,
              child: ListView(children: [
                Text(
                  widget.tx.description.isEmpty
                      ? 'No description was given for this expense'
                      : widget.tx.description,
                  softWrap: true,
                  style: const TextStyle(color: Colors.white70, wordSpacing: 3),
                ),
              ]),
            ),
        ]),
      ),
    );
  }
}






