// ignore_for_file: file_names, prefer_const_constructors
import 'dart:io';
import 'package:edeazy_teacher/controller/authorisation_controller.dart';
import 'package:edeazy_teacher/controller/jitsii_controller.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jitsi_meet/jitsi_meet.dart';

import 'colorScheme.dart';

class MyCard extends StatefulWidget {
  
  final bool canjoin;
  final String subject;
  final String name;
  final String timing;
  const MyCard({
   Key? key,
   required this.canjoin,
   required this.subject,
   required this.name,
   required this.timing
   }) : super(key: key);

  

  @override
  State<MyCard> createState() => _MyCardState();
}

class _MyCardState extends State<MyCard> {
  @override
  Widget build(BuildContext context) {
    // final d = Get.put(Jitsiicontroller());
    // VoidCallback? isjoin ;
    var time = DateTime(2022,02,26,17,30);

  //   Stream<bool> active = (() async* {
  // await Future<void>.delayed(Duration(seconds: 2));

  // if(time.isAtSameMomentAs(DateTime.now())){
  //   setState(() {
  //         isjoin = true;
  //       });
        

  // }

    // for(int i=0;i<d.classlist.length;i++){
    //   await Future<void>.delayed(Duration(seconds: 1));
    //   if(time.isAfter(d.classlist[i].startTime)&&time.isBefore(d.classlist[i].endTime)) {
    //     setState(() {
    //       isjoin = true;
    //     });
    //     }
    // }
//     yield true;
// })();
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
               CircleAvatar(
                 minRadius: 40,
                 maxRadius: 50,
                 backgroundImage: Image.asset('images/monkey_profile.jpg').image,
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
                         widget.subject,
                         style: Theme.of(context).textTheme.headline4,
                       ),
                       SizedBox(height: 10),
                       Text(
                         'Electromagnetic Induction',
                         style: Theme.of(context).textTheme.headline3,
                       ),
                       SizedBox(height: 10),
                       Text(
                         widget.name,
                         style: Theme.of(context).textTheme.headline4,
                       ),
                       SizedBox(height: 10),
                       Row(
                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                         children: [
                           Text(
                             widget.timing,
                             style: Theme.of(context).textTheme.headline5,
                           ),
                           StreamBuilder<bool>(
                                 stream: Stream.periodic(Duration(seconds: 1),(i){
                                   if(DateTime.now().isAfter(time)){
                                      return true;
                                 }
                                 return false;
                                 }),
                                 initialData: false,
                                 builder: (context, snapshot) {

                                   if((snapshot.connectionState == ConnectionState.active || snapshot.connectionState == ConnectionState.done) && (snapshot.hasData && snapshot. data == true)){
                                     return TextButton(
                                       style: TextButton.styleFrom(
                                           backgroundColor: cardcolor,
                                           shape: RoundedRectangleBorder(
                                               borderRadius: BorderRadius.circular(20))),
                                       onPressed: () {},
                                       child: Text(
                                         'Join',
                                         style: TextStyle(color: Colors.white),
                                       ),
                                     );
                                   }
                                   return TextButton(
                                       style: TextButton.styleFrom(
                                           backgroundColor: Colors.grey,
                                           shape: RoundedRectangleBorder(
                                               borderRadius: BorderRadius.circular(20))),
                                       onPressed: () {
                                         Navigator.push(
                                           context,
                                           MaterialPageRoute(
                                             builder: (context) => Meeting(),
                                           ),
                                         );
                                       },
                                       child: Text(
                                         'Join',
                                         style: TextStyle(color: Colors.white),
                                       ),
                                     ); 
                                 } 
                               ),
                         ],
                      ),
                    ],
                   
                  ),
                ),
              ),
            ],
      )
    );
  }
  void joinButton (){}
}

class CustomeLoading extends StatefulWidget {
  const CustomeLoading({
    Key? key,
    this.color,
    this.size = 50.0,
    this.itemBuilder,
    this.duration = const Duration(milliseconds: 2000),
  })  : assert(
            !(itemBuilder is IndexedWidgetBuilder && color is Color) &&
                !(itemBuilder == null && color == null),
            'You should specify either a itemBuilder or a color'),
        super(key: key);

  final Color? color;
  final double size;
  final IndexedWidgetBuilder? itemBuilder;
  final Duration duration;

