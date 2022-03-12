// ignore_for_file: prefer_const_constructors_in_immutables, prefer_const_constructors, avoid_unnecessary_containers

import 'package:edeazy/models/study_modals.dart';
import 'package:edeazy/services/services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:edeazy/controller/study_material_controller.dart';
import 'package:edeazy/custome/customeWidgets.dart';
import 'package:edeazy/screens/study_material/pdf_preview.dart';

class SecondaryMaterial extends StatefulWidget {
  final String mat;
  SecondaryMaterial({Key? key, required this.mat}) : super(key: key);

  @override
  State<SecondaryMaterial> createState() => _SecondaryMaterialState();
}

class _SecondaryMaterialState extends State<SecondaryMaterial>
    with AutomaticKeepAliveClientMixin {
  final cont = Get.put(StudyController());

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    // Size size = MediaQuery.of(context).size;
    return FutureBuilder<List<SecondaryMatModal>>(
      initialData: const <SecondaryMatModal>[],
      future: Services.fetchwork(
          token: cont.token.value,
          classId: cont.classId.value,
          smat: widget.mat),
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
            padding:
                const EdgeInsets.only(top: 00, bottom: 20, left: 20, right: 20),
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
                  Get.toNamed(
                    'pdfView',
                    arguments: snapshot.data![item].file,
                  );
                },
                child: PdfPreview(
                  name: snapshot.data![item].topic,
                  url: snapshot.data![item].file.url,
                ),
              );
            },
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
    );
  }
}

// GetBuilder<StudyController>(
//       init: cont,
//       initState: (c) {
//         cont.fetchSecondaryMaterial(widget.mat);
//       },
//       builder: (controller) {
//         if ((widget.mat == 'Assignment')
//             ? cont.loadingAss.value
//             : cont.loadingSample.value) {
//           return const Center(
//               child: CustomeLoading(
//             color: Colors.blueAccent,
//           ));
//         } else if ((widget.mat == 'Assignment')
//             ? cont.assignment.isNotEmpty
//             : cont.samplePapers.isNotEmpty) {
//           return 
//         }
//         return Center(
//           child: Text(
//             'No Data',
//             style: Theme.of(context).textTheme.headline2,
//           ),
//         );
//       },
//     );