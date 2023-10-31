import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tcp_socket_connection/tcp_socket_connection.dart';
import 'package:untitled/Components/ListPlaybacks.dart';

class Playbacks extends StatefulWidget {
  const Playbacks({super.key, required this.socketConnection, required this.message, required this.playbackState });
  final TcpSocketConnection socketConnection;
  final String message;
  final String playbackState;
  @override
  State<Playbacks> createState() => _PlaybacksState();
}

class _PlaybacksState extends State<Playbacks> {
  var renderPlaybacks = false;

  @override
  void initState() {
    super.initState();
  }

  //receiving and sending back a custom message

  void sendCommand (String command) {
    widget.socketConnection.sendMessage(command);
  }

  Future<void> awaitRender () async {
    await Future.delayed(const Duration(milliseconds: 500));
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Playbacks"),
      ),
      body: Center(
        child: Container(
          color: Colors.black,
          child: ListView.builder(
              itemCount: widget.message.split(',').length,
              itemBuilder: (context, index) {
                final item = widget.message.split(',')[index];
                var state = '';

                if(widget.playbackState.length > 0) {
                  state = widget.playbackState.split(',')[index];
                }
                var value = 100.0;
                final code = "FSOC0${45 + index}255";
                final velocityCode = "FSOC${155 + index}";
                return ListPlaybacks(item: item, state: state, code: code, socketConnection: widget.socketConnection, velocityCode: velocityCode,);
              }
          ),
        )
      ),
    );
  }
}
