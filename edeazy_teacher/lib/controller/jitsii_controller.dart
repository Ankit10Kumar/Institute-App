import 'package:edeazy_teacher/modals/jitsii_modal.dart';
import 'package:edeazy_teacher/services/services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class Jitsiicontroller extends GetxController{
  var g = GetStorage();
  var token =''.obs;
   @override
  void onInit() {
    token(g.read('token') ?? '');
    fetchclass();
    super.onInit();
  }

  void toast(
      {String title = 'Error', String message = 'Something Went Wrong'}) {
    Get.snackbar(
      title,
      message,
      isDismissible: true,
      colorText: Colors.black,
      maxWidth: double.maxFinite,
      margin: const EdgeInsets.all(0),
      snackPosition: SnackPosition.BOTTOM,
      dismissDirection: DismissDirection.horizontal,
    );
  }

  // Get CLass details of Teacher
  var classlist = <Jitsii>[].obs;
  var loadingClass = true.obs;

  void fetchclass() async {
    loadingClass(true);
    try {
      var s = await Services.fetchClass(token: token.value);
      classlist(s);
      loadingClass(false);
    } catch (e) {
      loadingClass(false);
      toast(message: e.toString());
    }
  }
}