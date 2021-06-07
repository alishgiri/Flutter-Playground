import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:test_in_flutter/qr_code/qr_code_generator.dart';

class QrCodeReader extends StatefulWidget {
  _QrCodeReaderState createState() => _QrCodeReaderState();
}

class _QrCodeReaderState extends State<QrCodeReader> {
  Barcode result;
  QRViewController controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller.pauseCamera();
    } else if (Platform.isIOS) {
      controller.resumeCamera();
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final scanArea =
        (size.width < 400 || size.height < 400) ? size.width : 300.0;
    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 5,
            // To ensure the Scanner view is properly sizes after rotation
            // we need to listen for Flutter SizeChanged notification and update controller
            child: NotificationListener<SizeChangedLayoutNotification>(
              onNotification: (notification) {
                Future.microtask(
                  () => QRViewController.updateDimensions(
                    qrKey,
                    MethodChannel("setDimensions"),
                  ),
                );
                return false;
              },
              child: SizeChangedLayoutNotifier(
                key: const Key('qr-size-notifier'),
                child: QRView(
                  key: qrKey,
                  cameraFacing: CameraFacing.back,
                  overlay: QrScannerOverlayShape(
                    borderWidth: 30,
                    borderRadius: 30,
                    borderLength: 30,
                    cutOutSize: scanArea,
                    borderColor: Colors.blue.shade600,
                  ),
                  onQRViewCreated: _onQRViewCreated,
                ),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: (result != null)
                      ? Text(
                          'Barcode Type: ${describeEnum(result.format)}   Data: ${result.code}',
                          textAlign: TextAlign.center,
                          textWidthBasis: TextWidthBasis.parent,
                        )
                      : Text(
                          'Scan a code',
                          textAlign: TextAlign.center,
                        ),
                ),
                IconButton(
                  icon: Icon(Icons.qr_code),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => QrCodeGenerator()),
                    );
                  },
                ),
                const SizedBox(width: 20)
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
      });
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
