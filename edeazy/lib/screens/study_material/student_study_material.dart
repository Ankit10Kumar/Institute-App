import 'package:edeazy/models/study_modals.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:edeazy/controller/study_material_controller.dart';
import 'package:edeazy/custome/colorScheme.dart';
import 'package:edeazy/screens/study_material/notes_page.dart';
import 'package:edeazy/screens/study_material/secondary_material.dart';

class SubjectMaterial extends StatefulWidget {
  const SubjectMaterial({Key? key}) : super(key: key);

  @override
  State<SubjectMaterial> createState() => _SubjectMaterialState();
}

class _SubjectMaterialState extends State<SubjectMaterial> {
  var cont = Get.put(StudyController());
  @override
  Widget build(BuildContext context) {
    final ScreenArguments? args = Get.arguments as ScreenArguments?;
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text((args == null) ? 'Subjects' : args.title ?? 'Subject'),
        ),
        body: Column(
          children: [
            Container(
              margin: const EdgeInsets.fromLTRB(20, 30, 20, 5),
              height: 45,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(
                  25.0,
                ),
              ),
              child: TabBar(
                // dragStartBehavior: DragStartBehavior.down,
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
                    text: 'Sample Papers',
                  ),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  const StudentNotes(),
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
