import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/widgets/tx_image.dart';
import '/providers/tx_provider.dart';
import '/widgets/tx_chip.dart';

class TxList extends StatelessWidget {
  const TxList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final myList = Provider.of<TxProvider>(context).tx20.reversed.toList();

    return myList.isEmpty
        ? Center(
            child: Column(
              children: [
                Image.asset('images/expense_coverpic.png', fit: BoxFit.fill),
                const Text(
                  'You have no expenses',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white70,
                      fontSize: 20),
                )
              ],
            ),
          )
        : ListView.builder(
            itemCount: myList.length,
            itemBuilder: (context, i) {
              return Container(
                key: ValueKey(myList[i].id),
                margin: const EdgeInsets.symmetric(vertical: 3),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: const Color(0xff010a42)),
                child: ListTile(
                  leading: CircleAvatar(
                      radius: 20, child: TxImage(myList[i].category)),
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        myList[i].title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(
                        height: 2,
                      ),
                      TxChip(myList[i].category, myList[i].date)
                    ],
                  ),
                  trailing: Text(
                    'NGN ${myList[i].amount}',
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              );
            },
          );
  }
}
