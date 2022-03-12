import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:edeazy_teacher/controller/teacher_study_material_controller.dart';
import 'package:edeazy_teacher/coustom/colorScheme.dart';
import 'package:edeazy_teacher/coustom/customeWidgets.dart';

class TeacherNotes extends StatelessWidget {
  TeacherNotes({Key? key}) : super(key: key);
  final cont = Get.put(StudyController());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<StudyController>(
      init: cont,
      initState: (c) {
        cont.fetchNotes();
      },
      builder: (cont) {
        if (cont.loadingNote.value) {
          return const Center(
              child: CustomeLoading(
            color: Colors.blueAccent,
          ));
        } else if (cont.notes.isNotEmpty) {
          return GridView.builder(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 10,
            ),
            itemCount: cont.notes.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount:
                  MediaQuery.of(context).orientation == Orientation.landscape
                      ? 4
                      : 2,
              crossAxisSpacing: 20,
              mainAxisSpacing: 20,
              childAspectRatio: 3 / 2,
            ),
            itemBuilder: (context, item) {
              return GestureDetector(
                onTap: () {
                  cont.chapterId(cont.notes[item].chapterid);
                  Get.toNamed('/inchapter', arguments: {
                    "chapter": cont.notes[item].chapterName,
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
                                  cont.notes[item].chapterName,
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
                          border: Border.all(
                              color: const Color(0xff75e6da), width: 4),
                        ),
                        child: Text(
                          NumberFormat('00').format(cont.notes[item].chapterNo),
                          style:
                              Theme.of(context).textTheme.headline2!.copyWith(
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
        return Center(
          child: Text(
            'No Notes',
            style: Theme.of(context).textTheme.headline2,
          ),
        );
      },
    );
  }
}
