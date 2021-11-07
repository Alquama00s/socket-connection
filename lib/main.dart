import 'package:flutter/material.dart';
import 'package:socket/socket.dart';

import 'package:socket_io_client/socket_io_client.dart' as IO;

//test
void main() {
  //connectAndListen();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late IO.Socket sock;
  String res = '---';
  void update(int i) {
    res = i.toString();
    setState(() {});
  }

  @override
  void initState() {
    sock = IO.io('http://192.168.0.104:3000',
        /*'https://fashion-socket-test-app.herokuapp.com',
                */
        <String, dynamic>{
          'transports': ['websocket'],
          'autoConnect': false,
        });

    sock.connect();
    print(sock.connected);
    sock.onConnect((data) {
      print('readdy');
      //sock.emit('key-pressed', 2);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            height: MediaQuery.of(context).size.height * 0.2,
            child: Center(
              child: Text(res),
            ),
          ),
          SizedBox(
            width: double.infinity,
            height: MediaQuery.of(context).size.height * 0.7,
            child: GridView.count(
              crossAxisCount: 3,
              children: List.generate(10, (i) => _buttons(i + 1, sock, update)),
            ),
          ),
        ],
      ),
    ));
  }
}

Widget _buttons(int i, IO.Socket sock, Function fun) {
  return Padding(
    padding: const EdgeInsets.all(10),
    child: Container(
      width: 20,
      height: 20,
      color: Colors.blue,
      child: TextButton(
        onPressed: () {
          sock.emit('key-pressed', i);
          sock.on('key-pressed', (data) => fun(data['value']));
        },
        child: Center(
          child: Text(
            i.toString(),
            style: TextStyle(color: Colors.black),
          ),
        ),
      ),
    ),
  );
}
