import 'dart:convert';

List<TrainingEntry> TrainingEntryFromJson(String str) =>
    List<TrainingEntry>.from(json.decode(str).map((x) => TrainingEntry.fromJson(x)));

String TrainingEntryToJson(List<TrainingEntry> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));


class TrainingEntry {
  int id;
  int userId;
  int phase;
  int week;
  int day;
  String reps;
  String weight;
  int sets;
  int exerciseId;

  TrainingEntry({
    this.id,
    this.userId,
    this.phase,
    this.week,
    this.day,
    this.reps,
    this.weight,
    this.sets,
    this.exerciseId,
  });

  factory TrainingEntry.fromJson(Map<String, dynamic> json) => TrainingEntry(
    id: json["id"],
    userId: json["user"],
    phase: json["phase"],
    week: json["week"],
    day: json["day"],
    reps: json["reps"],
    weight: json["weight"],
    sets: json["sets"],
    exerciseId: json["exercise"]["id"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user": userId,
    "phase": phase,
    "week": week,
    "day": day,
    "reps": reps,
    "weight": weight,
    "sets": sets,
    "exercise": exerciseId,
  };
}