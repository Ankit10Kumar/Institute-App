import 'dart:async';
import 'dart:convert';
import 'package:edeazy/models/lecture_modal.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:socket_io_client/socket_io_client.dart' as i_o;
import 'package:get_storage/get_storage.dart';

class Lecture {
  final storage = GetStorage();
  late i_o.Socket socket;
  List<Lectures> liveLectures = <Lectures>[];
  final _todayLectureStreamController = StreamController<List<Lectures>>();
  final _liveLectureStreamController = StreamController<List<Lectures>>();
  // final _eventStreamController = StreamController<String>();

  StreamSink<List<Lectures>> get _todayLectureSink =>
      _todayLectureStreamController.sink;
  Stream<List<Lectures>> get todayLectureStream =>
      _todayLectureStreamController.stream;

  StreamSink<List<Lectures>> get _liveLectureSink =>
      _liveLectureStreamController.sink;
  Stream<List<Lectures>> get liveLectureStream =>
      _liveLectureStreamController.stream;

  void toast(
      {String title = 'Error', String message = 'Something Went Wrong'}) {
    Get.snackbar(
      title,
      message,
      isDismissible: true,
      colorText: Colors.white,
      maxWidth: double.maxFinite,
      margin: const EdgeInsets.all(0),
      snackPosition: SnackPosition.BOTTOM,
      dismissDirection: DismissDirection.horizontal,
    );
  }

  Lecture() {
    debugPrint('in Lecture constructor');
    var payload = storage.read('token');
    socket = i_o.io(
      'http://192.168.1.25:2331',
      {
        'transports': ['websocket'],
        'autoConnect': false,
        'auth': {'token': payload},
      },
    );
    socket.connect();
    socket.onConnect((_) {
      debugPrint('connected to websocket with id $_');
    });
    socket.on('today:lectures', (data) {
      print(data);
      var lectures = <Lectures>[];
      if (data != null) {
        lectures = lecturesFromJson(json.decode(data));
        liveLectures = [
          ...liveLectures,
          ...lectures.where((element) => element.isLive)
        ];
      }
      _todayLectureSink.add(lectures);
      _liveLectureSink.add(liveLectures);
    });
    socket.on('meeting:started', (data) {
      print(data);
      var lecture = Lectures.fromJson(json.decode(data)['lecture']);
      liveLectures.add(lecture);
      _liveLectureSink.add(liveLectures);
    });
    socket.on('meeting:ended', (id) {
      liveLectures.removeWhere((item) => item.id == id);
      _liveLectureSink.add(liveLectures);
    });
    socket.on('handler:error', (error) {
      _todayLectureSink.addError(error['message']);
    });
    socket.onConnectError((err) {
      debugPrint('error ++> $err');
      _todayLectureSink.addError('Connection Error');
    });
    socket.onError((err) {
      debugPrint('onError ++> $err');
      _todayLectureSink.addError(err['message']);
    });
    socket.onConnectTimeout((err) {
      debugPrint('data ==> $err');
      _todayLectureSink.addError('Connection TimeOut, Please Retry');
    });
  }

  void dispose() {
    liveLectures = [];
    debugPrint('In Lecture Dispose');
    _todayLectureStreamController.close();
    socket.dispose();
  }
}
