import 'package:dart_ping_ios/dart_ping_ios.dart';
import 'package:flutter/material.dart';
import 'package:tcp_socket_connection/tcp_socket_connection.dart';
import 'package:untitled/Home.dart';
import 'package:untitled/NavigationBottom.dart';
import 'package:untitled/Overrides.dart';
import 'package:untitled/Playbacks.dart';
import 'package:untitled/Settings.dart';

void main() {
  DartPingIOS.register();
  runApp(
    MaterialApp(
      home: NavigationExample(),
      debugShowCheckedModeBanner: false,
    )
  );
}



