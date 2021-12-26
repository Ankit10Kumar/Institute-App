// ignore_for_file: avoid_unnecessary_containers, prefer_const_constructors_in_immutables, prefer_const_constructors, prefer_final_fields

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:teacher_institute/controller/teacher_study_material_controller.dart';
import 'package:teacher_institute/coustom/colorScheme.dart';
import 'package:teacher_institute/coustom/customeWidgets.dart';
import 'package:teacher_institute/modals/teacher_studymodal.dart';
import 'package:teacher_institute/screens/study_material/secondary_material.dart';

class StudyChapters extends StatefulWidget {
  const StudyChapters({Key? key}) : super(key: key);

  @override
  State<StudyChapters> createState() => _StudyChaptersState();
}

class _StudyChaptersState extends State<StudyChapters> {
  var controller = Get.put(StudyController());
  List<String> subjects = Get.arguments ?? [];
  final List<String> type = <String>['Notes', 'Assignment', 'Sample Paper'];
  String mat = 'Notes';
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
              'subject': controller.subject.value
            });
          },
          label: Text('Upload'),
          icon: Icon(CupertinoIcons.add),
        ),
        appBar: AppBar(
          actions: [
            PopupMenuButton(
              // onSelected: (String s) {
              //   controller.subject(s);
              // },
              itemBuilder: (_) {
                return subjects.map((e) {
                  return PopupMenuItem(
                    onTap: () {
                      controller.subject(e);
                    },
                    value: e,
                    child:
                        Text(e, style: Theme.of(context).textTheme.headline4),
                  );
                }).toList();
              },
            )
          ],
          title: Text(
            controller.subject.value,
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: Column(
          children: [
            Container(
              margin: EdgeInsets.fromLTRB(10, 30, 10, 5),
              height: 45,
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(
                  25.0,
                ),
              ),
              child: TabBar(
                // isScrollable: false,
                indicator: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                    25.0,
                  ),
                  color: cardcolor,
                ),
                labelColor: Colors.white,
                unselectedLabelColor: Colors.black,
                onTap: (i) {
                  mat = type[i];
                },
                tabs: List.generate(
                  type.length,
                  (i) => Tab(text: type[i]),
                ),
              ),
            ),
            Expanded(
              child: Obx(() {
                if (controller.subject.isEmpty) {
                  return Center(
                    child: Text(
                      'Unable To Load',
                      style: Theme.of(context).textTheme.headline2,
                    ),
                  );
                }
                return TabBarView(
                  children: [
                    GetBuilder<StudyController>(
                      init: controller,
                      initState: (c) {
                        controller.fetchNotes();
                      },
                      builder: (cont) {
                        if (cont.loadingNote.value) {
                          return const Center(
                              child: CustomeLoading(
                            color: Colors.blueAccent,
                          ));
                        } else if (cont.notes.isEmpty) {
                          return Center(
                            child: Text(
                              'No Data',
                              style: Theme.of(context).textTheme.headline2,
                            ),
                          );
                        }
                        return chapterCard(cont.notes);
                      },
                    ),
                    GetBuilder<StudyController>(
                        init: controller,
                        initState: (c) {
                          controller.fetchSecondaryMaterial('Assignment');
                        },
                        builder: (controller) {
                          if (controller.loadingAss.value) {
                            return const Center(
                                child: CustomeLoading(
                              color: Colors.blueAccent,
                            ));
                          } else if (controller.assignment.isEmpty) {
                            return Center(
                              child: Text(
                                'No Data',
                                style: Theme.of(context).textTheme.headline2,
                              ),
                            );
                          }
                          return SecondaryMaterial(
                            data: controller.assignment,
                          );
                        }),
                    GetBuilder<StudyController>(
                      init: controller,
                      initState: (c) {
                        controller.fetchSecondaryMaterial('Sample_Paper');
                      },
                      builder: (controller) {
                        if (controller.loadingSample.value) {
                          return const Center(
                            child: CustomeLoading(
                              color: Colors.blueAccent,
                            ),
                          );
                        } else if (controller.samplePapers.isEmpty) {
                          return Center(
                            child: Text(
                              'No Data',
                              style: Theme.of(context).textTheme.headline2,
                            ),
                          );
                        }
                        return SecondaryMaterial(
                          data: controller.samplePapers,
                        );
                      },
                    ),
                  ],
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget chapterCard(List<Notes> notelist) {
    return GridView.builder(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 10,
      ),
      itemCount: notelist.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount:
            MediaQuery.of(context).orientation == Orientation.landscape ? 4 : 2,
        crossAxisSpacing: 20,
        mainAxisSpacing: 20,
        childAspectRatio: 3 / 2,
      ),
      itemBuilder: (context, item) {
        return GestureDetector(
          onTap: () {
            controller.chapterId(notelist[item].chapterid);
            Get.toNamed('/inchapter', arguments: {
              "chapter": notelist[item].chapterName,
            });
          },
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                color: cardcolor,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Chapter',
                        style: Theme.of(context)
                            .textTheme
                            .headline2!
                            .copyWith(color: bodycolor),
                      ),
                      Row(
                        // mainAxisSize: ,
                        children: [
                          Text(
                            notelist[item].chapterName,
                            style: Theme.of(context)
                                .textTheme
                                .headline4!
                                .copyWith(color: bodycolor),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
              Positioned(
                top: -10,
                right: -5,
                child: Container(
                  padding: const EdgeInsets.all(5),
                  // (left: 8, right: 5, top: 5, bottom: 5),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    border:
                        Border.all(color: const Color(0xff75e6da), width: 4),
                  ),
                  child: Text(
                    NumberFormat('00').format(notelist[item].chapterNo),
                    style: Theme.of(context).textTheme.headline2!.copyWith(
                          fontSize: 30,
                          color: const Color(0xff05445e),
                        ),
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
