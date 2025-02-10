import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class QrcodeScreen extends StatefulWidget {
  final String? qrResult;
  const QrcodeScreen({super.key, required this.qrResult});

  @override
  State<QrcodeScreen> createState() => _QrcodeScreenState();
}

class _QrcodeScreenState extends State<QrcodeScreen> {
  WebViewController _controller = WebViewController();


  @override
  void initState() {
    
    super.initState();
    setWebView();
    print(widget.qrResult);
  }


  void setWebView() {
    setState(() {
      _controller =  WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
        // Update loading bar.
              },
              onPageStarted: (String url) {},
              onPageFinished: (String url) {},
              onHttpError: (HttpResponseError error) {},
              onWebResourceError: (WebResourceError error) {},
              onNavigationRequest: (NavigationRequest request) {
                if (request.url.startsWith('https://www.youtube.com/')) {
                  return NavigationDecision.prevent;
                }
                return NavigationDecision.navigate;
              },
            ),
          )
    ..loadRequest(Uri.parse(widget.qrResult!));
    });
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
            Expanded(child: WebViewWidget(controller: _controller))
          ],
        ),
      ),
    );
  }
}