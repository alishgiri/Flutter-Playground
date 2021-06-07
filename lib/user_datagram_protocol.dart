import 'dart:io';

import 'package:flutter/material.dart';
import 'package:udp/udp.dart';

class UserDatagramProtocol extends StatefulWidget {
  _UserDatagramProtocolState createState() => _UserDatagramProtocolState();
}

class _UserDatagramProtocolState extends State<UserDatagramProtocol> {
  UDP udp;
  String _incomingString;
  bool _isLoadingR = false;
  bool _isLoadingS = false;
  final port = const Port(65000);

  @override
  void initState() {
    configureUDP();
    super.initState();
  }

  Future configureUDP() async {
    final result = await UDP.bind(Endpoint.any(port: port));
    setState(() {
      udp = result;
      print('UDP initialized!');
    });
  }

  void initiateSenderUDP() async {
    setLoadingS();
    // creates a UDP instance and binds it to the first available network
    // interface on port 65000.
    // sender = await UDP.bind(Endpoint.any(port: port));

    // send a simple string to a broadcast endpoint on port 65001.
    final dataLength = await udp.send(
      "Hello World!".codeUnits,
      Endpoint.broadcast(port: port),
    );

    stdout.write("$dataLength bytes sent.");
    setLoadingS(false);
  }

  void initiateReceiverUDP() async {
    setLoadingR();
    // creates a new UDP instance and binds it to the local address and the port 65002.
    // receiver = await UDP.bind(Endpoint.loopback(port: port));

    // receiving\listening
    await udp.listen((datagram) {
      final str = String.fromCharCodes(datagram.data);
      print('Receiver Listen Complete!');
      setIncomingString(str);
      stdout.write(str);
    }, timeout: const Duration(seconds: 20));
    setLoadingR(false);
  }

  @override
  void dispose() {
    closeUDP();
    super.dispose();
  }

  void closeUDP() {
    setState(() {
      // close the UDP instances and their sockets.
      udp?.close();
      udp = null;
    });
  }

  void setIncomingString(String data) {
    setState(() {
      _incomingString = data;
    });
  }

  void setLoadingR([bool data = true]) {
    setState(() {
      _isLoadingR = data;
    });
  }

  void setLoadingS([bool data = true]) {
    setState(() {
      _isLoadingS = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('UDP/IP Prototype')),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            _incomingString == null
                ? const Text("No Data Received!")
                : Text(_incomingString),
            RaisedButton(
              onPressed: initiateSenderUDP,
              child: _isLoadingS
                  ? const CircularProgressIndicator()
                  : const Text('Initialize UDP Sender'),
            ),
            RaisedButton(
              onPressed: initiateReceiverUDP,
              child: _isLoadingR
                  ? const CircularProgressIndicator()
                  : const Text('Initialize UDP Receiver'),
            ),
            RaisedButton(
              onPressed: closeUDP,
              child: const Text('Close UDP'),
            ),
          ],
        ),
      ),
    );
  }
}
