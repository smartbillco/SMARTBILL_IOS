import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:smartbill/screens/PDFList/pdf_list.dart';
import 'package:smartbill/services.dart/pdf.dart';


class QrcodeScreen extends StatefulWidget {
  final String? qrResult;
  const QrcodeScreen({super.key, required this.qrResult});

  @override
  State<QrcodeScreen> createState() => _QrcodeScreenState();
}

class _QrcodeScreenState extends State<QrcodeScreen> {
  PdfHandler pdfHandler = PdfHandler();
  bool isUri = true;
  late InAppWebViewController webViewController;
  Map pdfPeru = {};


  @override
  void initState() {
    super.initState();
    isValidUri();

  }


  void isValidUri() {
    setState(() {
      isUri = Uri.tryParse(widget.qrResult!)?.hasScheme ?? false;
      pdfPeru = pdfHandler.parseQrPeru(widget.qrResult!);
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  void showSnackbar(String content) {
    var snackbar = SnackBar(content: Text(content));

    ScaffoldMessenger.of(context).showSnackBar(snackbar);
  }

  //Navigator is changing screens before the file has been created
  Future<void> delayNagivation() async {
    await Future.delayed(Duration(seconds: 5));
    print("Changing screens");

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Descargar factura"),
      ),
      body: Container(
        padding: EdgeInsets.all(25),
        child: Column(
          children: [
              isUri ?  
              Expanded(
                child: InAppWebView(
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

                    Directory? saveDirectory = await getDownloadsDirectory();

                    String filepath = saveDirectory!.path;

                    final String filename = '${request.url.toString().split('=').last}.pdf';

                    try {
                        final taskId = FlutterDownloader.enqueue(
                        url: request.url.toString(),
                        savedDir: filepath,
                        fileName: filename,
                        showNotification: true,
                        openFileFromNotification: true,
                      );

                    
                      showSnackbar("Archivo descargado. Estamos redireccionando.");

                      await delayNagivation();
                        
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const PDFListScreen()));

                    } catch(e) {
                      print("ERROR! $e");
                      showSnackbar("Ha ocurrido un problema con el PDF");

                    }
                  },
                ),
              ): 
              SizedBox(
                height: 450,
                child: Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 4,
                  margin: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Factura No. ${pdfPeru['code_start']} - ${pdfPeru['code_end']}",
                          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        const Divider(),
                        const SizedBox(height:10),
                        _buildRow("NIF", pdfPeru['ruc_company']),
                        _buildRow("Código", pdfPeru['receipt_id']),
                        _buildRow("IGV", pdfPeru['igv']),
                        _buildRow("Pago", pdfPeru['amount']),
                        _buildRow("Fecha", pdfPeru['date']),
                        _buildRow("RUC Cliente", pdfPeru['ruc_customer']),
                        const SizedBox(height: 30),
                        SizedBox(
                          width: MediaQuery.of(context).size.width - 10,
                          child: ElevatedButton(
                            style: const ButtonStyle(
                              backgroundColor: WidgetStatePropertyAll(Colors.greenAccent)
                            ),
                            onPressed: () {
                              
                            },
                            child: const Text("Guardar factura")
                          ),
                        )
                      ],
                    ),
                  ),
                )
              )
            
          ],
        ),
      ),
    );
  }
}



  Widget _buildRow(String title, String value) {
    
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
          ),
          Text(value,
          style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 16),),
        ],
      ),
    );
  }

