import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';

import '/providers/tx_provider.dart';
import '/widgets/chart_date.dart';

class ExpenseBarChart extends StatelessWidget {
  const ExpenseBarChart({Key? key}) : super(key: key);

  String currency() {
    var format =
        NumberFormat.simpleCurrency(locale: Platform.localeName, name: 'NGN');
    return format.currencySymbol;
  }

  @override
  Widget build(BuildContext context) {
    final txProvider = Provider.of<TxProvider>(context);
    var chartMax = txProvider.amountInLast7days;
    final chartValues = txProvider.expenseChartData;

    return LayoutBuilder(builder: (context, constraints) {
      final myWidth = constraints.maxWidth * 0.9;
      return Padding(
        padding: const EdgeInsets.all(7.0),
        child: Column(
          children: [
            SizedBox(
              height: constraints.maxHeight * 0.2,
              child: const Text(
                'Expenses This Week',
                style: TextStyle(
                    color: Colors.red,
                    fontSize: 15,
                    fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(
              child: Center(
                child: SizedBox(
                  height: constraints.maxHeight * 0.7,
                  width: myWidth,
                  child: BarChart(
                                     
                  BarChartData(
                    borderData: FlBorderData(show: false),
                      gridData: FlGridData(show: false),
                      titlesData: FlTitlesData(show: false),
                      alignment: BarChartAlignment.center,
                      maxY: chartMax,
                      minY: 0,
                      groupsSpace: (myWidth / 7) * 0.5,
                      barTouchData: BarTouchData(
                       enabled: true,
                        touchTooltipData: BarTouchTooltipData(
                          fitInsideHorizontally: true,
                          fitInsideVertically: true,
                            tooltipBgColor: Colors.redAccent,
                            getTooltipItem:
                                (group, groupIndex, rod, rodIndex) {
                                  String amount = 
                                    group.x == 1 ? (chartValues[6]['amount']).toString()
                                  : group.x == 2 ? (chartValues[5]['amount']).toString()
                                  : group.x == 3 ? (chartValues[4]['amount']).toString()
                                  : group.x == 4 ? (chartValues[3]['amount']).toString()
                                  : group.x == 5 ? (chartValues[2]['amount']).toString()
                                  : group.x == 6 ? (chartValues[1]['amount']).toString()
                                  : group.x == 7 ? (chartValues[0]['amount']).toString()
                                  : 'anotherday';
                                   
                                  return BarTooltipItem('Spent ${currency()}$amount', const TextStyle(
                                    fontFamily: 'Raleway',
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold
                                  ));
                                }),
                      ),
                      barGroups: chartValues
                          .map(
                            (e) => BarChartGroupData(x: e['id'], barRods: [
                              BarChartRodData(

                                colors: [Colors.red, Colors.yellow],
                                gradientTo: const Offset(1, 0),
                                gradientFrom: const Offset(0, 1),
                                y: chartMax == 0 && e['amount'] == 0
                                    ? 1
                                    : e['amount'],
                                width: (myWidth / 7) * 0.5,
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(5),
                                  topRight: Radius.circular(5),
                                ),
                              )
                            ]),
                          )
                          .toList(),
                    ),
                  ),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 8, bottom: 4),
              height: constraints.maxHeight * 0.1,
              width: constraints.maxWidth * 0.9,
              child: ChartDate(myWidth),
            ),
          ],
        ),
      );
    });
  }
}
