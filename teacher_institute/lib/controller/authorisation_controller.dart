import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:teacher_institute/modals/aothorised_modal.dart';
import 'package:teacher_institute/services/login_service.dart';

class AuthrisationController extends GetxController {
  final g = GetStorage();
  var isLoading = true.obs;
  var url = ''.obs;

  @override
  void onInit() {
    String d = g.read('token') ?? '';
    if (d.isNotEmpty) {
      refreshProfile();
      url(g.read('url') ?? '');
    }
    super.onInit();
  }

  void dialog() {
    Get.dialog(
      const Center(
        child: CircularProgressIndicator(),
      ),
      barrierDismissible: false,
    );
  }
  void toast({String title ='Error',String message ='Something Went wrong'}){
    Get.snackbar(
        title,
        message,colorText:Colors.white,
        maxWidth:double.maxFinite,
        margin:const EdgeInsets.all(0),
        isDismissible: true,
        snackPosition: SnackPosition.BOTTOM,
        dismissDirection: SnackDismissDirection.HORIZONTAL,
      );
  }

  Future<void> login({required String number, required String password}) async {
    try {
      dialog();
      var data = await LoginServices.login(num: number, password: password);
      refreshUser(data: data);
      // Get.back();
      Get.offAllNamed('/homepage');
    } catch (e) {
      Get.back();
      toast(message: e.toString());
    }
  }

  void updateUserData(String mail, String add,String gen) async {
    try {
      var t = g.read('token') ?? '';
      var i = g.read('id') ?? '';
      dialog();
      var data = await LoginServices.updateProfileData(
          token: t, id: i, mail: mail, add: add,gen: gen);
      refreshUser(data: data);
      Get.back();
      Get.snackbar(
        'Profile Updated Successfully',
        '',
        isDismissible: true,
        snackPosition: SnackPosition.BOTTOM,
        dismissDirection: SnackDismissDirection.HORIZONTAL,
      );
    } catch (e) {
      Get.back();
      toast(message: e.toString());
    }
  }

  void refreshProfile() async {
    try {
      isLoading(true);
      UserData data = await LoginServices.fetchProfile(g.read('token') ?? '');
      refreshUser(data: data);
      isLoading(false);
    } catch (e) {
      isLoading(false);
      Get.dialog(AlertDialog(
        title: const Text(
          'Error',
          style: TextStyle(color: Colors.black),
        ),
        content:
            Text(e.toString(), style: const TextStyle(color: Colors.black)),
        actions: [
          TextButton(
              onPressed: () {
                g.erase();
                Get.toNamed('/login');
              },
              child: const Text('Login Again'))
        ],
      ));
    }
  }

  void uploadImage(File image, String type) async {
    try {
      dialog();
      var d = await LoginServices.upload(
        imageFile: image.path,
        token: g.read('token'),
        type: type,
      );
      url(d);
      g.write('url', d);
      Get.back();
    } catch (e) {
      Get.back();
      toast(message: e.toString());
    }
  }

  void refreshUser({required UserData data}) {
    g.write('token', data.token);
    g.write('name', data.name);
    g.write('url', data.url);
    g.write('email', data.email);
    g.write('phone', data.phoneNumber.toString());
    g.write('address', data.address);
    g.write('id', data.id);
    g.write('gender', data.gender);
  }

  String userinfo({required String key}) {
    final data = g.read(key);
    return data ?? '';
  }

  void removeUser() async {
    g.erase();
  }
}