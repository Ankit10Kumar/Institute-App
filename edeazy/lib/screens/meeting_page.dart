import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:jitsi_meet/jitsi_meet.dart';

class Meeting extends StatefulWidget {
  final List<CameraDescription> cameras;
  const Meeting({Key? key, required this.cameras}) : super(key: key);

  @override
  _MeetingState createState() => _MeetingState();
}

class _MeetingState extends State<Meeting> {
  bool? isAudioOnly = true;
  bool isAudioMuted = true;
  bool isVideoMuted = true;
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  @override
  void initState() {
    getCameraList();
    super.initState();
    _controller = CameraController(
      // Get a specific camera from the list of available cameras.
      widget.cameras.first,
      // Define the resolution to use.
      ResolutionPreset.medium,
    );
    // Next, initialize the controller. This returns a Future.
    _initializeControllerFuture = _controller.initialize();
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
    _controller.dispose();
  }

  Future<void> getCameraList() async {}

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Plugin example app'),
      ),
      // body: Center(child: meetConfig(width)),
      body:
          // kIsWeb
          // ? FutureBuilder(
          //     future: _joinMeeting(),
          //     builder: (context, snap) {
          //       return meetConfig(
          //           size: size,
          //           child: JitsiMeetConferencing(
          //             extraJS: const [
          //               // extraJs setup example
          //               '<script>function echo(){console.log("echo!!!")};</script>',
          //               '<script src="https://code.jquery.com/jquery-3.5.1.slim.js" integrity="sha256-DrT5NfxfbHvMHux31Lkhxg42LY6of8TaYyK50jnxRnM=" crossorigin="anonymous"></script>'
          //             ],
          //           ));
          //     })
          // :
          meetConfig(
        size: size,
        child: FutureBuilder<void>(
          future: _initializeControllerFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              // If the Future is complete, display the preview.
              return (isVideoMuted) ? Container() : CameraPreview(_controller);
            } else {
              // Otherwise, display a loading indicator.
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }

  Widget meetConfig({required Size size, required Widget child}) {
    return Column(
      children: [
        Container(
          child: child,
          height: size.height * 0.4,
          width: size.width * 0.5,
          margin: const EdgeInsets.all(40),
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
                (isVideoMuted)
                    ? _controller.pausePreview()
                    : _controller.resumePreview();
                isAudioMuted = !isAudioMuted;
              }),
              firstIcon: Icons.mic_off_rounded,
              secondIcon: Icons.mic_rounded,
            ),
            const SizedBox(width: 25),
            myIcon(
              trigger: isVideoMuted,
              onPressed: () => setState(() {
                isVideoMuted = !isVideoMuted;
              }),
              firstIcon: Icons.videocam_off,
              secondIcon: Icons.videocam,
            ),
            const SizedBox(width: 25),
            TextButton(
              onPressed: _joinMeeting,
              child: const Text(
                'Join Meeting',
                style: TextStyle(color: Colors.white),
              ),
              style: TextButton.styleFrom(
                padding: const EdgeInsets.all(20),
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
    // Define meetings options here
    var options = JitsiMeetingOptions(room: 'hindi')
      // ..serverURL = serverUrl
      ..subject = 'hindi'
      ..userDisplayName = 'pankaj'
      ..userEmail = 'fake@gmail'
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
        "userInfo": {"displayName": 'pankaj'}
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
