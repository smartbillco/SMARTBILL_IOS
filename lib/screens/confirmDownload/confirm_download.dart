import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:smartbill/screens/dashboard/dashboard.dart';

class ConfirmDownloadScreen extends StatefulWidget {
  final String url;
  const ConfirmDownloadScreen({super.key, required this.url});

  @override
  State<ConfirmDownloadScreen> createState() => _ConfirmDownloadScreenState();
}

class _ConfirmDownloadScreenState extends State<ConfirmDownloadScreen> {
  String downloadUrl = "";
  bool isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    formDownloadUrl();
  }

  String getTrackId() {
    Uri uri = Uri.parse(widget.url);
    List<String> segments = uri.pathSegments;

    if (segments.isNotEmpty) {
      String extractedId = segments.last;
      return extractedId;
    }
    return "no id found";
  }

  String getTokenFromUrl() {
    Uri uri = Uri.parse(widget.url);

    // Extracting the 'Token' query parameter
    String? token = uri.queryParameters['Token'];

    if (token != null) {
      return token;
    } else {
      return "no token found";
    }
  }

  void showSnackbar(String content) {
    final snackbar = SnackBar(content: Text(content));

    ScaffoldMessenger.of(context).showSnackBar(snackbar);
  }

  void formDownloadUrl() {
    String id = getTrackId();
    String token = getTokenFromUrl();

    setState(() {
      downloadUrl =
          "https://catalogo-vpfe.dian.gov.co/Document/DownloadPDF?trackId=${id}&token=${token}";
    });

    print("This is the download url: $downloadUrl");
  }

  Future<void> downloadPdfDian() async {
    isLoading = true;

    final dir = await getExternalStorageDirectory(); // Returns app's external storage
    final path = "${dir!.path}/invoices";
    await Directory(path).create(recursive: true);

    String fileName = "invoice_${DateTime.now().millisecondsSinceEpoch}.pdf";

    try {
      await FlutterDownloader.enqueue(
        url: downloadUrl,
        savedDir: path,
        fileName: fileName,
        showNotification: true,
        openFileFromNotification: true,
      );

      isLoading = false;

      showSnackbar("Se ha descargado la factura");

      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const DashboardScreen()));

    } catch (e) {

      showSnackbar("Ha ocurrido un problema con el PDF");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: isLoading
        ? CircularProgressIndicator()
        : AlertDialog(
          shadowColor: Colors.grey,
          title: const Text("Desea descargar el archivo?"),
          actions: [
            TextButton(
              onPressed: downloadPdfDian,
              child: const Text("Sí", style: TextStyle(color: Colors.green))
            ),
            TextButton(
              onPressed: () {
                showSnackbar("No se descargo el archivo");
                Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const DashboardScreen()), (r) => false);
              },
              child: const Text("No", style: TextStyle(color: Colors.redAccent))
            )
          ],
        ),
      ),
    );
  }
}
