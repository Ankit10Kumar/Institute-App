import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:edeazy_teacher/modals/teacher_studymodal.dart';
import 'package:edeazy_teacher/services/services.dart';

class StudyController extends GetxController {
  var g = GetStorage();
  var token = ''.obs;
  var clas = ''.obs;
  var subjects = <Subject>[].obs;
  var name =''.obs;
  var chapterId = ''.obs;
  var classId = ''.obs;
  var stream = ''.obs;
  @override
  void onInit() {
    token(g.read('token') ?? '');
    fetchMaterial();
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
  var classlist = <Teacher>[].obs;
  var loadingClass = true.obs;

  void fetchMaterial() async {
    loadingClass(true);
    try {
      var s = await Services.fetchclassmaterial(token: token.value);
      classlist(s);
      loadingClass(false);
    } catch (e) {
      loadingClass(false);
      toast(message: e.toString());
    }
  }

//Get Notes of Subjects of Teacher
  var notes = <Notes>[];
  var loadingNote = true.obs;

  void fetchNotes() async {
    loadingNote(true);
    try {
      var n = await Services.fetchNotes(
          token: token.value, classId: classId.value);
      notes = n;
      loadingNote(false);
      update();
    } catch (e) {
      loadingNote(false);
      update();
      toast(message: e.toString());
    }
  }

// Get Secondary Material like Assignments or Sample papers of Teacher
  var assignment = <SecondaryMatModal>[];
  var loadingAss = true.obs;
  var samplePapers = <SecondaryMatModal>[];
  var loadingSample = true.obs;

  void fetchSecondaryMaterial(String smat) async {
    (smat == 'Assignment') ? loadingAss(true) : loadingSample(true);
    try {
      var n = await Services.fetchWork(
          token: token.value,
          classId: classId.value,
          smat: smat);
      if (smat == 'Assignment') {
        assignment = n;
        loadingAss(false);
        update();
      } else if (smat == 'Sample_Paper') {
        samplePapers = n;
        loadingSample(false);
        update();
      }
    } catch (e) {
      (smat == 'Assignment') ? loadingAss(false) : loadingSample(false);
      update();
      toast(message: e.toString());
    }
  }

// Get Topics of Chapters of Teacher selected Subject
  var topics = <Topics>[];
  var loadingTopics = true.obs;

  void fetchTopics() async {
    loadingTopics(true);
    try {
      var n = await Services.fetchTopics(
          token: token.value, chapterid: chapterId.value);
      topics = n;
      loadingTopics(false);
      update();
    } catch (e) {
      loadingTopics(false);
      update();
      toast(message: e.toString());
    }
  }
}
