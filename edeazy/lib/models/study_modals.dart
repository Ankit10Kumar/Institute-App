//Modals for Student Subjects
List<SubjData> subjfromjason(json) =>
    List.from(json).map((e) => SubjData.fromJson(e)).toList();
List<Map<String, dynamic>> subjtojson(List<SubjData> subj) =>
    subj.map((e) => e.toJson()).toList();

class SubjData {
  String classId;
  int batch;
  String subject;
  String? teacher;
  SubjData({
    required this.classId,
    required this.batch,
    required this.subject,
    this.teacher,
  });

  factory SubjData.fromJson(Map<String, dynamic> json) => SubjData(
        classId: json['classId'],
        batch: json['batch'],
        subject: json['name'],
        teacher: json['teacher'],
      );

  Map<String, dynamic> toJson() => {
        'classId': classId,
        'batch': batch,
        'teacher': teacher,
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
    required this.id,
    required this.file,
  });
  late final String topic;
  late final String id;
  late final FileClass file;

  Topics.fromJson(Map<String, dynamic> json) {
    topic = json['name'];
    id = json['_id'];
    file = FileClass.fromJson(json['file']);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['name'] = topic;
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
  });

  final String name;
  final String url;

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
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "url": url,
      };
}

class ScreenArguments {
  final String? title;
  final String? id;

  ScreenArguments({this.title, this.id});
}
