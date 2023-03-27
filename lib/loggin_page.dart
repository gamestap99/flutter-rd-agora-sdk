import 'package:flutter/material.dart';
import 'package:flutter_rd_agora/room_page.dart';
import 'package:flutter_rd_agora/room_ui_kit.dart';
import 'package:permission_handler/permission_handler.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final rtcChannelNameController = TextEditingController();
  bool _validateError = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Agora Multi-Channel Demo'),
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          clipBehavior: Clip.antiAliasWithSaveLayer,
          padding: const EdgeInsets.all(20),
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.12,
              ),
              Center(
                child: Image(
                  image: const NetworkImage('https://mma.prnewswire.com/media/240347/agora_inc_logo.jpg'),
                  height: MediaQuery.of(context).size.height * 0.17,
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.1,
              ),
              TextFormField(
                controller: rtcChannelNameController,
                decoration: InputDecoration(
                  labelText: 'RTC channel Name',
                  labelStyle: TextStyle(color: Colors.black54),
                  errorText: _validateError ? 'RTC Channel name is mandatory' : null,
                  border: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.blue, width: 2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black, width: 2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue, width: 2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.05),
              MaterialButton(
                onPressed: () => onJoinCore(context),
                color: Colors.blueAccent,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.01, vertical: MediaQuery.of(context).size.height * 0.02),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: const <Widget>[
                      Text(
                        'Join Core Engine',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      Icon(
                        Icons.arrow_forward,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.05),
              MaterialButton(
                onPressed: () => onJoinUiKit(context),
                color: Colors.blueAccent,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.01, vertical: MediaQuery.of(context).size.height * 0.02),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: const <Widget>[
                      Text(
                        'Join UI Kit',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      Icon(
                        Icons.arrow_forward,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void onJoinCore(BuildContext context) {
    setState(() {
      rtcChannelNameController.text.isEmpty ? _validateError = true : _validateError = false;
    });

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RoomPage(
          rtcChannelName: rtcChannelNameController.text,
        ),
      ),
    );
  }

  void onJoinUiKit(BuildContext context) {
    setState(() {
      rtcChannelNameController.text.isEmpty ? _validateError = true : _validateError = false;
    });

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RoomUiKit(
          rtcChannelName: rtcChannelNameController.text,
        ),
      ),
    );
  }
}
