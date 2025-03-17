import 'package:flutter/services.dart';
import 'package:read_pdf_text/read_pdf_text.dart';
import 'package:smartbill/services.dart/db.dart';

class PdfHandler {

  //Read QR bill from Peru
  Map<String, dynamic> parseQrPeru(String qrResult) {

    try {
      List qrList = qrResult.split('|');
      List keys = ['ruc_company', 'receipt_id', 'code_start', 'code_end', 'igv', 'amount', 'date', 'percentage', 'ruc_customer', 'summery'];

      Map<String, dynamic> qrPdf = {};

      for (var i = 0; i < keys.length; i++) {
         if (i >= qrList.length || qrList[i].trim().isEmpty) {
            qrPdf[keys[i]] = "Empty";
          } else {
            qrPdf[keys[i]] = qrList[i];
          }
        
      }

      print(qrPdf);

      return qrPdf;
    } catch(e) {
      Map<String, dynamic> error = {
        'error': e
      };
      return error;
    }
    
  }


  //Parse info into pdf
  Map <String, dynamic> parsePdf(dynamic id, dynamic companyId, String text) {
    final Map<String, dynamic> newPdf = {
        '_id': id,
        'id_bill': '',
        'customer': 'PDF',
        'company': '',
        'company_id': companyId,
        'price': '0',
        'cufe': '',
        'city': '',
        'date': '',
        'time': '',
        'currency': 'PDF',
        'text': text
    };

    return newPdf;

  }

  Future getPdfs() async {
    DatabaseConnection databaseConnection = DatabaseConnection();
    var db = await databaseConnection.openDb();
    var pdfFiles = await db.query('pdf_files');
    return pdfFiles;
  }

  Future<String> getPDFtext(String path) async {
    String text = "";
    try {
      text = await ReadPdfText.getPDFtext(path);
      insertPdf(text);
    } on PlatformException {
      print('Failed to get PDF text.');
    }
    return text;
  }

  Future insertPdf(String pdf) async {
    DatabaseConnection databaseConnection = DatabaseConnection();
    var db = await databaseConnection.openDb();
    var result = await db.insert('pdf_files', {'pdf_text':pdf});
    return result;
  }

  Future<void> deletePdf(int id) async {
    DatabaseConnection databaseConnection = DatabaseConnection();
    var db = await databaseConnection.openDb();
    
    await db.delete('pdf_files', where: '_id = ?', whereArgs: [id]);
  }


  Map<String, dynamic> parseDIANpdf(String billNumber, String company, String? date, String? total) {
    Map<String, dynamic> dianPdf = {
      'bill_number': billNumber,
      'company': company,
      'date': date,
      'total': total
    };

    return dianPdf;

  }


}