  @override
  _CustomeLoadingState createState() => _CustomeLoadingState();
}

class _CustomeLoadingState extends State<CustomeLoading>
    with TickerProviderStateMixin {
  late AnimationController _scaleCtrl;
  late AnimationController _rotateCtrl;
  late Animation<double> _scale;
  late Animation<double> _rotate;

  @override
  void initState() {
    super.initState();

    _scaleCtrl = AnimationController(vsync: this, duration: widget.duration)
      ..addListener(() => setState(() {}))
      ..repeat(reverse: true);
    _scale = Tween(begin: -1.0, end: 1.0)
        .animate(CurvedAnimation(parent: _scaleCtrl, curve: Curves.easeInOut));

    _rotateCtrl = AnimationController(vsync: this, duration: widget.duration)
      ..addListener(() => setState(() {}))
      ..repeat();
    _rotate = Tween(begin: 0.0, end: 360.0)
        .animate(CurvedAnimation(parent: _rotateCtrl, curve: Curves.linear));
  }

  @override
  void dispose() {
    _scaleCtrl.dispose();
    _rotateCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox.fromSize(
        size: Size.square(widget.size),
        child: Transform.rotate(
          angle: _rotate.value * 0.0174533,
          child: Stack(
            children: <Widget>[
              Positioned(top: 0.0, child: _circle(1.0 - _scale.value.abs(), 0)),
              Positioned(bottom: 0.0, child: _circle(_scale.value.abs(), 1)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _circle(double scale, int index) {
    return Transform.scale(
      scale: scale,
      child: SizedBox.fromSize(
        size: Size.square(widget.size * 0.6),
        child: widget.itemBuilder != null
            ? widget.itemBuilder!(context, index)
            : DecoratedBox(
                decoration:
                    BoxDecoration(shape: BoxShape.circle, color: widget.color)),
      ),
    );
  }
}

class Meeting extends StatefulWidget {
  const Meeting({Key? key}) : super(key: key);

  @override
  _MeetingState createState() => _MeetingState();
}

class _MeetingState extends State<Meeting> {
  final controll = Get.put(Jitsiicontroller());
  var d = Get.put(AuthrisationController());
  bool? isAudioOnly = true;
  bool isAudioMuted = true;
  bool isVideoMuted = true;

  @override
  void initState() {
    super.initState();
    JitsiMeet.addListener(
      JitsiMeetingListener(
        onConferenceWillJoin: _onConferenceWillJoin,
        onConferenceJoined: _onConferenceJoined,
        onConferenceTerminated: _onConferenceTerminated,
        onError: _onError,
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    JitsiMeet.removeAllListeners();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        // body: Center(child: meetConfig(width)),
        body: kIsWeb
            ? FutureBuilder(
                future: _joinMeeting(),
                builder: (context, snap) {
                  return meetConfig(
                      size: size,
                      child: JitsiMeetConferencing(
                        extraJS: const [
                          // extraJs setup example
                          '<script>function echo(){console.log("echo!!!")};</script>',
                          '<script src="https://code.jquery.com/jquery-3.5.1.slim.js" integrity="sha256-DrT5NfxfbHvMHux31Lkhxg42LY6of8TaYyK50jnxRnM=" crossorigin="anonymous"></script>'
                        ],
                      ));
                })
            : meetConfig(size: size, child: Container()));
  }

  Widget meetConfig({required Size size, required Widget child}) {
    return Column(
      children: [
        Container(
          child: child,
          height: size.height * 0.4,
          width: size.width * 0.5,
          margin: EdgeInsets.all(40),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: const [
              BoxShadow(
                offset: Offset(2, 2),
                color: Colors.black12,
                spreadRadius: 2,
              ),
            ],
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            myIcon(
              trigger: isAudioMuted,
              onPressed: () => setState(() {
                isAudioMuted = !isAudioMuted;
              }),
              firstIcon: Icons.mic_off_rounded,
              secondIcon: Icons.mic_rounded,
            ),
            SizedBox(width: 25),
            myIcon(
              trigger: isVideoMuted,
              onPressed: () => setState(() {
                isVideoMuted = !isVideoMuted;
              }),
              firstIcon: Icons.videocam_off,
              secondIcon: Icons.videocam,
            ),
            SizedBox(width: 25),
            TextButton(
              onPressed: _joinMeeting,
              child: Text(
                'Join',
                style: TextStyle(color: Colors.white),
              ),
              style: TextButton.styleFrom(
                padding: EdgeInsets.all(20),
                backgroundColor: Colors.blueAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(40),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget myIcon({
    required bool trigger,
    required VoidCallback onPressed,
    required IconData firstIcon,
    required IconData secondIcon,
  }) {
    return Container(
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.black,
        ),
        shape: BoxShape.circle,
        color: (trigger) ? Colors.red : Colors.white,
      ),
      child: IconButton(
        hoverColor: Colors.transparent,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        onPressed: onPressed,
        icon: AnimatedSwitcher(
          duration: const Duration(milliseconds: 400),
          child: (trigger)
              ? Icon(
                  firstIcon,
                  color: Colors.white,
                )
              : Icon(
                  secondIcon,
                  color: Colors.blueAccent,
                ),
          transitionBuilder: (child, anim) {
            return SizeTransition(
              axis: Axis.vertical,
              child: child,
              sizeFactor: anim,
            );
          },
        ),
      ),
    );
  }

  // void _onAudioOnlyChanged(value) {
  //   setState(() {
  //     isAudioOnly = !value;
  //   });
  // }

  Future<void> _joinMeeting() async {
    // Enable or disable any feature flag here
    // If feature flag are not provided, default values will be used
    // Full list of feature flags (and defaults) available in the README
    Map<FeatureFlagEnum, bool> featureFlags = {
      FeatureFlagEnum.WELCOME_PAGE_ENABLED: false,
    };
    if (!kIsWeb) {
      // Here is an example, disabling features for each platform
      if (Platform.isAndroid) {
        // Disable ConnectionService usage on Android to avoid issues (see README)
        featureFlags[FeatureFlagEnum.CALL_INTEGRATION_ENABLED] = false;
      } else if (Platform.isIOS) {
        // Disable PIP on iOS as it looks weird
        featureFlags[FeatureFlagEnum.PIP_ENABLED] = false;
      }
    }
    var subject ='';
    var cla=''; 
    var time = DateTime.now();
    for(int i=0;i<controll.classlist.length;i++){
      if(time.isAfter(controll.classlist[i].startTime)&&time.isBefore(controll.classlist[i].endTime)) {
        subject =controll.classlist[i].subject;
        cla = controll.classlist[i].jitsiiClass;
        }
   
    }
    // Define meetings options here
    var options = JitsiMeetingOptions(room: '{$cla}th-{$subject}')
      ..serverURL = 'meet.jitsi.si/{$cla}th-{$subject}'
      ..subject = subject
      ..userDisplayName = d.userinfo(key: 'name')
      ..userEmail = d.userinfo(key: 'email')
      ..iosAppBarRGBAColor = '#0080FF80'
      ..audioOnly = isAudioOnly
      ..audioMuted = isAudioMuted
      ..videoMuted = isVideoMuted
      ..featureFlags.addAll(featureFlags)
      ..webOptions = {
        "roomName": 'hindi',
        "width": "100%",
        "height": "100%",
        "enableWelcomePage": false,
        "chromeExtensionBanner": null,
        "userInfo": {"displayName": d.userinfo(key: 'email')}
      };

    await JitsiMeet.joinMeeting(
      options,
      listener: JitsiMeetingListener(
        onConferenceWillJoin: (message) {
          debugPrint("${options.room} will join with message: $message");
        },
        onConferenceJoined: (message) {
          debugPrint("${options.room} joined with message: $message");
        },
        onConferenceTerminated: (message) {
          debugPrint("${options.room} terminated with message: $message");
        },
        genericListeners: [
          JitsiGenericListener(
            eventName: 'readyToClose',
            callback: (dynamic message) {
              debugPrint("readyToClose callback");
            },
          ),
        ],
      ),
    );
  }

  void _onConferenceWillJoin(message) {
    debugPrint("_onConferenceWillJoin broadcasted with message: $message");
  }

  void _onConferenceJoined(message) {
    debugPrint("_onConferenceJoined broadcasted with message: $message");
  }

  void _onConferenceTerminated(message) {
    debugPrint("_onConferenceTerminated broadcasted with message: $message");
  }

  _onError(error) {
    debugPrint("_onError broadcasted: $error");
  }
}
