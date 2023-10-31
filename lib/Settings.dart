import 'package:flutter/material.dart';
import 'package:tcp_socket_connection/tcp_socket_connection.dart';
import 'package:untitled/NavigationBottom.dart';

class Settings extends StatefulWidget {
  const Settings({super.key, required this.ipController, required this.portController, required this.socketConnection });
  final TextEditingController ipController;
  final TextEditingController portController;
  final TcpSocketConnection socketConnection;

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  var isConnected = false;

  void updateStateConnected () {
    setState(() {
      isConnected = widget.socketConnection.isConnected();
    });
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    updateStateConnected();
  }

  @override
  Widget build(BuildContext context) {

    return Container(
      padding: EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: isConnected ? [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.blue),
                  ),
                  onPressed: () {
                    widget.socketConnection.disconnect();
                    updateStateConnected();
                  }, child: Text("Disconnect", style: TextStyle( color: Colors.white ),)
              ),
            ],
          )
        ] : [
          TextField(
            controller: widget.ipController,
            decoration: InputDecoration(
              hintText: "IP",
            ),
            keyboardType: TextInputType.phone,
          ),
          TextField(
            controller: widget.portController,
            decoration: InputDecoration(
              hintText: "PORT",
            ),
            keyboardType: TextInputType.phone,
          ),
          TextButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.blue),
              ),
              onPressed: () => {
                if(!widget.socketConnection.isConnected()) {
                  context.findAncestorStateOfType<NavigationExampleState>()?.initSocketSettings(widget.ipController.text, int.parse(widget.portController.text)),
                  context.findAncestorStateOfType<NavigationExampleState>()?.startConnection(),
                  context.findAncestorStateOfType<NavigationExampleState>()?.goFirstPage(),
                }
              }, child: Text("Connect", style: TextStyle( color: Colors.white ),))
        ],
      ),
    );
  }
}




