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


  @override
  void initState() {
    super.initState();
    _loadDocuments();

  }

  //Extract values from pdfText
  dynamic extractValuesFromPdf(String value, List<String>pdfLines) {

    for (String text in pdfLines) {
      
      if(text.toLowerCase().contains(value.toLowerCase())) {
        return text;
      }
      
    }

    return "Not found";
  }

  Future<void> _loadDocuments() async {

    directory = await getDownloadsDirectory();

    if(!directory!.existsSync()) {
      print("No directory found");
      return;
    }

    List<FileSystemEntity> files = directory!.listSync();
    List<File> pdfs = files
        .where((file) => file.path.endsWith('.pdf'))
        .map((file) => File(file.path))
        .toList();

    setState(() {
      pdfFiles = pdfs;
    });

    List pdfsDian = [];

    for (var file in pdfFiles) {
      String text;
     
      text = await ReadPdfText.getPDFtext(file.path);

      List<String> pdfSplit = text.split('\n');

      String bill_number = extractValuesFromPdf("Número de Factura", pdfSplit);
      String company = extractValuesFromPdf("Razón Social", pdfSplit);
      String date = extractValuesFromPdf("Fecha de Emisión", pdfSplit);

      Map parsedDian = pdfHandler.parseDIANpdf(bill_number, company, date, '0');

      pdfsDian.add(parsedDian);
      
    }

    setState(() {
      pdfParsed = pdfsDian;
    });

    print(pdfParsed);
    
  }


  Future<PdfPageImage?> _generateThumbnail(File pdfFile) async {
    final document = await PdfDocument.openFile(pdfFile.path);
    final page = await document.getPage(1); // Load the first page
    final image = await page.render(
      width: page.width,
      height: page.height,
      format: PdfPageImageFormat.png,
    );
    await page.close();
    return image;
  }


  void _deleteFile(File file) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Eliminar PDF?"),
        content: const Text("Esta seguro de que desea eliminar el PDF?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancelar"),
          ),
          TextButton(
            onPressed: () async {
              if (await file.exists()) {
                await file.delete();
                setState(() {
                  pdfFiles.remove(file);
                });
              }
              Navigator.pop(context);
            },
            child: const Text("Eliminar", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("PDFs"),
      ),
      body: Column(
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width - 80,
            height: 80,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Total: $total"),
                Text("Facturas: 0")

              ],
            ),
          ),
          Expanded( // ✅ Wrap ListView.builder inside Expanded
            child: Container(
              padding: const EdgeInsets.all(20),
              child: Center(
                child: pdfFiles.isEmpty
                    ? const Text("No tienes PDFs todavía. Escanea un código QR para comenzar.")
                    : ListView.builder(
                        padding: EdgeInsets.all(8),
                        itemCount: pdfFiles.length,
                        itemBuilder: (context, index) {
                          return FutureBuilder<PdfPageImage?>(
                            future: _generateThumbnail(pdfFiles[index]),
                            builder: (context, snapshot) {
                              return ListTile(
                                leading: snapshot.hasData
                                    ? Image.memory(snapshot.data!.bytes, width: 50, height: 50, fit: BoxFit.cover)
                                    : SizedBox(width: 50, height: 50, child: CircularProgressIndicator()),
                                title: Text(pdfFiles[index].path.split('/').last),
                                onTap: () async {
                                  await OpenFilex.open(pdfFiles[index].path);
                                },
                              );
                            },
                          );
                        },
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}