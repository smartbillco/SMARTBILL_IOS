import 'dart:io';
import 'package:flutter/material.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdfx/pdfx.dart';

class PDFListScreen extends StatefulWidget {
  const PDFListScreen({super.key});

  @override
  State<PDFListScreen> createState() => _PDFListScreenState();
}

class _PDFListScreenState extends State<PDFListScreen> {

  Directory? directory;
  List<File> pdfFiles = [];


  @override
  void initState() {
    super.initState();
    _loadDocuments();
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
        title: Text("PDFs"),
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Center(
          child: pdfFiles.isEmpty 
          ? const Text("No tienes PDFs todavía. Escanea un código QR para comenzar.")
          : GridView.builder(
                padding: const EdgeInsets.all(8),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                  childAspectRatio: 0.7,
                ),
                itemCount: pdfFiles.length,
                itemBuilder: (context, index) {
                  return FutureBuilder<PdfPageImage?>(
                    future: _generateThumbnail(pdfFiles[index]),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return Center(child: CircularProgressIndicator());
                      }
                      return Stack(
                        children: [
                          GestureDetector(
                            onTap: () async {
                              await OpenFilex.open(pdfFiles[index].path);
                            },
                            child: Image.memory(snapshot.data!.bytes),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: IconButton(
                              icon: Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _deleteFile(pdfFiles[index]),
                            ),
                          ),
                        ],
                      );
                    },
                  );
                },
            ),
        ),
      ),
    );
  }
}