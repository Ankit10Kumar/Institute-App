// ignore_for_file: prefer_const_constructors, curly_braces_in_flow_control_structures, unrelated_type_equality_checks, avoid_print

import 'package:edeazy_teacher/modals/teacher_studymodal.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:edeazy_teacher/controller/teach_event_controller.dart';

// import '../controller/teacher_study_material_controller.dart';

class AddEvent extends StatefulWidget {
  const AddEvent({Key? key}) : super(key: key);

  @override
  State<AddEvent> createState() => _AddEventState();
}

class _AddEventState extends State<AddEvent> {
  //  Event? even;
  final controll = Get.put(EventController());
  // final g = Get.put(StudyController());

  final titlecontroller = TextEditingController();
  final discriptioncontroller = TextEditingController();
  late DateTime fromDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();
  TimeOfDay selectedTime2 = TimeOfDay.now();
  final formkey = GlobalKey<FormState>();
  late DateTime toDate = DateTime.now();
  late List<String?> lectureId;
  late List<bool> isSelect;
  late List<bool> isbatch;
  List<Subject>subjects = [];
  @override
  void initState() {
    isSelect = List.filled(controll.classlist.length, false);
    isbatch  = List.filled(subjects.length, false);
    super.initState();
  }

  @override
  void dispose() {
    titlecontroller.dispose();
    discriptioncontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Add Event'),
      ),
      body: Form(
        key: formkey,
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 30),
          children: [
            TextFormField(
              style: TextStyle(fontSize: 20),
              decoration: InputDecoration(
                fillColor: Colors.grey[200],
                filled: true,
                hintText: 'Create Event ',
                hintStyle: const TextStyle(color: Colors.black45),
                border: const UnderlineInputBorder(),
              ),
              onFieldSubmitted: (_) {},
              validator: (title) => title != null && title.isEmpty
                  ? 'Title should not be empty'
                  : null,
              controller: titlecontroller,
            ),
            SizedBox(height: 20),
            Text(
              'Choose Class',
              style: Theme.of(context).textTheme.headline3,
            ),
            Container(
              height: 50,
              padding: const EdgeInsets.all(6),
              child: ListView.builder(
                itemBuilder: (context, item) {
                  // clas.add(g.classlist[item].subjects[item].batch);
                  return Padding(
                    padding: const EdgeInsets.only(left: 5.0, right: 5),
                    child: FilterChip(
                      selected:isSelect[item],
                      checkmarkColor: Colors.white,
                      selectedColor: Colors.greenAccent,
                      labelStyle: TextStyle(
                        color: Colors.white,
                        fontSize:
                            Theme.of(context).textTheme.headline3!.fontSize,
                        fontWeight:
                            Theme.of(context).textTheme.headline3!.fontWeight,
                      ),
                      label: Text(
                        '${controll.classlist[item].teacherClass}th ${controll.classlist[item].stream}',
                      ),
                      onSelected: (value) {
                        setState(() {
                          isSelect[item] = value;
                          subjects.addAllIf(value, controll.classlist[item].subjects);
                          if(!value){
                            subjects = List.from(subjects.toSet().difference(controll.classlist[item].subjects.toSet()));
                          }
                          isbatch = List.filled(subjects.length, false);
                        });
                      },
                    ),
                  );
                },
                itemCount: controll.classlist.length,
                scrollDirection: Axis.horizontal,
              ),
            ),
             SizedBox(height: 20),
            Text(
              'Choose Batch',
              style: Theme.of(context).textTheme.headline3,
            ),
            (subjects.isNotEmpty)?
            Container(
              height: 50,
              padding: const EdgeInsets.all(6),
              child: ListView.builder(
                itemBuilder: (context, item) {
                  
                  return Padding(
                    padding: const EdgeInsets.only(left: 5.0, right: 5),
                    child: FilterChip(
                      selected:isbatch[item],
                      checkmarkColor: Colors.white,
                      selectedColor: Colors.greenAccent,
                      labelStyle: TextStyle(
                        color: Colors.white,
                        fontSize:
                            Theme.of(context).textTheme.headline3!.fontSize,
                        fontWeight:
                            Theme.of(context).textTheme.headline3!.fontWeight,
                      ),
                      label: Text(
                        'Batch ${subjects[item].batch} ${subjects[item].name}',
                      ),
                      onSelected: (value) {
                        setState(() {
                          isbatch[item] = value;
                          if(value)
                          lectureId = [subjects[item].lectureId];
                        });
                      },
                    ),
                  );
                },
                itemCount: subjects.length,
                scrollDirection: Axis.horizontal,
              ),
            ) : Container(),
            SizedBox(height: 20),
            Text(
              'Choose Start Date and Time',
              style: Theme.of(context).textTheme.headline3,
            ),
            SizedBox(height: 15),
            Row(
              children: [
                Expanded(
                  child: ListTile(
                    tileColor: Colors.blue[50],
                    title: Text(
                      DateFormat('EEE, MMM d, ').format(fromDate),
                      style: Theme.of(context).textTheme.headline3,
                    ),
                    trailing: Icon(Icons.arrow_drop_down),
                    onTap: () => _selectDate(context),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: ListTile(
                    tileColor: Colors.blue[50],
                    title: Text(selectedTime.format(context),
                        style: Theme.of(context).textTheme.headline3),
                    trailing: Icon(Icons.arrow_drop_down),
                    onTap: () => _selectTime(context),
                  ),
                )
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              'Choose End Date and Time',
              style: Theme.of(context).textTheme.headline3,
            ),
            SizedBox(height: 15),
            Row(
              children: [
                Expanded(
                  child: ListTile(
                    tileColor: Colors.blue[50],
                    title: Text(
                      DateFormat('EEE, MMM d, ').format(toDate),
                      style: Theme.of(context).textTheme.headline3,
                    ),
                    trailing: Icon(Icons.arrow_drop_down),
                    onTap: () => _selectDate2(context),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: ListTile(
                    tileColor: Colors.blue[50],
                    title: Text(
                      selectedTime2.format(context),
                      style: Theme.of(context).textTheme.headline3,
                    ),
                    trailing: Icon(Icons.arrow_drop_down),
                    onTap: () => _selectTime1(context),
                  ),
                )
              ],
            ),
            SizedBox(
              height: 20,
            ),
            TextFormField(
              minLines: 1,
              maxLines: 5,
              maxLength: 200,
              style: TextStyle(fontSize: 14),
              decoration: InputDecoration(
                fillColor: Colors.grey[200],
                filled: true,
                hintText: 'Description ',
                hintStyle: const TextStyle(color: Colors.black45),
                border: const UnderlineInputBorder(),
              ),
              onFieldSubmitted: (_) {},
              controller: discriptioncontroller,
            ),
            SizedBox(
              height: 20,
            ),
            TextButton.icon(
              style: TextButton.styleFrom(
                minimumSize: Size(150, 50),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
                padding: EdgeInsets.symmetric(vertical: 20),
                backgroundColor: Colors.blue,
                primary: Colors.white,
              ),
              onPressed: () {
                if (formkey.currentState!.validate()) {
                  final dt = DateTime(fromDate.year, fromDate.month,
                      fromDate.day, selectedTime.hour, selectedTime.minute);
                  final dt1 = DateTime(toDate.year, toDate.month, toDate.day,
                      selectedTime2.hour, selectedTime2.minute);
                      print(dt);
                  setState(() {
                    // filter = isSelect.asMap().entries.map((e) {
                    //   if (e.value) return clas[e.key].replaceAll('th', '');
                    // }).toList();
                    // filter.removeWhere((element) => element == null);
                  });
                  controll.postEventdata(
                      classes: lectureId,
                      description: discriptioncontroller.text,
                      start: dt,
                      end: dt1,
                      title: titlecontroller.text);
                }
              },
              icon: Icon(Icons.add),
              label: Text('Add Event'),
            )
          ],
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: fromDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year, DateTime.now().month + 3, 0),
    );
    if (picked != null && picked != fromDate)
      setState(() {
        fromDate = picked;
      });
  }

  Future<void> _selectDate2(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: toDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year, DateTime.now().month + 3, 0),
    );
    if (picked != null && picked != toDate)
      setState(() {
        toDate = picked;
      });
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? pickedS = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(fromDate),
    );

    if (pickedS != null)
      setState(() {
        selectedTime = pickedS;
      });
  }

  Future<void> _selectTime1(BuildContext context) async {
    final TimeOfDay? pickedS = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(toDate),
    );

    if (pickedS != null)
      setState(() {
        selectedTime2 = pickedS;
      });
  }
}
