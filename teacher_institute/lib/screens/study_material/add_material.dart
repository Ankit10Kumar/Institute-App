import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:teacher_institute/controller/teach_add_material_controller.dart';

class AddMaterial extends StatefulWidget {
  const AddMaterial({Key? key}) : super(key: key);

  @override
  State<AddMaterial> createState() => _AddMaterialState();
}

class _AddMaterialState extends State<AddMaterial> {
  final cont = Get.put(AddMaterialControler());
  final data = Get.arguments ?? {};
  final chaptercontroller = TextEditingController();
  final discriptioncontroller = TextEditingController();
  final chapterNoController = TextEditingController();
  final formkey = GlobalKey();
  bool s = false;

  @override
  void initState() {
    cont.clas(data['class']);
    cont.subject(data['subject']);
    cont.type(data['type']);
    super.initState();
  }

  @override
  void dispose() {
    chaptercontroller.dispose();
    discriptioncontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(cont.type.value),
      ),
      body: Form(
        key: formkey,
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
          children: [
            if (cont.type.value == 'Notes')
              Column(
                children: [
                  TextFormField(
                    autofocus: false,
                    style: Theme.of(context)
                        .textTheme
                        .headline2!
                        .copyWith(color: Colors.black54),
                    decoration: InputDecoration(
                      fillColor: Colors.grey[200],
                      filled: true,
                      hintText: 'Chapter No. eg :- 1 ',
                      hintStyle: const TextStyle(color: Colors.black45),
                      border: const UnderlineInputBorder(),
                    ),
                    onFieldSubmitted: (_) {},
                    maxLength: 3,
                    keyboardType: TextInputType.number,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (v) {
                      if (!GetUtils.isNumericOnly(v ?? '')) {
                        return "Invalid Entry";
                      }
                    },
                    controller: chapterNoController,
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    autofocus: false,
                    validator: (title) => (title != null || title!.isEmpty)
                        ? 'Title should not be empty'
                        : null,
                    maxLength: 50,
                    maxLines: null,
                    style: Theme.of(context)
                        .textTheme
                        .headline2!
                        .copyWith(color: Colors.black54),
                    decoration: InputDecoration(
                      fillColor: Colors.grey[200],
                      filled: true,
                      hintText: ' Chapter Name',
                      hintStyle: const TextStyle(color: Colors.black45),
                      border: const OutlineInputBorder(),
                    ),
                    onFieldSubmitted: (_) {},
                    controller: chaptercontroller,
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            TextFormField(
              autofocus: false,
              validator: (topic) => (topic != null && topic.isEmpty)
                  ? 'Topic Name should not be empty'
                  : null,
              minLines: 1,
              maxLines: 5,
              maxLength: 40,
              style: Theme.of(context)
                  .textTheme
                  .headline2!
                  .copyWith(color: Colors.black54),
              decoration: InputDecoration(
                fillColor: Colors.grey[200],
                filled: true,
                hintText: ' Topic Name',
                hintStyle: const TextStyle(color: Colors.black45),
                border: const OutlineInputBorder(),
              ),
              onFieldSubmitted: (_) {},
              controller: discriptioncontroller,
            ),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Obx(() {
                  if (cont.file.containsKey('id') &&
                      cont.file.containsKey('name') &&
                      cont.file.containsKey('url')) {
                    return Container(
                      padding: const EdgeInsets.all(10),
                      margin: const EdgeInsets.symmetric(vertical: 20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.grey[100],
                        border: Border.all(
                          color: Colors.grey,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            cont.file['name'],
                            style: Theme.of(context).textTheme.headline2,
                          ),
                          IconButton(
                            onPressed: () {
                              cont.deletefile();
                            },
                            icon: const Icon(Icons.cancel_rounded),
                          ),
                        ],
                      ),
                    );
                  }
                  if (cont.loadingProgress.value < 100) {
                    print('in progress --> ${cont.loadingProgress.value}');
                    Container(
                      width: MediaQuery.of(context).size.width * 0.6,
                      color: Colors.green,
                      child: Center(
                        child: CircularProgressIndicator(
                          value: cont.loadingProgress.value,
                        ),
                      ),
                    );
                  }
                  return TextButton.icon(
                    style: TextButton.styleFrom(
                      minimumSize: const Size(150, 50),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30)),
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      backgroundColor: Colors.blue,
                      primary: Colors.white,
                    ),
                    onPressed: () async {
                      final result = await FilePicker.platform.pickFiles();
                      if (result == null) {
                        return;
                      } else if (result.files.first.path == null) {
                        return;
                      }
                      final file = result.files.first;
                      cont.postFile(
                        name: file.name,
                        path: file.path ?? '',
                      );
                    },
                    icon: const Icon(Icons.upload_rounded),
                    label: const Text('Choose File'),
                  );
                }),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Obx(() {
                  return TextButton.icon(
                    style: TextButton.styleFrom(
                      minimumSize: const Size(150, 50),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30)),
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      backgroundColor: Colors.blue,
                      primary: Colors.white,
                    ),
                    onPressed: (!cont.file.isNotEmpty)
                        ? null
                        : () {
                            if (cont.type.value == 'Notes') {
                              cont.postNotes(
                                chapname: chaptercontroller.text,
                                chapno: chapterNoController.text,
                                topic: discriptioncontroller.text,
                              );
                            }
                            if (cont.type.value == 'Assignment' ||
                                cont.type.value == 'Sample Paper') {
                              cont.postSecondaryMaterial(
                                topic: discriptioncontroller.text,
                              );
                            }
                          },
                    label: const Text('Add Material'),
                    icon: const Icon(Icons.arrow_forward_rounded),
                  );
                }),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
