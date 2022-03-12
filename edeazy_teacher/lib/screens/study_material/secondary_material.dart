// ignore_for_file: prefer_const_constructors_in_immutables, prefer_const_constructors, avoid_unnecessary_containers

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:edeazy_teacher/controller/teacher_study_material_controller.dart';
import 'package:edeazy_teacher/coustom/customeWidgets.dart';
import 'package:edeazy_teacher/screens/study_material/pdf_preview.dart';

class SecondaryMaterial extends StatefulWidget {
  final String mat;
  SecondaryMaterial({Key? key, required this.mat}) : super(key: key);

  @override
  State<SecondaryMaterial> createState() => _SecondaryMaterialState();
}

class _SecondaryMaterialState extends State<SecondaryMaterial> {
  final cont = Get.put(StudyController());
  @override
  Widget build(BuildContext context) {
    return GetBuilder<StudyController>(
      init: cont,
      initState: (c) {
        cont.fetchSecondaryMaterial(widget.mat);
      },
      builder: (controller) {
        if ((widget.mat == 'Assignment')
            ? cont.loadingAss.value
            : cont.loadingSample.value) {
          return const Center(
              child: CustomeLoading(
            color: Colors.blueAccent,
          ));
        } else if ((widget.mat == 'Assignment')
            ? cont.assignment.isNotEmpty
            : cont.samplePapers.isNotEmpty) {
          return GridView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: (widget.mat == 'Assignment')
                ? cont.assignment.length
                : cont.samplePapers.length,
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
                  Get.toNamed(
                    'pdfView',
                    arguments: (widget.mat == 'Assignment')
                        ? cont.assignment[item].file
                        : cont.samplePapers[item].file,
                  );
                },
                child: PdfPreview(
                  name: (widget.mat == 'Assignment')
                      ? cont.assignment[item].topic
                      : cont.samplePapers[item].topic,
                  url: (widget.mat == 'Assignment')
                      ? cont.assignment[item].file.url
                      : cont.samplePapers[item].file.url,
                ),
              );
            },
          );
        }
        return Center(
          child: Text(
            'No ${widget.mat}',
            style: Theme.of(context).textTheme.headline2,
          ),
        );
      },
    );
  }
}
