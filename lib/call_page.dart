//
//
// import 'package:agora_rtc_engine/agora_rtc_engine.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_rd_agora/main.dart';
// import 'package:permission_handler/permission_handler.dart';
//
// class CallPage extends StatefulWidget {
//   const CallPage({Key? key}) : super(key: key);
//
//   @override
//   State<CallPage> createState() => _CallPageState();
// }
//
// class _CallPageState extends State<CallPage> {
//
//   int uid = 0; // uid of the local user
//
//   int? _remoteUid; // uid of the remote user
//   bool _isJoined = false;
//   late RtcEngine agoraEngine;
//
//
//   final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>(); // Global key to access the scaffold
//
//   showMessage(String message) {
//     scaffoldMessengerKey.currentState?.showSnackBar(SnackBar(
//       content: Text(message),
//     ));
//   }
//
//   @override
//   void dispose() {
//
//     super.dispose();
//   }
//
//   @override
//   void initState() {
//     super.initState();
//   }
//
//   Future<void> setupVoiceSDKEngine() async {
//     // retrieve or request microphone permission
//     await [Permission.microphone].request();
//
//     //create an instance of the Agora engine
//     agoraEngine = createAgoraRtcEngine();
//     await agoraEngine.initialize(const RtcEngineContext(
//         appId: APP_ID,
//     ));
//
//     // Register the event handler
//     agoraEngine.registerEventHandler(
//       RtcEngineEventHandler(
//         onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
//           showMessage("Local user uid:${connection.localUid} joined the channel");
//           setState(() {
//             _isJoined = true;
//           });
//         },
//         onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
//           showMessage("Remote user uid:$remoteUid joined the channel");
//           setState(() {
//             _remoteUid = remoteUid;
//           });
//         },
//         onUserOffline: (RtcConnection connection, int remoteUid,
//             UserOfflineReasonType reason) {
//           showMessage("Remote user uid:$remoteUid left the channel");
//           setState(() {
//             _remoteUid = null;
//           });
//         },
//       ),
//     );
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//     return const Placeholder();
//   }
// }
