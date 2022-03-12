// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:edeazy/models/eventModals.dart';

import '../services/services.dart';

class EventController extends GetxController {
  final s = GetStorage();
  @override
  void onInit() {
    fetchEvent();
    super.onInit();
  }

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

  var isLoading = true.obs;
  var eventList = <Events>[].obs;
  var fromDate = DateTime(DateTime.now().year, DateTime.now().month);
  var toDate = DateTime(DateTime.now().year, DateTime.now().month + 2, 0);
  void fetchEvent() async {
    try {
      isLoading(true);
      var data = await Services.fetchEvent(
        token: s.read('token') ?? '',
        from: fromDate.millisecondsSinceEpoch,
        to: toDate.millisecondsSinceEpoch,
      );
      eventList(data);
      isLoading(false);
    } catch (e) {
      isLoading(false);
    }
    isLoading(false);
  }
}
