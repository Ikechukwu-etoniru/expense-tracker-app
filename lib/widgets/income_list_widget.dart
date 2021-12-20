import 'package:flutter/material.dart';

import '/widgets/income_list.dart';

class IncomeListWidget extends StatelessWidget {
  final Function previousPage;
  const IncomeListWidget(this.previousPage, {Key? key}) : super(key: key);

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
          boxShadow: [BoxShadow(color: Colors.green, blurRadius: 3)]),
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
                  'Income',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Raleway',
                      color: Colors.white,
                      fontSize: 20),
                ),
                const Spacer(),
                // IconButton(
                //   onPressed: () {
                //     previousPage();
                //   },
                //   icon: const Icon(
                //     Icons.arrow_back,
                //     color: Colors.yellow,
                //   ),
                // ),
                TextButton(
                  onPressed: () {
                    previousPage();
                  },
                  child: Row(
                    children: const [
                      Icon(
                        Icons.arrow_back,
                        color: Colors.yellow,
                        size: 15,
                      ),
                      SizedBox(width: 2),
                      Text('Go to expense'),
                    ],
                  ),
                )
              ],
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Expanded(
            child: Container(
              width: 390,
              child: const IncomeList(),
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(30)),
            ),
          )
        ],
      ),
    );
  }
}
