// ignore_for_file: prefer_const_declarations, prefer_typing_uninitialized_variables

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:edeazy_teacher/modals/jitsii_modal.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mime_type/mime_type.dart';
import 'package:edeazy_teacher/modals/teacher_eventmodal.dart';
import 'package:edeazy_teacher/modals/teacher_studymodal.dart';

typedef ProgressCallback = void Function(int count, int total);

class Services {
  static var client = http.Client();
  static var baseURL = 'https://pure-crag-69424.herokuapp.com/api';

//Service for creating event

  static Future<void> postEvent(
      {required String title,
      required String description,
      required String token,
      required List<String?> classes,
      required DateTime start,
      required DateTime end}) async {
    try {
      final bod = jsonEncode({
        "name": title,
        "class": classes,
        "start": start.toIso8601String(),
        "end": end.toIso8601String(),
        "description": description,
      });

      var response = await http.post(Uri.parse('$baseURL/organisation/events'),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          },
          body: bod);
      final resString = jsonDecode(response.body);
      if (resString['success'] ?? false) {
        return;
      }
      throw resString['error']['message'] ?? 'No Data';
    } on TimeoutException {
      throw 'API not Responding';
    } on SocketException {
      throw 'Can\'t connect to API';
    }
  }

//to fetch data of events

  static Future<Map<String, List<Events>>> fetchEvent(
      {required String token, required int from, required int to}) async {
    try {
      var res = await client.get(
          Uri.parse("$baseURL/events?fromDate=$from&toDate=$to"),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          }).timeout(const Duration(seconds: 10));
      var data = jsonDecode(res.body);
      if (data['success']) {
        return eventsFromJson(data['data']);
      }
      throw data['error']['message'] ?? 'No data';
    } on TimeoutException {
      throw 'Api Not Responding';
    } on SocketException {
      throw 'Can\'t Connect to API';
    }
  }

//to fetch data of classes and subjects of teacher

  static Future<List<Teacher>> fetchclassmaterial(
      {required String token}) async {
    try {
      var response = await http.get(
        Uri.parse('$baseURL/organisation/lectures/user-subjects'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      final resString = jsonDecode(response.body);
      if (resString['success'] ?? false) {
        print(resString['data']);
        return teacherclasfrom(resString['data']);
      }
      throw resString['error']['message'] ?? 'No Data';
    } on TimeoutException {
      throw 'API not Responding';
    } on SocketException {
      throw 'Can\'t connect to API';
    }
  }

// For Creating Notes

  static Future<void> postNotesMaterialtdata({
    required String fileid,
    required String token,
    required String classId,
    String? link,
    String? chapno,
    String? chapname,
    required String topic,
  }) async {
    try {
      final bod = jsonEncode({
        "chapterNumber": chapno,
        "classId": classId,
        "chapterName": chapname,
        "topic": {
          "name": topic,
          "file": fileid,
          "youtubeLink":link,
        }
      });

      var response = await http.post(Uri.parse('$baseURL/study/notes/chapters'),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          },
          body: bod);
      final resString = jsonDecode(response.body);
      if (resString['success'] ?? false) {
        return;
      }
      throw resString['error']['message'] ?? 'No Data';
    } on TimeoutException {
      throw 'API not Responding';
    } on SocketException {
      throw 'Can\'t connect to API';
    }
  }

// API for Fetching Notes of subjects

  static Future<List<Notes>> fetchNotes(
      {required String token,
      required String classId,}) async {
    try {
      var res = await client.get(
          Uri.parse("$baseURL/study/notes/$classId/chapters"),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          }).timeout(const Duration(seconds: 10));
      var data = jsonDecode(res.body);
      if (data['success']) {
        return notesfrom(data['data']);
      }
      throw data['error']['message'] ?? 'No data';
    } on TimeoutException {
      throw 'Api Not Responding';
    } on SocketException {
      throw 'Can\'t Connect to API';
    }
  }

