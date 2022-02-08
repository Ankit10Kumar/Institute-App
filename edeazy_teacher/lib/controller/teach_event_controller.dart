import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:edeazy_teacher/modals/teacher_eventmodal.dart';
import 'package:edeazy_teacher/services/services.dart';

class EventController extends GetxController {
  var g = GetStorage();
  @override
  void onInit() {
    fetchEvent();
    super.onInit();
  }

  void toast(
      {String title = 'Error', String message = 'Something Went wrong'}) {
    Get.snackbar(
      title,
      message,
      colorText: Colors.black,
      maxWidth: double.maxFinite,
      margin: const EdgeInsets.all(0),
      isDismissible: true,
      snackPosition: SnackPosition.BOTTOM,
      dismissDirection: DismissDirection.horizontal,
    );
  }

  var isLoading = true.obs;
  var eventList = <String, List<Events>>{}.obs;
  var fromDate =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
  var toDate = DateTime(DateTime.now().year, DateTime.now().month + 2, 0);
  void fetchEvent() async {
    try {
      isLoading(true);
      var data = await Services.fetchEvent(
          token: g.read('token') ?? '',
          from: fromDate.millisecondsSinceEpoch,
          to: toDate.millisecondsSinceEpoch);
      eventList(data);
      isLoading(false);
    } catch (e) {
      isLoading(false);
      toast(message: e.toString());
    }
    isLoading(false);
  }

  Future<void> postEventdata(
      {required String title,
      required String description,
      required List<String?> classes,
      required int startDatefromEpoch,
      required int endDatefromEpoch,
      required int startTime,
      required int endTime}) async {
    try {
      isLoading(true);
      var token = g.read('token') ?? '';
      await Services.postEvent(
          title: title,
          description: description,
          classes: classes,
          startDatefromEpoch: startDatefromEpoch,
          endDatefromEpoch: endDatefromEpoch,
          startTime: startTime,
          endTime: endTime,
          token: token);

      fetchEvent();
      isLoading(false);
      toast(message: 'Event Added Successfully', title: '');
    } catch (e) {
      isLoading(false);
      toast(message: e.toString());
    }
  }
}
