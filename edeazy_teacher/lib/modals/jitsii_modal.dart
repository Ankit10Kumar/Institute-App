// To parse this JSON data, do
//
//     final jitsii = jitsiiFromJson(jsonString);

import 'dart:convert';


List<Jitsii> jitsiiclassfrom(json) =>
    List.from(json).map((e) => Jitsii.fromJson(e)).toList();
List<Map<String, dynamic>> jitsiiclassto(List<Jitsii> c) =>
    c.map((e) => e.toJson()).toList();
class Jitsii {
    Jitsii({
        required this.id,
        required this.jitsiiClass,
        required this.subject,
        required this.startTime,
        required this.endTime,
    });

    final String id;
    final String jitsiiClass;
    final String subject;
    final DateTime startTime;
    final DateTime endTime;

    Jitsii copyWith({
        String? id,
        String? jitsiiClass,
        String? subject,
        DateTime? startTime,
        DateTime? endTime,
    }) => 
        Jitsii(
            id: id ?? this.id,
            jitsiiClass: jitsiiClass ?? this.jitsiiClass ,
            subject: subject ?? this.subject,
            startTime: startTime ?? this.startTime,
            endTime: endTime ?? this.endTime,
        );

    // factory Jitsii.fromRawJson(String str) => Jitsii.fromJson(json.decode(str));

    // String toRawJson() => json.encode(toJson());

    factory Jitsii.fromJson(Map<String, dynamic> json) => Jitsii(
        id: json["_id"],
        jitsiiClass: json["class"],
        subject: json["subject"],
        startTime: json["startTime"],
        endTime: json["endTime"],
    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "class": jitsiiClass,
        "subject": subject,
        "startTime": startTime,
        "endTime": endTime,
    };
}
