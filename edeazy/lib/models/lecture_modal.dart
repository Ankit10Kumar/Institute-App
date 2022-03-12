// To parse this JSON data, do
//
//     final lectures = lecturesFromJson(jsonString);
import 'dart:convert';

List<Lectures> lecturesFromJson(dynamic str) =>
    List<Lectures>.from(str.map((x) => Lectures.fromJson(x)));

// List<Lectures> lecturesFromJson(String str) =>
//     List<Lectures>.from(json.decode(str).map((x) => Lectures.fromJson(x)));

String lecturesToJson(List<Lectures> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Lectures {
  Lectures({
    required this.id,
    required this.organisationId,
    required this.classId,
    required this.batch,
    required this.isLive,
    required this.lectureClass,
    this.teacher,
    required this.teacherImage,
    required this.stream,
    required this.subject,
    this.startTime,
    this.endTime,
  });

  final String id;
  final String organisationId;
  final String classId;
  final int batch;
  final bool isLive;
  final String lectureClass;
  final String? teacher;
  final String teacherImage;
  final String stream;
  final String subject;
  final DateTime? startTime;
  final DateTime? endTime;

  Lectures copyWith({
    String? id,
    String? organisationId,
    String? classId,
    int? batch,
    bool? isLive,
    String? lectureClass,
    String? teacher,
    String? teacherImage,
    String? stream,
    String? subject,
    DateTime? startTime,
    DateTime? endTime,
  }) =>
      Lectures(
          id: id ?? this.id,
          organisationId: organisationId ?? this.organisationId,
          classId: classId ?? this.classId,
          batch: batch ?? this.batch,
          isLive: isLive ?? this.isLive,
          lectureClass: lectureClass ?? this.lectureClass,
          teacher: teacher ?? this.teacher,
          teacherImage: teacherImage ?? this.teacherImage,
          stream: stream ?? this.stream,
          subject: subject ?? this.subject,
          startTime: startTime ?? this.startTime,
          endTime: endTime ?? this.endTime);

  factory Lectures.fromJson(Map<String, dynamic> json) => Lectures(
        id: json["_id"],
        organisationId: json["organisationId"],
        classId: json["classId"],
        batch: json["batch"],
        isLive: json["isLive"],
        lectureClass: json["class"],
        teacher: json["teacher"],
        teacherImage: json["teacherImage"],
        stream: json["stream"],
        subject: json["subject"],
        startTime: (json["startTime"] == null)
            ? null
            : DateTime.parse(json["startTime"]).toLocal(),
        endTime: (json["endTime"] == null)
            ? null
            : DateTime.parse(json["endTime"]).toLocal(),
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "organisationId": organisationId,
        "classId": classId,
        "batch": batch,
        "isLive": isLive,
        "class": lectureClass,
        "teacher": teacher,
        "teacherImage": teacherImage,
        "stream": stream,
        "subject": subject,
        "startTime": (startTime == null) ? null : startTime!.toUtc().toString(),
        "endTime": (endTime == null) ? null : startTime!.toUtc().toString(),
      };
}
