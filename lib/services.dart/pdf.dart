import 'package:flutter/services.dart';
import 'package:read_pdf_text/read_pdf_text.dart';

class PdfHandler {

  Future<String> getPDFtext(String path) async {
    String text = "";
    try {
      text = await ReadPdfText.getPDFtext(path);
    } on PlatformException {
      print('Failed to get PDF text.');
    }
    return text;
  }

  Future<List<String>> getPDFtextPag(String path) async {
    List<String> text = [];
    try {
      text = await ReadPdfText.getPDFtextPaginated(path);
    } on PlatformException {
      print('Failed to get PDF text.');
    }
    return text;
  }

}