import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateSelecter extends StatefulWidget {
  final Function selectDate;

 const DateSelecter(this.selectDate,{Key? key}) : super(key: key);

  @override
  State<DateSelecter> createState() => _DateSelecterState();
}

class _DateSelecterState extends State<DateSelecter> {
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
      widget.selectDate(selectedDate);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 20),
      height: 70,
      width: 380,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            selectedDate == null
                ? 'No date chosen'
                : DateFormat.yMMMEd().format(selectedDate!),
            style: const TextStyle(color: Colors.white, fontSize: 18),
          ),
          TextButton(
            onPressed: () {
              _pickDate();
            },
            child: const Text('Choose date',
                style: TextStyle(color: Colors.yellowAccent, fontSize: 16)),
          )
        ],
      ),
    );
  }
}
