import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:path_provider/path_provider.dart';
import 'package:smartbill/screens/QRcode/confirmDownload/confirm_download.dart';

class QrcodeLinkScreen extends StatefulWidget {
  final String? uri; 
  const QrcodeLinkScreen({super.key, required this.uri});

  @override
  State<QrcodeLinkScreen> createState() => _QrcodeLinkScreenState();
}

class _QrcodeLinkScreenState extends State<QrcodeLinkScreen> {
  late InAppWebViewController webViewController;
  bool cloudflarePassed = false;

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
            print(url.toString());
            if(url.toString().contains('ShowDocument')) {
              cloudflarePassed = true;
            } else {
              cloudflarePassed = false;
            }
            print("On load: $originalUrl");
            originalUrl ??= url.toString();
            
            print("On load: $url");
            print("On load: $originalUrl");
          
            
          },
          shouldOverrideUrlLoading: (controller, navigationAction) async {
            final url = navigationAction.request.url;

            final dir = Platform.isAndroid
              ? await getExternalStorageDirectory()
              : await getApplicationDocumentsDirectory();


          },
          onUpdateVisitedHistory: (controller, url, isReload) {
            // Option 1: URL check
            print("onUpdate 1: $url");
            print("onUpdate 2: $cloudflarePassed");
            print("onUpdate 3: $originalUrl");
            print("onUpdate 4: $url");

            if(Platform.isAndroid) {

              if(originalUrl != null && originalUrl != url.toString() && !hasNavigated && cloudflarePassed) {
                hasNavigated = true;
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ConfirmDownloadScreen(url: url.toString())));
              } else {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Por favor espera a que cloudflare te autentique")));

              }
              
            }
            print("Triggered updated");
            
          },
          
        ),
      ),
    );
  }
}