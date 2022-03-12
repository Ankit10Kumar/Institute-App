// ignore_for_file: avoid_unnecessary_containers, prefer_const_constructors_in_immutables, prefer_const_constructors, prefer_final_fields

import 'package:edeazy_teacher/modals/teacher_studymodal.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:edeazy_teacher/controller/teacher_study_material_controller.dart';
import 'package:edeazy_teacher/coustom/colorScheme.dart';
import 'package:edeazy_teacher/screens/study_material/secondary_material.dart';

import 'notes_page.dart';

class StudyChapters extends StatefulWidget {
  const StudyChapters({Key? key}) : super(key: key);

  @override
  State<StudyChapters> createState() => _StudyChaptersState();
}

class _StudyChaptersState extends State<StudyChapters>
    with SingleTickerProviderStateMixin {
  var controller = Get.put(StudyController());
  List<Subject> subjects = Get.arguments ?? [];
  final List<String> type = <String>['Notes', 'Assignment', 'Sample_Paper'];
  String mat = 'Notes';
  late TabController tabController;
  @override
  void initState() {
    super.initState();
    tabController = TabController(length: type.length, vsync: this);
    tabController.addListener(() {
      if (tabController.indexIsChanging) {
        switch (tabController.index) {
          case 0:
            mat = 'Notes';
            break;
          case 1:
            mat = 'Assignment';
            break;
          case 2:
            mat = 'Sample_Paper';
            break;
        }
      }
    });
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            Get.toNamed('/addmaterial', arguments: {
              'type': mat,
              'class': controller.clas.value,
              'classId':controller.classId.value,
              'subject': controller.subjects
            });
          },
          label: Text('Upload'),
          icon: Icon(CupertinoIcons.add),
        ),
        appBar: AppBar(
          actions: [
            PopupMenuButton(
              // onSelected: (String s) {
              //   controller.subjects(s);
              // },
              itemBuilder: (_) {
                return subjects.map((e) {
                  return PopupMenuItem(
                    onTap: () {
                      setState(() {
                        controller.name(e.name);
                        controller.classId(e.classId);
                      });
                      
                    },
                    value: e.name,
                    child:
                        Text('${e.name} Batch${e.batch}', style: Theme.of(context).textTheme.headline4),
                  );
                }).toList();
              },
            )
          ],
          title: Text(
            controller.name.value,
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: Column(
          children: [
            Container(
              margin: const EdgeInsets.fromLTRB(10, 30, 10, 5),
              height: 45,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(
                  25.0,
                ),
              ),
              child: TabBar(
                controller: tabController,
                // isScrollable: true,
                indicator: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                    25.0,
                  ),
                  color: cardcolor,
                ),
                labelColor: Colors.white,
                unselectedLabelColor: Colors.black,
                tabs: const [
                  Tab(
                    text: 'Notes',
                  ),
                  Tab(
                    text: 'Assignment',
                  ),
                  Tab(
                    text: 'Sample_Paper',
                  ),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                physics: NeverScrollableScrollPhysics(),
                children: [
                  TeacherNotes(),
                  SecondaryMaterial(mat: 'Assignment'),
                  SecondaryMaterial(mat: 'Sample_Paper'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
