import 'package:edeazy/models/study_modals.dart';
import 'package:edeazy/services/app_exception.dart';
import 'package:edeazy/services/services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:edeazy/controller/study_material_controller.dart';
import 'package:edeazy/custome/colorScheme.dart';
import 'package:edeazy/custome/customeWidgets.dart';
import 'package:intl/intl.dart';

class StudentNotes extends StatefulWidget {
  const StudentNotes({Key? key}) : super(key: key);

  @override
  State<StudentNotes> createState() => _StudentNotesState();
}

class _StudentNotesState extends State<StudentNotes>
    with AutomaticKeepAliveClientMixin {
  final cont = Get.put(StudyController());

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Notes>>(
      initialData: const <Notes>[],
      future: Services.fetchNotes(
        token: cont.token.value,
        classId: cont.classId.value,
      ),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CustomeLoading(
            color: Colors.blueAccent,
          );
        } else if (snapshot.hasData) {
          if (snapshot.data == null) {
            return Center(
              child: Text(
                'No Data',
                style: Theme.of(context).textTheme.headline2,
              ),
            );
          } else if (snapshot.data!.isEmpty) {
            return Center(
              child: Text(
                'No Data',
                style: Theme.of(context).textTheme.headline2,
              ),
            );
          }
          return GridView.builder(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 10,
            ),
            itemCount: snapshot.data!.length,
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
                  // cont.chapterId(snapshot.data![item].chapterid);
                  // Get.toNamed('/inchapter', arguments: {
                  //   "chapter": snapshot.data![item].chapterName,
                  // });
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
                              children: [
                                Text(
                                  snapshot.data![item].chapterName,
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
                          NumberFormat('00')
                              .format(snapshot.data![item].chapterNo),
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
        } else if (snapshot.hasError) {
          // var error = 'Something Went Wrong';
          // if (snapshot.error is AppException) {
          //   error = snapshot.error;
          // }
          // print('messg ==> ${error}');
          return Center(
            child: Text(snapshot.error.toString()),
          );
        } else {
          return const Center(
            child: Text('Something Went Wrong'),
          );
        }
      },
    );
  }
}
