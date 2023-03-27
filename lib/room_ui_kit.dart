import 'package:agora_uikit/agora_uikit.dart';
import 'package:flutter/material.dart';

import 'constants.dart';

class RoomUiKit extends StatefulWidget {
  final String rtcChannelName;

  const RoomUiKit({Key? key, required this.rtcChannelName}) : super(key: key);

  @override
  State<RoomUiKit> createState() => _RoomUiKitState();
}

class _RoomUiKitState extends State<RoomUiKit> {
  late final AgoraClient _agoraClient;
  String token = kTokenChanelDemo;
  bool isTokenExpiring = kIsTokenExpiring;
  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>(); // Global key to access the scaffold
  int uid = 0;
  bool _loading = true;

  @override
  void dispose() {
    // destroy sdk
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    // initialize agora sdk
    initialize();
  }

  Future<void> initialize() async {
    // await _handleCameraAndMic(Permission.camera);
    // await _handleCameraAndMic(Permission.microphone);
    //
    // agoraEngine = createAgoraRtcEngine();
    // await agoraEngine.initialize(const RtcEngineContext(
    //   appId: appAgoraId,
    // ));
    //
    // await agoraEngine.enableVideo();
    // await agoraEngine.setChannelProfile(ChannelProfileType.channelProfileLiveBroadcasting);
    //
    // _addAgoraEventHandlers();

    await fetchToken(uid, widget.rtcChannelName, kTokenRole);

    // await agoraEngine.joinChannel(null, widget.rteChannelName, null, 0);
    //
    // _channel = await RtcChannel.create(widget.rtcChannelName);
    // _addRtcChannelEventHandlers();
    // await agoraEngine.setClientRole(ClientRole.Broadcaster);
    // await _channel.joinChannel(null, null, 0, ChannelMediaOptions(true, true));
    // await _channel.publish();
  }

  showMessage(String message) {
    scaffoldMessengerKey.currentState?.showSnackBar(SnackBar(
      content: Text(message),
    ));
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

  void setToken(String newToken) async {
    token = newToken;

    if (isTokenExpiring) {
      // Renew the token
      _agoraClient.engine.renewToken(token);
      isTokenExpiring = false;
      showMessage("Token renewed");
    } else {
      // Join a channel.
      showMessage("Token received, joining a channel...");

      _agoraClient = AgoraClient(
        agoraConnectionData: AgoraConnectionData(
          appId: kAppAgoraId,
          channelName: widget.rtcChannelName,
          tempToken: token,
          uid: uid,
        ),
        enabledPermission: [Permission.camera, Permission.microphone],
      );

      await _agoraClient.initialize();

      Future.delayed(const Duration(seconds: 1)).then(
        (value) => setState(() => _loading = false),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldMessengerKey,
      body: SafeArea(
        child: _loading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Stack(
                children: [
                  AgoraVideoViewer(
                    layoutType: Layout.oneToOne,
                    client: _agoraClient,
                  ),
                  AgoraVideoButtons(
                    client: _agoraClient,
                  ),
                ],
              ),
      ),
    );
  }
}
