import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:path_provider/path_provider.dart';
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
                  final url = request.url;
                  
                  _requestPermissions();
                    
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}