import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tcp_socket_connection/tcp_socket_connection.dart';
import 'package:untitled/Components/ListPlaybacks.dart';

class Home extends StatefulWidget {
  const Home({super.key, required this.socketConnection, required this.homeState });
  final TcpSocketConnection socketConnection;
  final String homeState;
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String playbackState = "";
  double dimm = 255;
  double fogIntensity = 255;
  var renderPlaybacks = false;
  var releasePressed = false;
  var fogPressed = false;

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
    List list = widget.homeState.split(',');
    list.removeAt(0);
    print(list);
    return Scaffold(
      appBar: AppBar(
        title: Text("Freestyler DMX"),
        backgroundColor: Colors.blue,
      ),
      body: Container(
        color: Colors.black,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Divider( color: Colors.white),
            Text("Dimmer",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            Slider(
                value: dimm,
                min: 0, 
                max: 255, 
                onChangeEnd: (v) {
                  sendCommand("FSOC155$v");
                },
                onChanged: (val) {
                  setState(() {
                  dimm = val;
                });
            }),
            Divider(color: Colors.white,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () async => {
                    sendCommand("FSOC123255"),
                    sendCommand('FSBC014')
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width / 5,
                    height: MediaQuery.of(context).size.width / 5,
                    alignment: Alignment.center,
                    margin: EdgeInsets.all(10),
                    child: Text("Freeze", style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      ),
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: list[1] == '1' ? Colors.red : Colors.blue,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () async => {
                    sendCommand("FSOC001255"),
                    sendCommand('FSBC014')
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width / 5,
                    height: MediaQuery.of(context).size.width / 5,
                    alignment: Alignment.center,
                    margin: EdgeInsets.all(10),
                    child: Text("Favorite", style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: list[2] == '1' ? Colors.red : Colors.blue,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () async => {
                    sendCommand("FSOC002255"),
                    sendCommand('FSBC014'),
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width / 5,
                    height: MediaQuery.of(context).size.width / 5,
                    alignment: Alignment.center,
                    margin: EdgeInsets.all(10),
                    child: Text("Blackout", style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: list[0] == '1' ? Colors.red : Colors.blue,
                    ),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () async => {
                    sendCommand("FSOC024255"),
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width / 5,
                    height: MediaQuery.of(context).size.width / 5,
                    alignment: Alignment.center,
                    margin: EdgeInsets.all(10),
                    child: Text("Release", style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.blue,
                    ),
                  ),
                ),
                GestureDetector(
                  onTapDown: (e) async {
                    sendCommand("FSOC176255");
                    setState(() {
                      fogPressed = true;
                    });
                  },
                  onTapUp: (e) async {
                    sendCommand("FSOC1760");
                    setState(() {
                      fogPressed = false;
                    });
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width / 5,
                    height: MediaQuery.of(context).size.width / 5,
                    alignment: Alignment.center,
                    margin: EdgeInsets.all(10),
                    child: Text("Fog", style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: fogPressed ? Colors.red : Colors.blue,
                    ),
                  ),
                ),
              ],
            ),


            Divider(color: Colors.white,),
            Text("Fog intensity",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            Slider(
              value: fogIntensity,
              min: 0,
              max: 255,
              onChangeEnd: (v) {
                sendCommand("FSOC304$v");
              },
              onChanged: (val) {
                setState(() {
                  fogIntensity = val;
                });
            }),
            Divider(color: Colors.white,),

          ],
        )
      )
    );
  }
}
