import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thrifty_expense/widgets/income_chip.dart';

import '/widgets/inc_image.dart';
import '/providers/income_provider.dart';

class IncomeList extends StatelessWidget {
  const IncomeList({Key? key}) : super(key: key);
  

  @override
  Widget build(BuildContext context) {
    final myList = Provider.of<Incomes>(context).income20.reversed.toList();
    return myList.isEmpty
        ? Center(
            child: Column(
              children: [
                Image.asset('images/income_coberpic.png', fit: BoxFit.fill),
                const SizedBox(height: 5),
                const Text(
                  'You have no income',
                  style: TextStyle(color: Colors.white70, fontSize: 20,fontWeight: FontWeight.bold),
                )
              ],
            ),
          )
        : ListView.builder(
            itemCount: myList.length,
            itemBuilder: (context, i) {
              return ListTile(
                leading: CircleAvatar(
                  child: IncImage(myList[i].category),
                ),
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'NGN ${myList[i].amount}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    IncomeChip(myList[i].category, myList[i].date)
                  ],
                ),
              );
            });
  }
}
