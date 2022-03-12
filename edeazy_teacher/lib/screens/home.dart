// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
// import 'package:imstitute/colorScheme.dart';
// import 'package:socket_io_client/socket_io_client.dart' as IO;

import '../coustom/customeWidgets.dart';
import 'drawer/custome_drawer.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

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
          IconButton(
              onPressed: () {
                Navigator.pushNamed(context, '/notification');
              },
              icon: Icon(Icons.notifications))
        ],
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 20.0, bottom: 20, left: 20),
                    child: Text(
                      ' Ongoing Classes',
                      style: Theme.of(context).textTheme.headline2,
                    ),
                  ),
                  MyCard(
                    canjoin: true,
                    name: "Harry",
                    subject: "Physics",
                    timing: "1AM - 2AM",
                  ), 
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0, bottom: 10),
                    child: Text(
                      'Scheduled Classes',
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
                return MyCard(
                  canjoin: false,
                    name: "Harry",
                    subject: "Physics",
                    timing: "1AM - 2AM",
                );
              },
              childCount: 3,
            ),
          ),
        ],
      ),
    );
  }
}
