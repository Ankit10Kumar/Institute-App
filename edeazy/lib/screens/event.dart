// ignore_for_file: prefer_const_constructors, non_constant_identifier_names, avoid_unnecessary_containers

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:edeazy/controller/eventController.dart';
import 'package:edeazy/custome/customeWidgets.dart';
import 'package:edeazy/models/eventModals.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import '../custome/colorScheme.dart';

extension DateOnlyCompare on DateTime {
  bool isSameDate(DateTime other) {
    return year == other.year && month == other.month && day == other.day;
  }
}

class Calender extends StatefulWidget {
  const Calender({Key? key}) : super(key: key);

  @override
  State<Calender> createState() => _CalenderState();
}

class _CalenderState extends State<Calender> {
  late ScrollController scrollController;
  EventController control = Get.put(EventController());
  CalendarFormat format = CalendarFormat.month;
  DateTime focusday = DateTime.now();
  late DateTime selecteday;
  late List<Events> events;

  @override
  void initState() {
    scrollController = ScrollController();
    events = <Events>[];
    selecteday = DateTime.now();
    super.initState();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('Events'),
        centerTitle: true,
      ),
      body: Obx(() {
        if (control.isLoading.value) {
          return CustomeLoading(
            color: Colors.blueAccent,
          );
        }
        events = getListofEvent(selecteday);
        return CustomScrollView(
          controller: scrollController,
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: TableCalendar(
                  eventLoader: (date) {
                    return getListofEvent(date);
                  },
                  startingDayOfWeek: StartingDayOfWeek.monday,
                  firstDay: control.fromDate,
                  lastDay: control.toDate,
                  focusedDay: focusday,
                  formatAnimationDuration: Duration(milliseconds: 300),
                  pageAnimationDuration: Duration(milliseconds: 300),
                  selectedDayPredicate: (d) {
                    return isSameDay(selecteday, d);
                  },
                  onDaySelected: (focus, select) {
                    setState(() {
                      selecteday = select;
                    });
                  },
                  calendarFormat: format,
                  weekendDays: const [7],
                  headerStyle: HeaderStyle(
                    titleTextStyle: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                    ),
                    leftChevronIcon: Icon(
                      Icons.keyboard_arrow_left_rounded,
                      color: Colors.white,
                    ),
                    rightChevronIcon: Icon(
                      Icons.keyboard_arrow_right_rounded,
                      color: Colors.white,
                    ),
                    headerMargin:
                        EdgeInsets.symmetric(vertical: 6, horizontal: 5),
                    decoration: BoxDecoration(
                      color: cardcolor,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.elliptical(20, 20),
                      ),
                    ),
                    titleCentered: true,
                    formatButtonShowsNext: false,
                    formatButtonVisible: false,
                  ),
                  pageAnimationEnabled: true,
                  calendarBuilders:
                      CalendarBuilders(markerBuilder: (_, date, list) {
                    if (list.isNotEmpty) {
                      return Positioned(
                        right: 6,
                        top: 0,
                        child: Container(
                          padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.redAccent,
                          ),
                          child: Text(
                            "${list.length}",
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      );
                    }
                    return null;
                  }),
                  calendarStyle: CalendarStyle(
                    disabledDecoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: const [
                        BoxShadow(
                          blurRadius: 2,
                          color: Colors.black45,
                          offset: Offset(-1, -1),
                        )
                      ],
                    ),
                    defaultTextStyle: TextStyle(color: Colors.black),
                    defaultDecoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: const [
                        BoxShadow(
                          blurRadius: 2,
                          color: Colors.black45,
                          offset: Offset(1, 1),
                        )
                      ],
                    ),
                    todayTextStyle: TextStyle(color: Colors.white),
                    todayDecoration: BoxDecoration(
                      color: Colors.greenAccent,
                      shape: BoxShape.circle,
                      boxShadow: const [
                        BoxShadow(
                          blurRadius: 2,
                          color: Colors.green,
                          offset: Offset(1, 1),
                        )
                      ],
                    ),
                    isTodayHighlighted: true,
                    weekendDecoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: const [
                        BoxShadow(
                          blurRadius: 2,
                          color: Colors.black45,
                          offset: Offset(1, 1),
                        )
                      ],
                    ),
                    weekendTextStyle: TextStyle(color: Colors.redAccent),
                    selectedTextStyle: TextStyle(color: Colors.white),
                    selectedDecoration: BoxDecoration(
                      color: Colors.blue,
                      shape: BoxShape.circle,
                      boxShadow: const [
                        BoxShadow(
                          blurRadius: 2,
                          color: Colors.blue,
                          offset: Offset(1, 1),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, item) {
                  return Card(
                    color: cardcolor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                    elevation: 5,
                    margin: EdgeInsets.all(10),
                    child: Row(
                      children: [
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 20),
                          child: Text(
                            DateFormat('MMM d').format(selecteday),
                            style:
                                Theme.of(context).textTheme.headline2!.copyWith(
                                      color: Colors.white,
                                    ),
                          ),
                          decoration: BoxDecoration(color: cardcolor),
                        ),
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.all(10),
                            color: Colors.white,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  events[item].name ?? 'Event',
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.black,
                                  ),
                                ),
                                SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Text(
                                      DateFormat('EEE, MMM d hh:mm a')
                                          .format(events[item].startTime),
                                      style: TextStyle(
                                        fontSize: 10,
                                        color: Colors.redAccent,
                                      ),
                                    ),
                                    Text(
                                      DateFormat('EEE, MMM d hh:mm a')
                                          .format(events[item].endTime),
                                      style: TextStyle(
                                        fontSize: 10,
                                        color: Colors.redAccent,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 10),
                                Text(
                                  'A Event Presented By Pankaj Rawat And Vohra',
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: Colors.black87,
                                  ),
                                ),
                                SizedBox(height: 10),
                                Text(
                                  'By Anonymus',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.black38,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
                childCount: events.length,
              ),
            ),
            SliverToBoxAdapter(
              child: SizedBox(height: 30),
            )
          ],
        );
      }),
    );
  }

  List<Events> getListofEvent(DateTime date) {
    return control.eventList
        .where((event) => (event.startTime.isSameDate(date) ||
            (event.startTime.isBefore(date) && event.endTime.isAfter(date))))
        .toList();
  }
}
