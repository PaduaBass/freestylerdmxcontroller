import 'dart:io';

import 'package:flutter/material.dart';
import 'package:tcp_socket_connection/tcp_socket_connection.dart';
import 'package:untitled/Home.dart';
import 'package:untitled/Overrides.dart';
import 'package:untitled/Playbacks.dart';
import 'package:untitled/Settings.dart';

class NavigationExample extends StatefulWidget {
  const NavigationExample({super.key});

  @override
  State<NavigationExample> createState() => NavigationExampleState();
}

class NavigationExampleState extends State<NavigationExample> {
  int currentPageIndex = 3;
  NavigationDestinationLabelBehavior labelBehavior =
      NavigationDestinationLabelBehavior.alwaysShow;

  var socketConnection = TcpSocketConnection('', 0000);
  final _ipController = TextEditingController();
  final _portController = TextEditingController();

  String playbackState = "";
  String overridesState = "";
  String homeState = "sda,0,0,0";

  RangeValues _currentRangeValues = const RangeValues(0, 100);

  var renderPlaybacks = false;
  var renderOverrides = false;
  String playbakcksLabels = "";
  String overridesLabels = "";


  @override
  void initState() {
    super.initState();
  }

  //receiving and sending back a custom message

  void initSocketSettings (String ip, int port) {
    setState(() {
      socketConnection = TcpSocketConnection(ip, port);
    });
  }

  void goFirstPage () {
    setState(() {
      currentPageIndex = 0;
    });
  }

  void messageReceived(String msg){
    setState(() {
      if(renderPlaybacks && renderOverrides && currentPageIndex == 0) {
        homeState = msg;
      }
      if(renderPlaybacks && renderOverrides && currentPageIndex == 1) {
        overridesState = msg;
      }
      if(renderPlaybacks && renderOverrides && currentPageIndex == 2) {
        playbackState = msg;
      }
      if(renderOverrides == false && renderPlaybacks) {
        print("Entrou na segunda");

        overridesLabels = msg;
        renderOverrides = true;
      }

      if(renderPlaybacks == false) {
        print("Entrou na primeira");
        playbakcksLabels = msg;
        renderPlaybacks = true;
      }

      print(msg);
    });
    socketConnection.sendMessage("MessageIsReceived :D ");
  }

  void sendCommand (String command) {
    socketConnection.sendMessage(command);
  }

  Future<void> awaitRender () async {
    await Future.delayed(const Duration(milliseconds: 50));
  }

  //starting the connection and listening to the socket asynchronously
  void startConnection() async{
    Socket socket = await Socket.connect('10.0.0.131', 3332);
    print(socket);
    socketConnection.enableConsolePrint(true);    //use this to see in the console what's happening
    print("metodo iniciar");
    if(await socketConnection.canConnect(5000, attempts: 3)){   //check if it's possible to connect to the endpoint
      await socketConnection.connect(5000, messageReceived, attempts: 3);
    }
    sendCommand("FSBC001");
    await awaitRender();
    sendCommand("FSBC002");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NavigationBar(
        labelBehavior: labelBehavior,
        selectedIndex: currentPageIndex,
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
            print(currentPageIndex);
          });
        },
        destinations: const <Widget>[
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: "Home",
          ),
          NavigationDestination(
            icon: Icon(Icons.grid_view_outlined),
            selectedIcon: Icon(Icons.grid_view_rounded),
            label: 'Buttons',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.play_arrow),
            icon: Icon(Icons.play_arrow_outlined),
            label: 'Playbacks',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.settings),
            icon: Icon(Icons.settings_outlined),
            label: 'Settings',
          ),
        ],
      ),
      body: <Widget>[
        Home(socketConnection: socketConnection, homeState: homeState),
        Overrides(socketConnection: socketConnection, overridesLabels: overridesLabels, overridesState: overridesState),
        Playbacks(socketConnection: socketConnection, message: playbakcksLabels, playbackState: playbackState),
        Settings(ipController: _ipController, portController: _portController, socketConnection: socketConnection),
      ][currentPageIndex],
    );
  }
}