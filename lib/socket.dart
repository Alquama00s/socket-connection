import 'dart:async';

import 'package:flutter/material.dart';

import 'package:socket_io_client/socket_io_client.dart' as IO;

// STEP1:  Stream setup
class StreamSocket {
  final _socketResponse = StreamController<String>();

  void Function(String) get addResponse => _socketResponse.sink.add;

  Stream<String> get getResponse => _socketResponse.stream;

  void dispose() {
    _socketResponse.close();
  }
}

StreamSocket streamSocket = StreamSocket();

//STEP2: Add this function in main function in main.dart file and add incoming data to the stream
void connectAndListen() {
  print('connecting');
  IO.Socket socket = IO.io('http://localhost:3000',
      IO.OptionBuilder().setTransports(['websocket']).build());

  socket.onConnect((_) {
    print('connect');
    socket.emit('key-presed', 2);
  });
  print(socket.connected);
  //When an event recieved from server, data is added to the stream
  socket.on('event', (data) => streamSocket.addResponse);
  socket.onDisconnect((_) => print('disconnect'));
}

//Step3: Build widgets with streambuilder

class BuildWithSocketStream extends StatelessWidget {
  const BuildWithSocketStream({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: StreamBuilder(
          stream: streamSocket.getResponse,
          builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
            return Container(
              child: Text(snapshot.data.toString()),
            );
          },
        ),
      ),
    );
  }
}
