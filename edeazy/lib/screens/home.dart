// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:camera/camera.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:edeazy/animation/live_card_animation.dart';
import 'package:edeazy/controller/lectures_controller.dart';
import 'package:edeazy/custome/colorScheme.dart';
import 'package:edeazy/models/lecture_modal.dart';
import 'package:edeazy/screens/meeting_page.dart';
import 'package:flutter/material.dart';
import '../custome/customeWidgets.dart';
import 'drawer/custome_drawer.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late Lecture control;
  late ScrollController controller;

  @override
  void initState() {
    control = Lecture();
    controller = ScrollController();
    super.initState();
  }

  @override
  void dispose() {
    control.dispose();
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CustomeDrawer(),
      appBar: AppBar(
        title: Text(
          'Institute',
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(bottom: 10.0, left: 20),
            child: IconButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/notification');
                },
                icon: Icon(Icons.notifications)),
          )
        ],
      ),
      body: StreamBuilder<List<Lectures>>(
        stream: control.todayLectureStream,
        initialData: [],
        builder: (context, lectures) {
          if (lectures.connectionState == ConnectionState.waiting) {
            return CustomeLoading(
              color: Colors.blueAccent,
            );
          } else if (lectures.connectionState == ConnectionState.done ||
              lectures.connectionState == ConnectionState.active) {
            if (lectures.hasError) {
              return Center(
                child: Text(lectures.error.toString()),
              );
            } else if (lectures.hasData) {
              if (lectures.data == null) {
                return Center(
                  child: Text(
                    'Something Went Wrong',
                    style: Theme.of(context).textTheme.headline2,
                  ),
                );
              }
              return CustomScrollView(
                controller: controller,
                slivers: [
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          StreamBuilder<List<Lectures>>(
                            stream: control.liveLectureStream,
                            initialData: [],
                            builder: (context, liveLecturesnap) {
                              if (liveLecturesnap.connectionState ==
                                  ConnectionState.waiting) {
                                return CustomeLoading(
                                  color: Colors.blueAccent,
                                );
                              } else if (liveLecturesnap.connectionState ==
                                      ConnectionState.done ||
                                  liveLecturesnap.connectionState ==
                                      ConnectionState.active) {
                                if (liveLecturesnap.hasError) {
                                  return Center(
                                    child:
                                        Text(liveLecturesnap.error.toString()),
                                  );
                                } else if (liveLecturesnap.hasData) {
                                  if (liveLecturesnap.data == null) {
                                    return Center(
                                      child: Text(
                                        'Something Went Wrong',
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline2,
                                      ),
                                    );
                                  }
                                  if (liveLecturesnap.data!.isEmpty) {
                                    return Container();
                                  }
                                  return Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 20.0, bottom: 20, left: 20),
                                        child: Text(
                                          'Live Now',
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline2!
                                              .copyWith(color: Colors.red),
                                        ),
                                      ),
                                      CarouselSlider.builder(
                                        itemCount: liveLecturesnap.data!.length,
                                        itemBuilder: (context, item, p) {
                                          return myCard(
                                            data: liveLecturesnap.data![item],
                                            canjoin: true,
                                          );
                                        },
                                        options: CarouselOptions(
                                          enableInfiniteScroll: false,
                                          aspectRatio: 7 / 2.5,
                                        ),
                                      ),
                                    ],
                                  );
                                }
                              }
                              return Center(
                                child: Text('Connection-----Error'),
                              );
                            },
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(top: 20.0, bottom: 10),
                            child: Text(
                              'Todays Lectures',
                              style: Theme.of(context).textTheme.headline2,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, item) {
                        return myCard(
                            data: lectures.data![item], canjoin: false);
                      },
                      childCount: lectures.data!.length,
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 30.0),
                    ),
                  )
                ],
              );
            } else {
              return Center(
                child: Text(lectures.error.toString()),
              );
            }
          }
          return Center(
            child: Text('Connection-----Error'),
          );
        },
      ),
    );
  }

  Widget myCard({required Lectures data, required bool canjoin}) {
    return Card(
      elevation: 4,
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      color: cardcolor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          SizedBox(width: 8),
          LiveAnimation(
            minRadius: 23,
            ripplesCount: 15,
            repeat: true,
            color: Colors.redAccent,
            animate: canjoin,
            child: CircleAvatar(
              minRadius: 40,
              maxRadius: 50,
              backgroundImage: Image.asset('images/monkey_profile.jpg').image,
            ),
          ),
          Expanded(
            child: Container(
              margin: EdgeInsets.only(left: 8),
              padding:
                  EdgeInsets.only(top: 15, bottom: 15, left: 10, right: 10),
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(20)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Batch ${data.batch}',
                    style: Theme.of(context).textTheme.headline4,
                  ),
                  SizedBox(height: 10),
                  Text(
                    data.subject,
                    style: Theme.of(context).textTheme.headline3,
                  ),
                  SizedBox(height: 10),
                  Text(
                    'By ${data.teacher ?? '_'}',
                    style: Theme.of(context).textTheme.headline4,
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        data.isLive.toString(),
                        style: Theme.of(context).textTheme.headline5,
                      ),
                      Visibility(
                        visible: canjoin,
                        child: TextButton(
                          style: TextButton.styleFrom(
                              backgroundColor: cardcolor,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20))),
                          onPressed: () async {
                            var cameras = await availableCameras();
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Meeting(
                                  cameras: cameras,
                                ),
                              ),
                            );
                          },
                          child: Text(
                            'Join',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
