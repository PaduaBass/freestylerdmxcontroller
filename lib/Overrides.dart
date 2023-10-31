import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tcp_socket_connection/tcp_socket_connection.dart';
import 'package:untitled/Components/ListOverrides.dart';
import 'package:untitled/Components/ListPlaybacks.dart';

class Overrides extends StatefulWidget {
  const Overrides({super.key, required this.socketConnection, required this.overridesLabels, required this.overridesState });
  final TcpSocketConnection socketConnection;
  final String overridesLabels;
  final String overridesState;
  @override
  State<Overrides> createState() => _OverridesState();
}

class _OverridesState extends State<Overrides> {
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
        title: Text("Overrides"),
        backgroundColor: Colors.blue,
      ),
      body: Container(
        color: Colors.black,
        child:  ListView.builder(
          itemCount: widget.overridesLabels.split(',').length,
          itemBuilder: (context, index) {
            final item = widget.overridesLabels.split(',')[index];
            var state = '';

            if(widget.overridesState.length > 0) {
              state = widget.overridesState.split(',')[index];
            }
            final code = "FSOC0${65 + index}255";
            return ListOverrides(item: item, state: state, code: code, socketConnection: widget.socketConnection);
          },
        ),
      )
    );
  }
}
