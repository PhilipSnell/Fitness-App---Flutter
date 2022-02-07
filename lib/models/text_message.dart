import 'dart:convert';

List<TextMessage> TextMessageFromJson(String str) =>
    List<TextMessage>.from(json.decode(str).map((x) => TextMessage.fromJson(x)));

String TextMessageToJson(List<TextMessage> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class TextMessage{
  int author_id;
  String message;

  TextMessage({
    this.author_id,
    this.message,
  });

  factory TextMessage.fromJson(Map<String, dynamic> json){
    return TextMessage(
      author_id: json['author_id'],
      message: json['message'],

    );
  }
  Map<String, dynamic> toJson() => {
    "author_id": author_id,
    "message": message,
  };
}