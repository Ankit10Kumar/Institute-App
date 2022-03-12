import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:edeazy/controller/authorisation_controller.dart';
import 'package:edeazy/login_page.dart';
import 'package:edeazy/screens/drawer/contactUSPage.dart';
import 'package:edeazy/screens/drawer/custome_drawer.dart';
import 'package:edeazy/screens/drawer/bookmark.dart';
import 'package:edeazy/screens/drawer/faq.dart';
import 'package:edeazy/screens/drawer/profile_page.dart';
import 'package:edeazy/screens/notification.dart';
import 'package:edeazy/screens/study_material/pdf_view.dart';
import 'package:edeazy/screens/study_material/topic_page.dart';
import 'homepage.dart';
import 'screens/drawer/performance.dart';
import 'screens/study_material/student_study_material.dart';

void main() async {
  await GetStorage.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      getPages: [
        GetPage(name: '/homepage', page: () => const HomePage()),
        GetPage(name: '/profile', page: () => const ProfilePage()),
        GetPage(name: '/notification', page: () => const NotificatioPage()),
        GetPage(name: '/contactus', page: () => const ContactUs()),
        GetPage(name: '/performance', page: () => const PerformancePage()),
        GetPage(name: '/default', page: () => const DefaultPage()),
        GetPage(name: '/downloads', page: () => const Bookmark()),
        GetPage(name: '/faq', page: () => const FAQPage()),
        GetPage(name: '/study', page: () => const SubjectMaterial()),
        GetPage(name: '/login', page: () => const LoginPage()),
        GetPage(name: '/inchapter', page: () => const TopicPage()),
        GetPage(name: '/pdfView', page: () => const PdfView()),
      ],
      defaultTransition: Transition.cupertino,
      transitionDuration: const Duration(milliseconds: 600),
      debugShowCheckedModeBanner: false,
      theme: ThemeData().copyWith(
        primaryColor: Colors.white,
        dividerTheme: DividerThemeData(
          color: const Color(0xff978DFB).withOpacity(0.2),
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Color(0xff1900FF),
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.white54,
        ),
        inputDecorationTheme: InputDecorationTheme(
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide.none),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide.none),
          fillColor: Colors.white,
          filled: true,
          hintStyle: TextStyle(
            color: const Color(0xff978DFB).withOpacity(0.5),
          ),
        ),
        textTheme: const TextTheme(
          headline1: TextStyle(
            color: Colors.black,
            fontSize: 60,
          ),
          //for card headline 2
          headline4: TextStyle(
            color: Colors.black,
            fontSize: 13,
          ),
          //for card headline 3
          headline5: TextStyle(
            color: Colors.black,
            fontSize: 10,
          ),
          //for card headline 1
          headline3: TextStyle(
            color: Colors.black,
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
          //for in body Text theme
          headline2: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          shape: MyShapeBorder(10),
          iconTheme: IconThemeData(color: Colors.white),
          actionsIconTheme: IconThemeData(color: Colors.white),
          centerTitle: true,
          elevation: 20,
          titleTextStyle: TextStyle(
            shadows: [
              Shadow(color: Colors.grey, blurRadius: 3, offset: Offset(2, 2))
            ],
            color: Colors.white,
            letterSpacing: 2,
            fontWeight: FontWeight.bold,
            fontSize: 25,
          ),
          backgroundColor: Colors.blue, //dark blue
        ),
      ),
      title: 'Institute',
      home: FutureBuilder(
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Splash();
          } else {
            if (snapshot.data ?? false) return const HomePage();
            return const LoginPage();
          }
        },
        future: Init.instance.initialize(),
      ),
      // (go()) ? const HomePage() : const LoginPage(),
    );
  }
}

class Splash extends StatelessWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: const [
            LinearProgressIndicator(
              minHeight: 10,
              color: Colors.white38,
            ),
            SizedBox(height: 10),
            Text(
              'Loading...',
              style: TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
                wordSpacing: 4,
              ),
            )
          ],
        ),
      ),
      // body: Center(child: Image.asset('assets/images/monkey_profile.jpg')),
    );
  }
}

class Init {
  Init._();
  static final instance = Init._();
  Future<bool> initialize() async {
    var c = Get.put(AuthrisationController());
    final g = GetStorage();
    String d = g.read('token') ?? '';
    if (d.isNotEmpty) {
      bool bol = await c.refreshProfile();
      return bol;
    } else {
      return false;
    }
  }
}

class MyShapeBorder extends ContinuousRectangleBorder {
  const MyShapeBorder(this.curveHeight);
  final double curveHeight;

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) => Path()
    ..lineTo(0, rect.size.height)
    ..quadraticBezierTo(
      rect.size.width / 2,
      rect.size.height + curveHeight * 4,
      rect.size.width,
      rect.size.height,
    )
    ..lineTo(rect.size.width, 0)
    ..close();
}
