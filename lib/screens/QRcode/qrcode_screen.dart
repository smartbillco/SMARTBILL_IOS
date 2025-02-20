import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;


class QrcodeScreen extends StatefulWidget {
  final String? qrResult;
  const QrcodeScreen({super.key, required this.qrResult});

  @override
  State<QrcodeScreen> createState() => _QrcodeScreenState();
}

class _QrcodeScreenState extends State<QrcodeScreen> {
  late InAppWebViewController webViewController;


  @override
  void initState() {
    super.initState();
    print(widget.qrResult);
    _requestPermissions();
  }

   // Request storage permissions
  Future<void> _requestPermissions() async {
    if (Platform.isAndroid) {
      await Permission.storage.request();
      await Permission.notification.request();
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _downloadFile(String url) async {
    try {
    print("Fetching PDF from: $url");

    // Request the file from the server
    var response = await http.get(Uri.parse(url));

    // Check if the response is OK
    if (response.statusCode == 200) {
      final directory = Directory("/storage/emulated/0/Download");
      String fileName = "downloaded_bill";
      String savePath = "${directory!.path}/$fileName";

      // Write the file to storage
      File file = File(savePath);
      await file.writeAsBytes(response.bodyBytes);

      print("PDF Saved to: $savePath");
    } else {
      print("Failed to download file. Status: ${response.statusCode}");
    }
  } catch (e) {
    print("Download error: $e");
  }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Descargar factura"),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
        child: Column(
          children: [
            Expanded(
              child:  InAppWebView(
                initialSettings: InAppWebViewSettings(
                  useOnDownloadStart: true,
                  allowFileAccess: true,
                  allowContentAccess: true,
                ),
                initialUrlRequest: URLRequest(url: WebUri.uri(Uri.parse(widget.qrResult!))),
                onWebViewCreated: (controller) {
                  webViewController = controller;
                },
                onDownloadStartRequest: (controller, request) async {
                  String url = request.url.toString();
                  print("Download Triggered: $url");

                  await _downloadFile(url);
},
              ),
            )
          ],
        ),
      ),
    );
  }
}