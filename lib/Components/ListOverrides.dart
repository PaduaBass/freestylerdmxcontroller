
import 'package:flutter/material.dart';
import 'package:tcp_socket_connection/tcp_socket_connection.dart';

class ListOverrides extends StatefulWidget {
  const ListOverrides({super.key, required this.item, required this.state, required this.code, required this.socketConnection });
  final String item;
  final String state;
  final String code;
  final TcpSocketConnection socketConnection;

  @override
  State<ListOverrides> createState() => _ListOverridesState();
}

class _ListOverridesState extends State<ListOverrides> {

  @override
  Widget build(BuildContext context) {


    void sendCommand (String command) {
      widget.socketConnection.sendMessage(command);
    }

    Future<void> awaitRender () async {
      await Future.delayed(const Duration(milliseconds: 500));
    }

    return Visibility(
      visible: (widget.item.length > 0 && !widget.item.contains('FSBC')),
      child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          child: Row(
            children: [
              Expanded(
                child: TextButton(
                  style: ButtonStyle(
                    alignment: Alignment.centerLeft,
                    backgroundColor: MaterialStateProperty.all(widget.state == '1' ? Colors.red : Colors.blue),
                  ),
                  onPressed: () async => {
                    sendCommand(widget.code),
                    awaitRender(),
                    sendCommand('FSBC007')
                  },
                  child: Text(widget.item, style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  )),
                ),
              ),
            ],
          )
      ),
    );
  }
}
