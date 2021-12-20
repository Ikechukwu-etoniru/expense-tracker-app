enum ExpenseType { food, education, business, travel, luxury, miscellaneous }

class Transaction {
  String id;
  String title;
  int amount;
  DateTime date;
  String description;
  ExpenseType category;

  Transaction({
    required this.id,
    required this.amount,
    required this.title,
    required this.category,
    required this.date,
    this.description = "",
  });
}
