import 'dart:convert';

List<Group> GroupFromJson(String str) =>
    List<Group>.from(json.decode(str).map((x) => Group.fromJson(x)));

String GroupToJson(List<Group> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Group{
  int id;
  String name;
  List<TextField> textfields;
  List intfields;

  Group({
    this.id,
    this.name,
    this.textfields,
    this.intfields,
  });

  factory Group.fromJson(Map<String, dynamic> json){
    return Group(
      id: json['id'],
      name: json['name'],
      textfields: json['textfields'],
      intfields: json['intfields'],

    );
  }
  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "textfields": textfields,
    "intfields": textfields,
  };
}
class TextField {
  int id;
  String name;

  TextField({
    this.id,
    this.name,
  });
}
class IntField {
  int id;
  String name;

  IntField({
    this.id,
    this.name,
  });
}