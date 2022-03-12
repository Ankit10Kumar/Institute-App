// ignore_for_file: prefer_const_constructors

import 'package:edeazy/custome/colorScheme.dart';
import 'package:edeazy/models/study_modals.dart';
import 'package:edeazy/services/services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:edeazy/controller/study_material_controller.dart';
import 'package:edeazy/custome/customeWidgets.dart';

class StudyMaterial extends StatefulWidget {
  const StudyMaterial({Key? key}) : super(key: key);

  @override
  State<StudyMaterial> createState() => _StudyMaterial();
}

class _StudyMaterial extends State<StudyMaterial> {
  var cont = Get.put(StudyController());
  late ScrollController controller;

  @override
  void initState() {
    controller = ScrollController();
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('Subjects'),
      ),
      body: FutureBuilder<List<SubjData>>(
        initialData: const <SubjData>[],
        future: Services.fetchSubjects(token: cont.token.value),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CustomeLoading(
              color: Colors.blueAccent,
            );
          } else if (snapshot.hasData) {
            if (snapshot.data == null) {
              print('in null');
              return Center(
                child: Text(
                  'No Data',
                  style: Theme.of(context).textTheme.headline2,
                ),
              );
            } else if (snapshot.data!.isEmpty) {
              print('in empty');
              return Center(
                child: Text(
                  'No Data',
                  style: Theme.of(context).textTheme.headline2,
                ),
              );
            }
            return GridView.builder(
              padding: EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 40,
              ),
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
                    cont.classId(cont.subjlist[item].classId);
                    Get.toNamed(
                      '/study',
                      arguments: ScreenArguments(
                        title: cont.subjlist[item].subject,
                      ),
                    );
                  },
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        padding: EdgeInsets.all(10),
                        margin: EdgeInsets.symmetric(vertical: 10),
                        width: size.width * 0.90,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(7),
                          color: cardcolor,
                          // gradient: getGradient(),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                              cont.subjlist[item].subject,
                              style: TextStyle(
                                fontSize: 25,
                                fontWeight: Theme.of(context)
                                    .textTheme
                                    .headline2!
                                    .fontWeight,
                                color: Colors.white,
                              ),
                            ),
                            // SizedBox(height: 20),
                            Text(
                              cont.subjlist[item].teacher ?? 'Anonymus',
                              style: TextStyle(
                                fontSize: Theme.of(context)
                                    .textTheme
                                    .headline4!
                                    .fontSize,
                                fontWeight: Theme.of(context)
                                    .textTheme
                                    .headline4!
                                    .fontWeight,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        left: -5,
                        top: 5,
                        child: Container(
                          padding:
                              EdgeInsets.symmetric(vertical: 3, horizontal: 20),
                          decoration: BoxDecoration(
                              color: Colors.green,
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.black54,
                                  blurRadius: 15.0,
                                  spreadRadius: 3.0,
                                  offset: Offset(10.0, 10.0),
                                ),
                              ],
                              borderRadius: BorderRadius.circular(2)),
                          alignment: Alignment.bottomCenter,
                          child: Text(
                            'Batch ${cont.subjlist[item].batch}',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: Theme.of(context)
                                  .textTheme
                                  .headline2!
                                  .fontWeight,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
              itemCount: cont.subjlist.length,
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.toString()),
            );
          } else {
            return const Center(
              child: Text('Something Went Wrong'),
            );
          }
        },
      ),
    );
  }
}
