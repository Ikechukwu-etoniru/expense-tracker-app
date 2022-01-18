import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '/providers/tx_provider.dart';
import '/widgets/date_selecter.dart';

class AddExpenseScreen extends StatefulWidget {
  static const routeName = '/add_expense_screen';
  const AddExpenseScreen({Key? key}) : super(key: key);

  @override
  State<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  final _amountFocusNode = FocusNode();
  final _items = [
    'Business',
    'Education',
    'Food',
    'Luxury',
    'Travel',
    'Micellaneous'
  ];
  String? value;

  DateTime? selectedDate;

  void selectDate(DateTime sdate) {
    selectedDate = sdate;
  }

  DropdownMenuItem<String> buildMenuItem(String item) => DropdownMenuItem(
        value: item,
        child: Text(item),
      );

  final _forms = GlobalKey<FormState>();

  void _categorySnackBar(BuildContext ctx) {
    ScaffoldMessenger.of(ctx).removeCurrentSnackBar();
    ScaffoldMessenger.of(ctx).showSnackBar(const SnackBar(
      content: Text('You haven\'t choosen a category'),
      backgroundColor: Colors.red,
      duration: Duration(seconds: 3),
      elevation: 20,
    ));
  }

  void _dateSnackBar(BuildContext ctx) {
    ScaffoldMessenger.of(ctx).removeCurrentSnackBar();
    ScaffoldMessenger.of(ctx).showSnackBar(const SnackBar(
      content: Text('You haven\'t picked a date yet'),
      backgroundColor: Colors.red,
      duration: Duration(seconds: 3),
      elevation: 20,
    ));
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
    final _confirm = await confirmSaveExpenseDialog(
        titleInput, value!, selectedDate!, amountInput);
    if (_confirm == null) {
      return;
    } else if (_confirm) {
      Provider.of<TxProvider>(context, listen: false).addExpense(
          titleInput, amountInput, descriptionInput, selectedDate!, value!);
      Navigator.of(context).pop();
    } else if (_confirm == false) {
      return;
    }
  }

  late String titleInput;
  late int amountInput;
  late String descriptionInput;

  Future<bool?> confirmSaveExpenseDialog(
      String title, String category, DateTime date, int amount) {
    return showDialog<bool>(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            backgroundColor: const Color(0xff010a42),
            title: const Text(
              'Confirm Expense Details',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                  fontFamily: 'Raleway'),
            ),
            content: Text(
              'Title - $title \nAmount - NGN ${amount.toString()} \nDate - ${DateFormat.MMMEd().format(date)} \nCategory - $category',
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

  @override
  void dispose() {
    super.dispose();
    _amountFocusNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xff010a42),
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.white),
          centerTitle: true,
          elevation: 0,
          title: const Text(
            'Add Expense',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
          ),
          backgroundColor: const Color(0xff010a42),
        ),
        body: Builder(
          builder: (ctx) => Form(
            key: _forms,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(left: 15),
                    height: 110,
                    width: 380,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Title',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                        TextFormField(
                          textCapitalization: TextCapitalization.sentences,
                          onFieldSubmitted: (_) {
                            FocusScope.of(context)
                                .requestFocus(_amountFocusNode);
                          },
                          keyboardType: TextInputType.name,
                          textInputAction: TextInputAction.next,
                          style: const TextStyle(color: Colors.white),
                          decoration: const InputDecoration(
                            border: UnderlineInputBorder(),
                            hintText: 'Title of expense',
                            hintStyle: TextStyle(color: Colors.grey),
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please add a title';
                            } else if (value.length > 20) {
                              return 'Title is too long';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            titleInput = value!;
                          },
                        )
                      ],
                    ),
                  ),
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
                          onFieldSubmitted: (_) {
                            FocusScope.of(context).unfocus();
                          },
                          focusNode: _amountFocusNode,
                          keyboardType: TextInputType.number,
                          textInputAction: TextInputAction.next,
                          style: const TextStyle(color: Colors.white),
                          decoration: const InputDecoration(
                            border: UnderlineInputBorder(),
                            hintText: 'Amount spent on expense',
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
                        )
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 15),
                    height: 100,
                    width: 380,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Description',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                        TextFormField(
                          textCapitalization: TextCapitalization.sentences,
                          maxLines: 2,
                          keyboardType: TextInputType.multiline,
                          textInputAction: TextInputAction.next,
                          style: const TextStyle(color: Colors.white),
                          decoration: const InputDecoration(
                            border: UnderlineInputBorder(),
                            hintText: 'Description (Optional)',
                            hintStyle: TextStyle(color: Colors.grey),
                          ),
                          onFieldSubmitted: (value) {
                            FocusScope.of(context).unfocus();
                          },
                          onSaved: (value) {
                            descriptionInput = value!;
                          },
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  DateSelecter(selectDate),
                  const SizedBox(height: 10),
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
                      onTap: () async {
                        if (value == null) {
                          _categorySnackBar(ctx);
                        } else if (selectedDate == null) {
                          _dateSnackBar(ctx);
                        } else {
                          _saveForm();
                        }
                      },
                      child: Container(
                        margin: const EdgeInsets.only(left: 15),
                        alignment: Alignment.center,
                        child: const Text(
                          'Save Expense',
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
