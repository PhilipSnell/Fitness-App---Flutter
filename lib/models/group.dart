import 'dart:convert';

List<Group> GroupFromJson(String str) =>
    List<Group>.from(json.decode(str).map((x) => Group.fromJson(x)));

String GroupToJson(List<Group> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Group{
  int id;
  String name;
  List<TextField> textfields;

  Group({
    this.id,
    this.name,
    this.textfields,
  });

  factory Group.fromJson(Map<String, dynamic> json){
    return Group(
      id: json['id'],
      name: json['name'],
      textfields: json['textfields'],

    );
  }
  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "textfields": textfields,
  };
}
class TextField {
  int id;
  String name;
  bool type;

  TextField({
    this.id,
    this.name,
    this.type
  });
}

class TextValue {
  int id;
  DateTime date;
  String value;

  TextValue({
    this.id,
    this.date,
    this.value,
  });

  Map<String, dynamic> toJson() => {
    "field_id": id,
    "date": date.toString().substring(0,10),
    "value": value,
  };
}
