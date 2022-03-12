// ignore_for_file: prefer_const_constructors, prefer_const_constructors_in_immutables

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:edeazy_teacher/controller/teacher_study_material_controller.dart';
import 'package:edeazy_teacher/coustom/colorScheme.dart';
import 'package:edeazy_teacher/coustom/customeWidgets.dart';

class StudyMaterial extends StatefulWidget {
  StudyMaterial({Key? key}) : super(key: key);

  @override
  State<StudyMaterial> createState() => _StudyMaterial();
}

class _StudyMaterial extends State<StudyMaterial> {
  var g = Get.put(StudyController());
  final controller = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('Classes'),
      ),
      body: Obx(() {
        if (g.loadingClass.value) {
          return Center(
            child: CustomeLoading(
              color: Colors.blueAccent,
            ),
          );
        } else {
          if (g.classlist.isEmpty) {
            return Container(
              alignment: Alignment.center,
              child: Image.asset('images/nodownloads.png'),
              margin: EdgeInsets.only(top: size.height * 0.1),
            );
          }
          return Padding(
            padding: const EdgeInsets.only(top: 15.0),
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: MediaQuery.of(context).orientation ==
                          Orientation.landscape
                      ? 4
                      : 2,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20,
                  childAspectRatio: 3 / 2
                  ),
              itemBuilder: (context, item) {
                return Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: classCard(size, item, context),
                );
              },
              itemCount: g.classlist.length,
            ),
          );
        }
      }),
    );
  }

  GestureDetector classCard(Size size, int item, BuildContext context) {
    return GestureDetector(
      onTap: () {
        g.clas(g.classlist[item].teacherClass);
        g.stream(g.classlist[item].stream); 
        g.subjects(g.classlist[item].subjects);
        g.name(g.classlist[item].subjects[0].name);
        g.classId(g.classlist[item].subjects[0].classId);
        Get.toNamed('/study', arguments: g.classlist[item].subjects);
      },
      child: Container(
        padding: EdgeInsets.all(15),
        margin: EdgeInsets.symmetric(vertical: 10),
        width: size.width * 0.90,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(7),
          gradient: getGradient(),
        ),
        child: Center(
          child: Text(
            'Class ${g.classlist[item].teacherClass}th ${g.classlist[item].stream}',
            style: TextStyle(
              fontSize: 20,
              fontWeight: Theme.of(context).textTheme.headline2!.fontWeight,
              color: bodycolor,
            ),
          ),
        ),
      ),
    );
  }
}

LinearGradient getGradient() {
  final colors = <Color>[
    Color(0xff86E3CE),
    // Color(0xffD0E6A5),
    Color(0xffFFDD94),
    Color(0xffFA8978),
    Color(0xffCCABD8),
    Color(0xff7BDFF2),
    Color(0xffB2F7EF),
    Color(0xffEF77F6),
    Color(0xffF7D6E0),
    Color(0xffF2B5D4),
  ];
  colors.shuffle();
  return LinearGradient(
    colors: [colors[0], colors[1]],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
