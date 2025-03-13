import 'dart:io';
import 'package:flutter/material.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdfx/pdfx.dart';
import 'package:read_pdf_text/read_pdf_text.dart';
import 'package:smartbill/services.dart/pdf.dart';

class PDFListScreen extends StatefulWidget {
  const PDFListScreen({super.key});

  @override
  State<PDFListScreen> createState() => _PDFListScreenState();
}

class _PDFListScreenState extends State<PDFListScreen> {
  PdfHandler pdfHandler = PdfHandler();
  Directory? directory;
  List<File> pdfFiles = [];
  List<dynamic> pdfParsed= [];
  double total = 0;

  late Future<List<File>> _pdfFilesFuture;

  @override
  void initState() {
    super.initState();
    _pdfFilesFuture = _getDownloadedPdfs();
  }

  //Extract values from pdfText
  dynamic extractValuesFromPdf(String value, List<String>pdfLines) {

    for (String text in pdfLines) {
      
      if(text.toLowerCase().contains(value.toLowerCase())) {
        return text;
      }
      
    }

    return "NIT de la empresa";
  }

  Future<List<File>> _getDownloadedPdfs() async {
    Directory? appDir = await getExternalStorageDirectory();
    Directory invoicesDir = Directory("${appDir!.path}/invoices");

    if (!invoicesDir.existsSync()) return [];

    return invoicesDir
        .listSync()
        .where((file) => file.path.endsWith('.pdf'))
        .map((file) => File(file.path))
        .toList();
  }


  Future<PdfPageImage?> _generateThumbnail(File pdfFile) async {
    final document = await PdfDocument.openFile(pdfFile.path);
    final page = await document.getPage(1);

    final image = await page.render(
      width: page.width,
      height: page.height,
      format: PdfPageImageFormat.png,
    );

    await page.close();
    return image;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Invoices")),
      body: FutureBuilder<List<File>>(
        future: _pdfFilesFuture,
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
          List<File> pdfFiles = snapshot.data!;

          if (pdfFiles.isEmpty) return const Center(child: Text("No PDFs found"));

          return ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: pdfFiles.length,
            itemBuilder: (context, index) {
              File pdfFile = pdfFiles[index];

              return FutureBuilder<PdfPageImage?>(
                future: _generateThumbnail(pdfFile),
                builder: (context, snapshot) {
                  return ListTile(
                    leading: snapshot.hasData
                        ? Image.memory(snapshot.data!.bytes, width: 50, height: 50, fit: BoxFit.cover)
                        : const SizedBox(width: 50, height: 50, child: CircularProgressIndicator()),
                    title: Text(pdfFile.path.split('/').last),
                    onTap: () async {
                      await OpenFilex.open(pdfFile.path);
                    },
                  );
                },
              );
            },
          );
        },
      ),
    );
  }


}

