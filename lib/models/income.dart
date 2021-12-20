enum IncomeType {
  salary,
  gift,
  business,
}

class Income {
  String id;
  int amount;
  DateTime date;
  IncomeType category;
  Income(
      {required this.id,
      required this.date,
      required this.amount,
      required this.category});
}
