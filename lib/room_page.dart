import 'package:agora_uikit/agora_uikit.dart';
import 'package:flutter/material.dart';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';

import 'constants.dart';

class RoomPage extends StatefulWidget {
  final String rtcChannelName;

  const RoomPage({Key? key, required this.rtcChannelName}) : super(key: key);

  @override
  _RoomPageState createState() => _RoomPageState();
}

class _RoomPageState extends State<RoomPage> {
  static final _users = <int>[];
  static final _users2 = <int>[];
  AgoraClient? client;
  final _infoStrings = <String>[];
  int tokenRole = kTokenRole; // use 1 for Host/Broadcaster, 2 for Subscriber/Audience
  String serverUrl = ""; // The base URL to your token server, for example "https://agora-token-service-production-92ff.up.railway.app"
  int tokenExpireTime = kTokenExpireTime; // Expire time in Seconds.
  bool isTokenExpiring = kIsTokenExpiring;
  bool muted = false;

  // final ChannelMediaOptions _options = ChannelMediaOptions.fromJson({'autoSubscribeAudio': true, 'autoSubscribeVideo': true});

  // String channelName = "<--Insert channel name here-->";
  String token = kTokenChanelDemo;

  int uid = 0; // uid of the local user

  int? _remoteUid; // uid of the remote user
  bool _isJoined = false; // Indicates if the local user has joined the channel
  late RtcEngine agoraEngine; // Agora engine instance

  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>(); // Global key to access the scaffold

  showMessage(String message) {
    scaffoldMessengerKey.currentState?.showSnackBar(SnackBar(
      content: Text(message),
    ));
  }

  @override
  void dispose() {
    // clear users
    _users.clear();
    _users2.clear();
    // destroy sdk

    agoraEngine.leaveChannel();
    agoraEngine.release();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    // initialize agora sdk
    initialize();
  }

  Future<void> _handleCameraAndMic(Permission permission) async {
    final status = await permission.request();
    print(status);
  }

  void setToken(String newToken) async {
    token = newToken;

    if (isTokenExpiring) {
      // Renew the token
      agoraEngine.renewToken(token);
      isTokenExpiring = false;
      showMessage("Token renewed");
    } else {
      // Join a channel.
      showMessage("Token received, joining a channel...");
      ChannelMediaOptions options = const ChannelMediaOptions(
        clientRoleType: ClientRoleType.clientRoleBroadcaster,
        channelProfile: ChannelProfileType.channelProfileCommunication,
      );

      await agoraEngine.joinChannel(
        token: token,
        channelId: widget.rtcChannelName,
        // info: '',
        options: options,
        uid: uid,
      );
    }
  }

  Future<void> fetchToken(int uid, String channelName, int tokenRole) async {
    // // Prepare the Url
    // String url = '$serverUrl/rtc/$channelName/${tokenRole.toString()}/uid/${uid.toString()}?expiry=${tokenExpireTime.toString()}';
    //
    // // Send the request
    // final response = await http.get(Uri.parse(url));
    //
    // if (response.statusCode == 200) {
    //   // If the server returns an OK response, then parse the JSON.
    //   Map<String, dynamic> json = jsonDecode(response.body);
    //   String newToken = json['rtcToken'];
    //   debugPrint('Token Received: $newToken');
    //   // Use the token to join a channel or renew an expiring token
    //   setToken(newToken);
    // } else {
    //   // If the server did not return an OK response,
    //   // then throw an exception.
    //   throw Exception(
    //       'Failed to fetch a token. Make sure that your server URL is valid');
    // }

    setToken(token);
  }

  Future<void> initialize() async {
    await _handleCameraAndMic(Permission.camera);
    await _handleCameraAndMic(Permission.microphone);

    agoraEngine = createAgoraRtcEngine();
    await agoraEngine.initialize(const RtcEngineContext(
      appId: kAppAgoraId,
    ));

    await agoraEngine.enableVideo();
    await agoraEngine.setChannelProfile(ChannelProfileType.channelProfileLiveBroadcasting);

    _addAgoraEventHandlers();

    await fetchToken(uid, widget.rtcChannelName, tokenRole);

    // await agoraEngine.joinChannel(null, widget.rteChannelName, null, 0);
    //
    // _channel = await RtcChannel.create(widget.rtcChannelName);
    // _addRtcChannelEventHandlers();
    // await agoraEngine.setClientRole(ClientRole.Broadcaster);
    // await _channel.joinChannel(null, null, 0, ChannelMediaOptions(true, true));
    // await _channel.publish();
  }

  Future<void> leave() async {
    setState(() {
      _isJoined = false;
      _remoteUid = null;
    });
    Navigator.of(context).pop();
  }

  /// Add agora event handlers
  void _addAgoraEventHandlers() {
    agoraEngine.registerEventHandler(
      RtcEngineEventHandler(
        onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
          showMessage("Local user uid:${connection.localUid} joined the channel");
          setState(() {
            _isJoined = true;
          });
        },
        onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
          showMessage("Remote user uid:$remoteUid joined the channel");
          setState(() {
            _remoteUid = remoteUid;
          });
        },
        onUserOffline: (RtcConnection connection, int remoteUid, UserOfflineReasonType reason) {
          showMessage("Remote user uid:$remoteUid left the channel");
          setState(() {
            _remoteUid = null;
          });
        },
        onTokenPrivilegeWillExpire: (RtcConnection connection, String token) {
          showMessage('Token expiring');
          isTokenExpiring = true;
          setState(() {
            // fetch a new token when the current token is about to expire
            fetchToken(uid, widget.rtcChannelName, tokenRole);
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldMessengerKey,
      appBar: AppBar(
        title: const Text('Get started with Video Calling'),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        children: [
          // Container for the local video
          Container(
            height: 240,
            decoration: BoxDecoration(border: Border.all()),
            child: Center(child: _localPreview()),
          ),
          const SizedBox(height: 10),
          //Container for the Remote video
          Container(
            height: 240,
            decoration: BoxDecoration(border: Border.all()),
            child: Center(child: _remoteVideo()),
          ),
          // Button Row
          Row(
            children: <Widget>[
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton(
                  onPressed: _isJoined ? () => {leave()} : null,
                  child: const Text("Leave"),
                ),
              ),
            ],
          ),
          // Button Row ends
        ],
      ),
    );
  }

  // Display local video preview
  Widget _localPreview() {
    if (_isJoined) {
      return AgoraVideoView(
        controller: VideoViewController(
          rtcEngine: agoraEngine,
          canvas: const VideoCanvas(uid: 0),
        ),
      );
    } else {
      return const Text(
        'Join a channel',
        textAlign: TextAlign.center,
      );
    }
  }

// Display remote user's video
  Widget _remoteVideo() {
    if (_remoteUid != null) {
      return AgoraVideoView(
        controller: VideoViewController.remote(
          rtcEngine: agoraEngine,
          canvas: VideoCanvas(uid: _remoteUid),
          connection: RtcConnection(channelId: widget.rtcChannelName),
        ),
      );
    } else {
      String msg = '';
      if (_isJoined) msg = 'Waiting for a remote user to join';
      return Text(
        msg,
        textAlign: TextAlign.center,
      );
    }
  }
}
