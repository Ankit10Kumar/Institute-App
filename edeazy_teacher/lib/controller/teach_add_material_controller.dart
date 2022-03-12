import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:edeazy_teacher/coustom/customeWidgets.dart';
import 'package:edeazy_teacher/services/services.dart';

class AddMaterialControler extends GetxController {
  var g = GetStorage();
  var token = ''.obs;
  var classId = ''.obs;
  var type = ''.obs;

  @override
  void onInit() {
    token(g.read('token') ?? 'chutiya');
    super.onInit();
  }

  void dialog() {
    Get.dialog(
      const Center(
        child: CustomeLoading(
          color: Colors.blueAccent,
        ),
      ),
      barrierDismissible: false,
    );
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

//to upload notes

  Future<void> postNotes({
    required String chapno,
    required String chapname,
    required String topic,
    required String link,
  }) async {
    try {
      if (file.isEmpty) {
        throw 'Something Went Wrong try Again';
      }
      dialog();
      await Services.postNotesMaterialtdata(
          fileid: file['id'],
          token: token.value,
          chapname: chapname,
          chapno: chapno,
          topic: topic,
          link:link,
          classId: classId.value);
      Get.back();
      toast(message: 'Added Successfully', title: '');
    } catch (e) {
      Get.back();
      toast(message: e.toString());
    }
  }

//to upload assingnment and sample paper

  Future<void> postSecondaryMaterial({
    required String topic,
  }) async {
    try {
      if (file.isEmpty) {
        throw 'Something Went Wrong try Again';
      }
      dialog();
      await Services.postAssampletMaterialtdata(
          filetype:
              (type.value == 'Sample Paper') ? 'Sample_Paper' : type.value,
          fileid: file['id'],
          token: token.value,
          topicname: topic,
          classId: classId.value);
      Get.back();
      toast(message: '$type Added Successfully', title: '');
    } catch (e) {
      Get.back();
      toast(message: e.toString());
    }
  }

//to upload file

  var loadingProgress = 0.0.obs;
  var file = <String, dynamic>{}.obs;
  Future<void> postFile({
    required String name,
    required String path,
  }) async {
    try {
      if (path.isEmpty) {
        throw 'Cannot Pick File';
      }
      loadingProgress(null);
      final data = await Services.postMatrialFile(
          filename: name,
          token: token.value,
          mattype: (type.value == 'Sample Paper') ? 'Sample_Paper' : type.value,
          filepath: path,
          onProgress: (send, total) {
            loadingProgress((send / total) * 100);
          });
      file(data);
    } catch (e) {
      loadingProgress(null);
      toast(message: e.toString());
    }
  }

// to delete file by id

  Future<void> deletefile() async {
    try {
      if (file.isEmpty) {
        throw 'Something Went Wrong try Again';
      }
      await Services.deleteMatrialfile(token: token.value, fileid: file['id']);
      file({});
      toast(message: 'File has been Deleted', title: '');
    } catch (e) {
      toast(message: e.toString());
    }
  }
}
