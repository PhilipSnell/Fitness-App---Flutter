import 'dart:convert';

List<Exercise> ExerciseFromJson(String str) =>
    List<Exercise>.from(json.decode(str).map((x) => Exercise.fromJson(x)));

String ExerciseToJson(List<Exercise> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Exercise{
  int id;
  String name;
  String description;
  String video;
  String image;

  Exercise({
    this.id,
    this.name,
    this.description,
    this.video,
    this.image,
  });

  factory Exercise.fromJson(Map<String, dynamic> json){
    return Exercise(
        id: json['id'],
        name: json['name'],
        description: json['description'],
        video: json['video'],
        image: json['image'],
    );
  }
  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "description": description,
    "video": video,
    "image": image,
  };
}
