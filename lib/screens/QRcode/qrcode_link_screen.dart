import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:smartbill/screens/QRcode/confirmDownload/confirm_download.dart';

class QrcodeLinkScreen extends StatefulWidget {
  final String? uri; 
  const QrcodeLinkScreen({super.key, required this.uri});

  @override
  State<QrcodeLinkScreen> createState() => _QrcodeLinkScreenState();
}

class _QrcodeLinkScreenState extends State<QrcodeLinkScreen> {
  late InAppWebViewController webViewController;

  //DIAN receipt variables
  String? originalUrl;
  bool hasNavigated = false;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  void showSnackbar(String content) {
    final snackbar = SnackBar(content: Text(content));

    ScaffoldMessenger.of(context).showSnackBar(snackbar);
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text("Descargar factura"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 35),
        child: InAppWebView(
          initialSettings: InAppWebViewSettings(
            javaScriptEnabled: true,
            useOnDownloadStart: true,
            allowFileAccess: true,
            allowContentAccess: true,
            useHybridComposition: true,
          ),
          initialUrlRequest: URLRequest(url: WebUri(widget.uri!)),
          onWebViewCreated: (controller) {
            webViewController = controller;
          },
          onLoadStart: (controller, url) {
            print("On load: $url");
            originalUrl ??= url.toString();
          },
          onUpdateVisitedHistory: (controller, url, isReload) {
            print("onUpdate: $url");
            if(originalUrl != null && originalUrl != url.toString() && !hasNavigated) {
              hasNavigated = true;
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ConfirmDownloadScreen(url: url.toString())));
            }
          },
        ),
      ),
    );
  }
}