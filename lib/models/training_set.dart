import 'dart:convert';

List<TrainingSet> TrainingSetFromJson(String str) =>
    List<TrainingSet>.from(json.decode(str).map((x) => TrainingSet.fromJson(x)));

String TrainingSetToJson(List<TrainingSet> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class TrainingSet {
  int t_id;
  int sets;
  String reps;
  String weights;
  int difficulty;
  String comment;
  int e_id;

  TrainingSet({
    this.t_id,
    this.sets,
    this.reps,
    this.weights,
    this.difficulty,
    this.comment,
    this.e_id,
  });

  factory TrainingSet.fromJson(Map<String, dynamic> json) => TrainingSet(
    t_id: json["t_id"],
    sets: json["sets"],
    reps: json["reps"],
    weights: json["weights"],
    difficulty: json["difficulty"],
    comment: json["comment"],
    e_id: json["e_id"],
  );
  Map<String, dynamic> toJson() => {
    "t_id": t_id,
    "sets": sets,
    "reps": reps,
    "weights": weights,
    "difficulty": difficulty,
    "comment": comment,
    "e_id": e_id,
  };
}
