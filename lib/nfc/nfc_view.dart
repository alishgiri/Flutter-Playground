import 'package:flutter/material.dart';
import 'package:test_in_flutter/nfc/nfc.dart';

class NfcView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("NFC Reader")),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            NFCReader(),
          ],
        ),
      ),
    );
  }
}
