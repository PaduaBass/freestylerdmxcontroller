
import 'package:flutter/material.dart';
import 'package:tcp_socket_connection/tcp_socket_connection.dart';

class ListPlaybacks extends StatefulWidget {
  const ListPlaybacks({super.key, required this.item, required this.state, required this.code, required this.socketConnection, required this.velocityCode });
  final String item;
  final String state;
  final String code;
  final TcpSocketConnection socketConnection;
  final String velocityCode;

  @override
  State<ListPlaybacks> createState() => _ListPlaybacksState();
}

class _ListPlaybacksState extends State<ListPlaybacks> {
  double _currentSliderValue = 50;

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
                      sendCommand('FSBC005')
                    },
                    child: Text(widget.item, style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    )),
                  ),
                ),
                Slider(
                  value: _currentSliderValue,
                  max: 255,
                  min: 0,
                  divisions: 99,
                  onChanged: (double currentValue) {
                    setState(() {
                      _currentSliderValue = currentValue;
                    });
                  },
                  onChangeEnd: (value) {
                    sendCommand(widget.velocityCode + "$value");
                  },
                  label: _currentSliderValue.round().toString(),
                ),
                IconButton(onPressed: () {
                  setState(() {
                    sendCommand(widget.velocityCode + "50");
                    _currentSliderValue = 50;
                  });
                }, icon: Icon(Icons.restart_alt_outlined, color: Colors.blue,))
              ],
            )
        ),
    );
  }
}
