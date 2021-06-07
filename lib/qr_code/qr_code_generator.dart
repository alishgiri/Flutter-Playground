import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QrCodeGenerator extends StatefulWidget {
  _QrCodeGeneratorState createState() => _QrCodeGeneratorState();
}

class _QrCodeGeneratorState extends State<QrCodeGenerator> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final Map<String, dynamic> data = {
      "_id": "FD89FD900DSF",
      "turf_id": "KKJR8F99AE9F9",
    };
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        iconTheme: IconThemeData(color: Colors.black),
        title: const Text(
          'QR Generator',
          style: const TextStyle(color: Colors.black),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            QrImage(
              data: jsonEncode(data),
              size: size.width * 0.7,
              version: QrVersions.auto,
              foregroundColor: Colors.blueGrey.shade900,
            ),
            Container(
              width: size.width * 0.7,
              child: Align(
                alignment: Alignment.centerRight,
                child: Image.asset(
                  "assets/app_icon.png",
                  width: 60,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
