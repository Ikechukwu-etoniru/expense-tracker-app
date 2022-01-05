import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '/providers/income_provider.dart';
import '/widgets/date_selecter.dart';

class AddIncomeScreen extends StatefulWidget {
  static const routeName = '/add_income_screen';
  const AddIncomeScreen({Key? key}) : super(key: key);

  @override
  State<AddIncomeScreen> createState() => _AddIncomeScreenState();
}

class _AddIncomeScreenState extends State<AddIncomeScreen> {
  int? amountInput;
  DateTime? selectedDate;
  void categorySnackBar(BuildContext ctx) {
    ScaffoldMessenger.of(ctx).removeCurrentSnackBar();
    ScaffoldMessenger.of(ctx).showSnackBar(const SnackBar(
      content: Text('You haven\'t choosen a category'),
      backgroundColor: Colors.red,
      duration: Duration(seconds: 3),
      elevation: 20,
    ));
  }

  void dateSnackBar(BuildContext ctx) {
    ScaffoldMessenger.of(ctx).removeCurrentSnackBar();
    ScaffoldMessenger.of(ctx).showSnackBar(const SnackBar(
      content: Text('You haven\'t picked a date yet'),
      backgroundColor: Colors.red,
      duration: Duration(seconds: 3),
      elevation: 20,
    ));
  }

  void selectDate(DateTime sdate) {
    selectedDate = sdate;
  }

  final _items = ['Salary', 'Gift', 'Business'];
  String? value;

  DropdownMenuItem<String> buildMenuItem(String item) => DropdownMenuItem(
        value: item,
        child: Text(item),
      );
  final _forms = GlobalKey<FormState>();
  Future<bool?> _confirmSaveIncomeDialog(
      String category, DateTime date, int amount) {
    return showDialog<bool>(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            backgroundColor: const Color(0xff010a42),
            title: const Text(
              'Confirm Income Details',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                  fontFamily: 'Raleway'),
            ),
            content: Text(
              'Amount - NGN ${amount.toString()} \nDate - ${DateFormat.MMMEd().format(date)} \nCategory - $category',
              textAlign: TextAlign.left,
              style: const TextStyle(
                  height: 1.5,
                  fontSize: 15,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                  fontFamily: 'Raleway'),
            ),
            elevation: 30,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
                child: const Text(
                  'Cancel',
                  style: TextStyle(color: Colors.red),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
                child: const Text('Confirm'),
              )
            ],
          );
        });
  }

  void _saveForm() async {
    final isValid = _forms.currentState!.validate();

    if (!isValid) {
      return;
    }
    if (selectedDate == null || value == null) {
      return;
    }
    _forms.currentState!.save();
    var _confirm =
        await _confirmSaveIncomeDialog(value!, selectedDate!, amountInput!);
    if (_confirm == null) {
      return;
    } else if (_confirm) {
      Provider.of<Incomes>(context, listen: false)
          .addIncome(amountInput!, selectedDate!, value!);
      Navigator.of(context).pop();
    } else if (_confirm == false) {
      return;
    }
  }

  final _amountFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xff010a42),
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.white),
          centerTitle: true,
          elevation: 0,
          title: const Text(
            'Add Income',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green),
          ),
          backgroundColor: const Color(0xff010a42),
        ),
        body: Builder(
          builder: (ctx) => Form(
            key: _forms,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.only(left: 15),
                    height: 110,
                    width: 380,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Amount',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                        TextFormField(
                          focusNode: _amountFocusNode,
                          keyboardType: TextInputType.number,
                          textInputAction: TextInputAction.next,
                          style: const TextStyle(color: Colors.white),
                          decoration: const InputDecoration(
                            border: UnderlineInputBorder(),
                            hintText: 'Amount earned',
                            hintStyle: TextStyle(color: Colors.grey),
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please add an amount';
                            } else if (int.tryParse(value) == null) {
                              return 'Enter a valid number';
                            } else if (int.parse(value) <= 0) {
                              return 'Please enter a number greater than zero';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            amountInput = int.parse(value!);
                          },
                          onFieldSubmitted: (_) {
                            FocusScope.of(context).unfocus();
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 2),
                  DateSelecter(selectDate),
                  const SizedBox(height: 5),
                  Container(
                    width: 370,
                    padding:
                        const EdgeInsets.symmetric(vertical: 2, horizontal: 10),
                    margin: const EdgeInsets.all(17),
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.yellow, width: 0.9),
                        borderRadius: BorderRadius.circular(15)),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        dropdownColor: const Color(0xff010a42),
                        style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            letterSpacing: 1,
                            fontFamily: 'Raleway'),
                        hint: const Text(
                          'Select Category',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              letterSpacing: 1,
                              fontFamily: 'Raleway'),
                        ),
                        items: _items.map(buildMenuItem).toList(),
                        icon: const Icon(
                          Icons.arrow_drop_down,
                          color: Colors.yellow,
                        ),
                        iconSize: 36,
                        isExpanded: true,
                        value: value,
                        onChanged: (val) {
                          setState(() {
                            value = val;
                          });
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Center(
                    child: InkWell(
                      focusColor: Colors.red,
                      onTap: () {
                        if (value == null) {
                          categorySnackBar(ctx);
                        } else if (selectedDate == null) {
                          dateSnackBar(ctx);
                        }
                        _saveForm();
                      },
                      child: Container(
                        margin: const EdgeInsets.only(left: 15),
                        alignment: Alignment.center,
                        child: const Text(
                          'Save Income',
                          style: TextStyle(
                              fontSize: 17, fontWeight: FontWeight.bold),
                        ),
                        height: 39,
                        width: 380,
                        decoration: BoxDecoration(
                            color: Colors.yellow,
                            borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ));
  }
}
