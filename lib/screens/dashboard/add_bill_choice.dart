import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:smartbill/services/pdf_reader.dart';
import 'package:smartbill/screens/receipts.dart/receipt_screen.dart';
import 'package:smartbill/services/pdf.dart';
import 'package:smartbill/services/xml/xml.dart';

class AddBillChoice extends StatefulWidget {
  const AddBillChoice({super.key});

  @override
  State<AddBillChoice> createState() => _AddBillChoiceState();
}

class _AddBillChoiceState extends State<AddBillChoice> {
  final Xmlhandler xmlhandler = Xmlhandler();
  final PdfHandler pdfHandler = PdfHandler();
  final PdfService pdfService = PdfService();

  //Snackbar for receipt cancel
  //Cancelled picking a xml file
  void _showSnackbarCancelXml() {
    var snackbar = const SnackBar(
      content: Text("No elegiste una factura"),
      duration: Duration(seconds: 2),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackbar);
  }



  //Open files and save and display a new XML
  Future<void> _pickAndDisplayXMLFile() async {
    FilePickerResult? fileResult = await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ['xml']);

    if (fileResult != null) {
      String filePath = fileResult.files.single.path!;
      String fileName = fileResult.files.single.name.toLowerCase();

       if (fileName.endsWith('.xml')) {
        await xmlhandler.getXml(filePath);

        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const ReceiptScreen()));
      }
    } else {
      print("Se cancelo");
      _showSnackbarCancelXml();
    }
  }

  //Open files and save and display a new XML
  Future<void> _pickAndDisplayPDFFile() async {
    FilePickerResult? fileResult = await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ['pdf']);

    if (fileResult != null) {
      String filePath = fileResult.files.single.path!;
      File pdfFile = File(filePath);
      //String fileName = fileResult.files.single.name.toLowerCase();

      await pdfService.fetchPdfExtractor(pdfFile);

      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const ReceiptScreen()));
      
    } else {
      print("Se cancelo");
      _showSnackbarCancelXml();
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Agregar factura"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            Card(
              elevation: 4,
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: ListTile(
                onTap: _pickAndDisplayXMLFile,
                contentPadding: const EdgeInsets.all(10),
                leading: const Icon(Icons.code, color: Colors.orange, size: 28),
                title: const Text("Subir archivo XML"),
                trailing: const Icon(Icons.arrow_forward_ios, color: Colors.grey),
              ),
            ),
            Card(
              elevation: 4,
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: ListTile(
                onTap: _pickAndDisplayPDFFile,
                contentPadding: const EdgeInsets.all(10),
                leading: const Icon(Icons.picture_as_pdf, color: Colors.red, size: 28),
                title: const Text("Subir archivo PDF"),
                trailing: const Icon(Icons.arrow_forward_ios, color: Colors.grey),
              ),
            ),
            Card(
              elevation: 4,
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: ListTile(
                onTap: () {

                },
                contentPadding: const EdgeInsets.all(10),
                leading: const Icon(Icons.image, color: Colors.green, size: 28),
                title: const Text("Subir imagen de factura"),
                trailing: const Icon(Icons.arrow_forward_ios, color: Colors.grey),
              ),
            )
          ],
        ) 
      ),
    );
  }
}