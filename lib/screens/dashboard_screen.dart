import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:provider/provider.dart';
import 'package:thrifty_expense/providers/income_provider.dart';
import 'package:thrifty_expense/providers/tx_provider.dart';

import '/widgets/my_drawer.dart';
import '/widgets/expense_bar_chart.dart';
import '/widgets/income_list_widget.dart';
import '/screens/add_expense_screen.dart';
import '/widgets/tx_list_widget.dart';
import '/screens/add_income_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  Widget fabLabel(Color color, String text) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15),
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 6),
      child: Text(
        text,
        style: const TextStyle(fontSize: 15),
      ),
      decoration: BoxDecoration(
        boxShadow: [BoxShadow(color: color, blurRadius: 2, spreadRadius: 2)],
        borderRadius: BorderRadius.circular(5),
        color: Colors.white,
      ),
    );
  }

  final controller = PageController(
    initialPage: 0,
  );

  var appBarr = AppBar(
    iconTheme: const IconThemeData(color: Colors.white),
    backgroundColor: const Color(0xff010a42),
    elevation: 30,
    title: const Text(
      'Thrifty Expense',
      style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
    ),
  );

  void nextPage() {
    controller.nextPage(
        duration: const Duration(milliseconds: 3), curve: Curves.easeIn);
  }

  void previousPage() {
    controller.previousPage(
        duration: const Duration(milliseconds: 3), curve: Curves.easeIn);
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  void initState() {
    super.initState();
    Provider.of<TxProvider>(context, listen: false).getExpenses();
    Provider.of<Incomes>(context, listen: false).getIncome();
    
  }

  @override
  Widget build(BuildContext context) {
    final deviceHeight = (MediaQuery.of(context).size.height -
        appBarr.preferredSize.height -
        MediaQuery.of(context).padding.top);
    return Scaffold(
      floatingActionButton: SpeedDial(
        spacing: 20,
        spaceBetweenChildren: 6,
        animatedIcon: AnimatedIcons.menu_arrow,
        overlayColor: const Color(0xff010a42),
        overlayOpacity: 0.8,
        children: [
          SpeedDialChild(
              onTap: () {
                Navigator.of(context).pushNamed(AddExpenseScreen.routeName);
              },
              elevation: 30,
              labelWidget: fabLabel(Colors.red, 'Add Expenses'),
              child: const Icon(Icons.money_off),
              backgroundColor: Colors.red),
          SpeedDialChild(
            onTap: () {
              Navigator.of(context).pushNamed(AddIncomeScreen.routeName);
            },
            labelWidget: fabLabel(Colors.green, 'Add Income'),
            child: const Icon(Icons.attach_money),
            backgroundColor: Colors.green,
          )
        ],
      ),
      backgroundColor: const Color(0xff010a42),
      drawer: const MyDrawer(),
      appBar: appBarr,
      body: Column(
        children: [
          Container(
            child: const ExpenseBarChart(),
            margin: const EdgeInsets.all(10),
            height: deviceHeight * 0.3,
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color(0xff010a42),
              boxShadow: const [
                BoxShadow(color: Colors.red, blurRadius: 1, spreadRadius: 1)
              ],
              borderRadius: BorderRadius.circular(30),
            ),
            alignment: Alignment.center,
          ),
          Expanded(
            child: PageView(
              controller: controller,
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 5),
                  height: deviceHeight * 0.7,
                  child: TxListWidget(nextPage),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 5),
                  height: deviceHeight * 0.7,
                  child: IncomeListWidget(previousPage),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
