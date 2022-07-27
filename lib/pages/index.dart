import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:agro_app/pages/call.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class IndexPage extends StatefulWidget {
  const IndexPage({Key? key}) : super(key: key);

  @override
  State<IndexPage> createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage> {
  final _channelController = TextEditingController();
  bool validateError = false;
  ClientRole? _role = ClientRole.Broadcaster;

  @override
  void dispose() {
    // TODO: implement dispose
    _channelController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agora'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 40),
              Image.network('https://tinyurl.com/2p889y4k'),
              const SizedBox(height: 20),
              TextField(
                controller: _channelController,
                decoration: InputDecoration(
                  errorText: validateError ? 'Channel Name is Mandatory' : null,
                  border: const UnderlineInputBorder(
                    borderSide: BorderSide(width: 1),
                  ),
                  hintText: 'Channel name',
                ),
              ),
              RadioListTile(
                  title: const Text('Broadcaster'),
                  value:  ClientRole.Broadcaster,
                  onChanged: (ClientRole? value) {
                    setState(() {
                      _role = value;
                    });
                  },
                groupValue: _role,
              ),
              RadioListTile(
                title: const Text('Audience'),
                value:  ClientRole.Audience,
                onChanged: (ClientRole? value) {
                  setState(() {
                    _role = value;
                  });
                },
                groupValue: _role,
              ),
              ElevatedButton(
                  onPressed: onJoin,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 40)
                ),
                  child: const Text('Join'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> onJoin() async {
    setState(() {
      _channelController.text.isEmpty ? validateError = true : validateError = false;
    });
    if(_channelController.text.isNotEmpty){
      await _handleCameraAndMic(Permission.camera);
      await _handleCameraAndMic(Permission.microphone);
      await Navigator.push(context, MaterialPageRoute(
          builder: (context) =>  CallScreen(
            channelName: _channelController.text,
            role: _role,)));
    }
  }

  Future<void> _handleCameraAndMic(Permission permission) async {
    final status = await permission.request();
  }
  
}
