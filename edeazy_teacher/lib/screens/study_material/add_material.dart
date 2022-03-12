import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:edeazy_teacher/controller/teach_add_material_controller.dart';
import 'package:edeazy_teacher/modals/teacher_studymodal.dart';
import 'package:edeazy_teacher/screens/study_material/pdf_preview.dart';
import 'package:url_launcher/url_launcher.dart';

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
  final linkController = TextEditingController();
  final formkey = GlobalKey<FormState>();
  bool s = false;

  @override
  void initState() {
    cont.classId(data['classId']);
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
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
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
                      return null;
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
            const SizedBox(height: 10),
            if(cont.type.value == "Notes")
                  TextFormField(
                    autofocus: false,
                    maxLength: 50,
                    maxLines: null,
                    style: Theme.of(context)
                        .textTheme
                        .headline2!
                        .copyWith(color: Colors.black54),
                    decoration: InputDecoration(
                      fillColor: Colors.grey[200],
                      filled: true,
                      hintText: 'Paste your Youtube Link Here',
                      hintStyle: const TextStyle(color: Colors.black45),
                      border: const OutlineInputBorder(),
                    ),
                    onTap: () async {
                      if(await canLaunch('https://us05web.zoom.us/j/88357630580?pwd=S2QyZFFVR0dqN3RpcVg1TlhiTlVQUT09')){
                        await launch('https://us05web.zoom.us/j/88357630580?pwd=S2QyZFFVR0dqN3RpcVg1TlhiTlVQUT09',
                                    forceSafariVC:false,
                                    forceWebView: true,
                                    enableJavaScript: true
                        );
                      }
                    },
                    controller: linkController,
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
                      margin: const EdgeInsets.all(20),
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          InkWell(
                            onTap: () {
                              Get.toNamed(
                                'pdfView',
                                arguments: FileClass(
                                    name: cont.file['name'],
                                    url: cont.file['url'],
                                    id: cont.file['id']),
                              );
                            },
                            child: PdfPreview(
                              name: cont.file['name'],
                              url: cont.file['url'],
                            ),
                          ),
                          Positioned(
                            top: -24,
                            right: -24,
                            child: IconButton(
                              onPressed: () {
                                cont.deletefile();
                              },
                              iconSize: 40,
                              icon: const Icon(
                                Icons.cancel_rounded,
                                color: Colors.redAccent,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                  if (cont.loadingProgress.value < 100) {
                    debugPrint('in progress --> ${cont.loadingProgress.value}');
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
                  return Column(
                    children: [
                      TextButton.icon(
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
                      ),
                    ],
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
                            if (!formkey.currentState!.validate()) {
                            } else if (cont.type.value == 'Notes') {
                              cont.postNotes(
                                chapname: chaptercontroller.text,
                                chapno: chapterNoController.text,
                                topic: discriptioncontroller.text,
                                link:linkController.text,
                              );
                            } else if (cont.type.value == 'Assignment' ||
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
