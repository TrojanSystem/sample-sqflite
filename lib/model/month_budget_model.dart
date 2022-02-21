class MonthBudget {
  int id;
  String price;

  MonthBudget({this.id, this.price});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'price': price,

    };
  }

  static MonthBudget fromMap(Map<String, dynamic> map) {
    return MonthBudget(
      id: map['id'],
      price: map['price'],

    );
  }
}
