class TransactionModel {
  int id;
  String price;
  String date;
  String name;
  String description;


  TransactionModel(
      {this.id, this.name, this.description, this.date, this.price});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'date': date,

      // 'checked': checked
    };
  }

  static TransactionModel fromMap(Map<String, dynamic> map) {
    return TransactionModel(
        id: map['id'],
        name: map['name'],
        description: map['description'],
        price: map['price'],
        date: map['date'],

      // checked: map['checked'],
    );
  }
}
