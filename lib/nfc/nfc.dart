import 'dart:async';

import 'package:flutter/material.dart';
import 'package:nfc_in_flutter/nfc_in_flutter.dart';

class NFCReader extends StatefulWidget {
  @override
  _NFCReaderState createState() => _NFCReaderState();
}

class _NFCReaderState extends State {
  bool _reading = false;
  bool _supportsNFC = false;
  StreamSubscription<NDEFTag> _tagStream;
  StreamSubscription<NDEFMessage> _msgStream;

  @override
  void initState() {
    super.initState();
    // Check if the device supports NFC reading
    NFC.isNDEFSupported.then((bool isSupported) {
      setState(() {
        _supportsNFC = isSupported;
      });
    });
  }

  void readNdf() {
    _reading = true;
    // Start reading using NFC.readNDEF()
    _msgStream = NFC.readNDEF(once: true, throwOnUserCancel: false).listen(
      (NDEFMessage message) {
        print("read NDEF message: ${message.payload}");
        message.tag.write(
          NDEFMessage.withRecords([NDEFRecord.text("hello world")]),
        );
      },
      onDone: () {
        print("COMPLETED READING!!");
      },
      onError: (e) {
        print('Error Reading NFC');
        print(e);
        // Check error handling guide below
      },
    );
  }

  void writeNdf() {
    _reading = true;
    final ndfMsg = NDEFMessage.withRecords([NDEFRecord.text("hello world")]);
    _tagStream = NFC
        .writeNDEF(
      ndfMsg,
      once: true,
      message: "Gym Synergy AR",
    )
        .listen(
      (NDEFTag tag) {
        print("read NDEF message: ${tag.id}");
      },
      onDone: () {
        print("COMPLETED READING!!");
        _reset();
      },
      onError: (e) {
        print('Error Reading NFC');
        print(e);
        // Check error handling guide below
      },
    );
  }

  void _reset() {
    _tagStream?.cancel();
    _msgStream?.cancel();
    setState(() => _reading = false);
  }

  @override
  Widget build(BuildContext context) {
    if (!_supportsNFC) {
      return RaisedButton(
        child: const Text("You device does not support NFC"),
        onPressed: null,
      );
    }

    return RaisedButton(
      child: Text(_reading ? "Stop reading" : "Start reading"),
      onPressed: () {
        if (_reading) {
          _reset();
        } else {
          setState(() => writeNdf());
        }
      },
    );
  }
}
