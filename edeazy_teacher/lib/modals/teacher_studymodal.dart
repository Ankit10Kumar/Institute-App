// //Modals for Techer Classes and Subjetcs
List<Teacher> teacherclasfrom(json) =>
    List.from(json).map((e) => Teacher.fromJson(e)).toList();
List<Map<String, dynamic>> teacherclasto(List<Teacher> c) =>
    c.map((e) => e.toJson()).toList();

List<Subject> subjectfrom(json) =>
    List.from(json).map((e) => Subject.fromJson(e)).toList();
List<Map<String, dynamic>> subjectto(List<Subject> c) =>
    c.map((e) => e.toJson()).toList();

// class Teacher {
//   Teacher({
//     required this.teacherClass,
//     required this.stream,
//     required this.subject,
    
//   });

//   final String teacherClass;
//   final String stream;
//   final List<String> subject;

//   Teacher copyWith({
//     String? teacherClass,
//     String? stream,
//     List<String>? subject,
//   }) =>
//       Teacher(
//         teacherClass: teacherClass ?? this.teacherClass,
//         subject: subject ?? this.subject,
//         stream: stream ?? this.stream,
//       );

//   factory Teacher.fromJson(Map<String, dynamic> json) => Teacher(
//         teacherClass: json["class"],
//         stream: json['stream'],
//         subject: List<String>.from(json["subjects"].map((x) => x)),
//       );

//   Map<String, dynamic> toJson() => {
//         "class": teacherClass,
//         "stream": stream,
//         "subjects": List<dynamic>.from(subject.map((x) => x)),
//       };
// }

// To parse this JSON data, do
//
//     final teacher = teacherFromJson(jsonString);


class Teacher {
    Teacher({
        required this.teacherClass,
        required this.stream,
        required this.subjects,
    });

    final String teacherClass;
    final String stream;
    final List<Subject> subjects;

    Teacher copyWith({
        String? teacherClass,
        String? stream,
        List<Subject>? subjects,
    }) => 
        Teacher(
            teacherClass: teacherClass ?? this.teacherClass,
            stream: stream ?? this.stream,
            subjects: subjects ?? this.subjects,
        );

    // factory Teacher.fromRawJson(String str) => Teacher.fromJson(json.decode(str));

    // String toRawJson() => json.encode(toJson());

    factory Teacher.fromJson(Map<String, dynamic> json) => Teacher(
        teacherClass: json["class"],
        stream: json["stream"],
        subjects: List<Subject>.from(json["subjects"].map((x) => Subject.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "class": teacherClass,
        "stream": stream,
        "subjects": List<dynamic>.from(subjects.map((x) => x.toJson())),
    };
}

class Subject {
    Subject({
        required this.classId,
        required this.batch,
        required this.lectureId,
        required this.name,
    });

    final String classId;
    final int batch;
    final String lectureId;
    final String name;

    Subject copyWith({
        String? classId,
        int? batch,
        String? lectureId,
        String? name,
    }) => 
        Subject(
            classId: classId ?? this.classId,
            batch: batch ?? this.batch,
            lectureId: lectureId ?? this.lectureId,
            name: name ?? this.name,
        );

    // factory Subject.fromRawJson(String str) => Subject.fromJson(json.decode(str));

    // String toRawJson() => json.encode(toJson());

    factory Subject.fromJson(Map<String, dynamic> json) => Subject(
        classId: json["classId"],
        batch: json["batch"],
        lectureId: json["lectureId"],
        name: json["name"],
    );

    Map<String, dynamic> toJson() => {
        "classId": classId,
        "batch": batch,
        "lectureId": lectureId,
        "name": name,
    };
}


//Modals for Chapter Notes
List<Notes> notesfrom(json) =>
    List.from(json).map((e) => Notes.fromJson(e)).toList();
List<Map<String, dynamic>> notesto(List<Notes> subj) =>
    subj.map((e) => e.toJson()).toList();

class Notes {
  Notes({
    required this.chapterid,
    required this.chapterName,
    required this.chapterNo,
  });
  late final String chapterid;
  late final String chapterName;
  late final int chapterNo;

  Notes.fromJson(Map<String, dynamic> json) {
    chapterName = json['chapterName'];
    chapterid = json['_id'];
    chapterNo = json['chapterNumber'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['chapterName'] = chapterName;
    _data['_id'] = chapterid;
    _data['chapterNumber'] = chapterName;
    return _data;
  }
}

//Modals For Secondary Materials Like Assignment or Sample-Paper
List<SecondaryMatModal> secmatfrom(json) =>
    List.from(json).map((e) => SecondaryMatModal.fromJson(e)).toList();
List<Map<String, dynamic>> secmatto(List<SecondaryMatModal> subj) =>
    subj.map((e) => e.toJson()).toList();

class SecondaryMatModal {
  SecondaryMatModal({
    required this.topic,
    required this.file,
  });
  late final String topic;
  late final FileClass file;

  SecondaryMatModal.fromJson(Map<String, dynamic> json) {
    topic = json['name'];
    file = FileClass.fromJson(json['file']);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['name'] = topic;
    _data['file'] = file.toJson();
    return _data;
  }
}

//Modals for Chapter Topics
List<Topics> topicsfrom(json) =>
    List.from(json).map((e) => Topics.fromJson(e)).toList();
List<Map<String, dynamic>> topicsto(List<Topics> subj) =>
    subj.map((e) => e.toJson()).toList();

class Topics {
  Topics({
    required this.topic,
    required this.link,
    required this.id,
    required this.file,
  });
  late final String topic;
  late final String link;
  late final String id;
  late final FileClass file;

  Topics.fromJson(Map<String, dynamic> json) {
    topic = json['name'];
    link = json['youtubeLink'];
    id = json['_id'];
    file = FileClass.fromJson(json['file']);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['name'] = topic;
    _data['youtubeLink'] = link;
    _data['_id'] = id;
    _data['file'] = file.toJson();
    return _data;
  }
}

//PDF File Modal Class
class FileClass {
  FileClass({
    required this.name,
    required this.url,
    this.id = '',
  });

  final String name;
  final String url;
  final String id;

  FileClass copyWith({
    String? name,
    String? url,
  }) =>
      FileClass(
        name: name ?? this.name,
        url: url ?? this.url,
      );

  factory FileClass.fromJson(Map<String, dynamic> json) => FileClass(
        name: json["name"],
        url: json["url"],
        id: json["_id"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "url": url,
        "_id": url,
      };
}
