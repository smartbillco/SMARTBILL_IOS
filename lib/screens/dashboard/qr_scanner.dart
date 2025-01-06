import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QRScanner extends StatefulWidget {
  final Function setResult;
  const QRScanner({super.key, required this.setResult});

  @override
  State<QRScanner> createState() => _QRScannerState();
}

class _QRScannerState extends State<QRScanner> {

  MobileScannerController scannerController = MobileScannerController();

  @override
  Widget build(BuildContext context) {
    return MobileScanner(
      controller: scannerController,
      onDetect: (BarcodeCapture capture) async {
        final List<Barcode> barcodes = capture.barcodes;

        final qrResult = barcodes.first;

        if(qrResult.rawValue != null) {
          widget.setResult(qrResult.rawValue);

          await scannerController.stop().then((value) => scannerController.dispose()).then((value) => Navigator.of(context).pop());

          print(qrResult);
        }

        for(final barcode in barcodes) {
          print(barcode.rawValue);

        }

      },
    );
  }
}