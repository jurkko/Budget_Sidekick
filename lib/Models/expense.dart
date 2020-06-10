class Expense {
  String id;
  String user_id;
  String name;
  int amount;
  String category;
  DateTime date;
  bool profit;
  Expense(
      {this.id,
      this.name,
      this.amount,
      this.category,
      this.profit,
      this.user_id,
      this.date});
}
