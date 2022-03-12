// ignore_for_file: file_names
import 'dart:convert';

String eventToJson(List<Events> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

List<Events> eventFromJson(List<dynamic> str) =>
    List<Events>.from(str.map((x) => Events.fromJson(x)));

class Events {
  Events({
    this.name,
    this.description,
    required this.startTime,
    required this.endTime,
  });

  final String? name;
  final String? description;
  final DateTime startTime;
  final DateTime endTime;

  Events copyWith({
    String? name,
    String? description,
    DateTime? startTime,
    DateTime? endTime,
  }) =>
      Events(
        name: name ?? this.name,
        description: description ?? this.description,
        startTime: startTime ?? this.startTime,
        endTime: endTime ?? this.endTime,
      );

  factory Events.fromJson(Map<String, dynamic> json) => Events(
        name: json["name"],
        description: json["description"],
        startTime: DateTime.parse(json["start"]).toLocal(),
        endTime: DateTime.parse(json["end"]).toLocal(),
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "description": description,
        "start": startTime.toUtc().toString(),
        "end": endTime.toUtc().toString(),
      };
}
