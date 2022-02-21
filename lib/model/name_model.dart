class NameModel {
  int id;

  String name;

  NameModel({this.id, this.name});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,

      // 'checked': checked
    };
  }

  static NameModel fromMap(Map<String, dynamic> map) {
    return NameModel(
      id: map['id'],
      name: map['name'],

      // checked: map['checked'],
    );
  }
}