//For Creating Secondary Material

  static Future<void> postAssampletMaterialtdata({
    required String filetype,
    required String classId,
    required String fileid,
    required String token,
    required String topicname,
  }) async {
    try {
      final bod = jsonEncode({
        "type": filetype,
        "file": fileid,
        "name": topicname,
        "classId": classId,
      });

      var response =
          await http.post(Uri.parse('$baseURL/study/secondary-material/$classId?type=$filetype'),
              headers: {
                'Content-Type': 'application/json',
                'Accept': 'application/json',
                'Authorization': 'Bearer $token',
              },
              body: bod);
      final resString = jsonDecode(response.body);
      if (resString['success'] ?? false) {
        return;
      }
      throw resString['error']['message'] ?? 'No Data';
    } on TimeoutException {
      throw 'API not Responding';
    } on SocketException {
      throw 'Can\'t connect to API';
    }
  }

// API for Fetching Assignments/Sample_Papers

  static Future<List<SecondaryMatModal>> fetchWork({
    required String token,
    required String classId,
    required String smat,
  }) async {
    try {
      var res = await client.get(
          Uri.parse("$baseURL/study/secondary-material/$classId/?type=$smat"),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          }).timeout(const Duration(seconds: 10));
      var data = jsonDecode(res.body);
      if (data['success']) {
        return secmatfrom(data['data']);
      }
      throw data['error']['message'] ?? 'No data';
    } on TimeoutException {
      throw 'Api Not Responding';
    } on SocketException {
      throw 'Can\'t Connect to API';
    }
  }

//API for Fetching Topics Of Chapters

  static Future<List<Topics>> fetchTopics({
    required String token,
    required String chapterid,
  }) async {
    try {
      var res = await client
          .get(Uri.parse("$baseURL/study/notes/$chapterid/topics"), headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      }).timeout(const Duration(seconds: 10));
      var data = jsonDecode(res.body);
      debugPrint(data);
      if (data['success']) {
        return topicsfrom(data['data']);
      }
      throw data['error']['message'] ?? 'No data';
    } on TimeoutException {
      throw 'Api Not Responding';
    } on SocketException {
      throw 'Can\'t Connect to API';
    }
  }

//Service For Material file upload

  static Future<Map<String, dynamic>> postMatrialFile({
    required String filename,
    required String mattype,
    required String token,
    required String filepath,
    required ProgressCallback? onProgress,
  }) async {
    try {
      String? mimetype = mime(filepath);
      var dio = Dio();
      Map<String, String> headers = {"Authorization": 'Bearer $token'};
      FormData formdata = FormData.fromMap({
        'file': await MultipartFile.fromFile(
          filepath,
          contentType:
              MediaType(mimetype!.split('/').first, mimetype.split('/').last),
        ),
        'name': filename,
        'type': mattype,
      });

      var response = await dio.post('$baseURL/file/upload-study-materials',
          options: Options(headers: headers),
          data: formdata,
          onSendProgress: onProgress);
      var data = response.data;
      if (data['success'] ?? false) {
        final file = FileClass.fromJson(data['data']);
        return {'id': file.id, 'name': file.name, 'url': file.url};
      }
      throw data['error']['message'] ?? 'No Data';
    } on TimeoutException {
      throw 'API not Responding';
    } on SocketException {
      throw 'Can\'t connect to API';
    }
  }

//Service to delete a Matrial file

  static Future<void> deleteMatrialfile(
      {required String token, required String fileid}) async {
    try {
      var response = await http.delete(
        Uri.parse('$baseURL/file/study-material/$fileid'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      ).timeout(const Duration(seconds: 10));
      final resString = jsonDecode(response.body);
      debugPrint(resString);
      if (resString['success'] ?? false) {
        return;
      }
      throw resString['error']['message'] ?? 'No Data';
    } on TimeoutException {
      throw 'API not Responding';
    } on SocketException {
      throw 'Can\'t connect to API';
    }
  }
 // for jitsii classes
 
  static Future<List<Jitsii>> fetchClass(
      {required String token}) async { 
    try {
      var response = await http.get(
        Uri.parse('$baseURL/users/upcoming-lectures'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      final resString = jsonDecode(response.body);
      if (resString['success'] ?? false) {
        return jitsiiclassfrom(resString['data']);
      }
      throw resString['error']['message'] ?? 'No Data';
    } on TimeoutException {
      throw 'API not Responding';
    } on SocketException {
      throw 'Can\'t connect to API';
    }
  } 
}
