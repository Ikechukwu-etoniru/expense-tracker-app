import 'package:flutter/material.dart';

import '/widgets/tx_list.dart';

class TxListWidget extends StatelessWidget {
  final Function nextPage;

  const TxListWidget(this.nextPage, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      width: double.infinity,
      decoration: const BoxDecoration(
          color: Color(0xff0f194e),
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(30),
            topLeft: Radius.circular(30),
          ),
          boxShadow: [BoxShadow(color: Colors.red, blurRadius: 3)]),
      child: Column(
        children: [
          Center(
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 5),
              width: 60,
              height: 4,
              decoration: BoxDecoration(
                  color: Colors.grey, borderRadius: BorderRadius.circular(20)),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(left: 30, right: 10),
            child: Row(
              children: [
                const Text(
                  'Expenses',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Raleway',
                      color: Colors.white,
                      fontSize: 20),
                ),
                const Spacer(),
                TextButton(
                    onPressed: () {
                      nextPage();
                    },
                    child: Row(
                      children: const [
                        Text('Go to income'),
                        SizedBox(width: 2),
                        Icon(
                          Icons.arrow_forward,
                          color: Colors.yellow,
                          size: 15,
                        ),
                      ],
                    ))
              ],
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Expanded(
            child: Container(
              width: 390,
              child: const TxList(),
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(30)),
            ),
          )
        ],
      ),
    );
  }
}
