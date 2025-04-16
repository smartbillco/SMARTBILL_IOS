import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:http_parser/http_parser.dart';
import 'package:smartbill/models/pdf.dart';
import 'package:smartbill/services/db.dart'; 

class PdfService {

  Future<dynamic> extractTextfromPdf(File pdf) async {
    final uri = Uri.parse('http://207.244.226.48:8086/ocr/extract-details/pdf');

    var request = http.MultipartRequest('POST', uri);

    // Add pdf to request
    request.files.add(
      await http.MultipartFile.fromPath(
        'file', // Field name on the server
        pdf.path,
        filename: basename(pdf.path),
        contentType: MediaType('application', 'pdf'),
      ),
    );

    // Optional: Add headers or other fields
    request.headers.addAll({
      'Content-Type': 'multipart/form-data',
    });

    // Send the request
    var response = await request.send();

    // Handle response
    if (response.statusCode == 200) {
      String responseString = await response.stream.bytesToString();
      Map<String, dynamic> pdfText = jsonDecode(responseString);
      print(pdfText['data']);
      return pdfText['data'];
      
    } else {
      print('Upload failed with status: ${response.statusCode}');
    }

  }

  Future<void> saveExtractedText(File pdfFile) async {
    Map<String, dynamic> pdfData = await extractTextfromPdf(pdfFile);
    

    if(pdfData['MONTO_TOTAL'].contains('.')) {
      int lastDot = pdfData['MONTO_TOTAL'].lastIndexOf('.');
      String integerPart = pdfData['MONTO_TOTAL'].substring(0, lastDot).replaceAll('.', '');
      String decimalPart = pdfData['MONTO_TOTAL'].substring(lastDot + 1);
      String formattedNumber = "$integerPart.$decimalPart";
      double amount = double.parse(formattedNumber);

      print("PRINT: $amount");

      final Pdf pdf = Pdf(cufe: pdfData['CUFE'], nit: pdfData['NIT'], date: pdfData['FECHA'], totalAmount: amount);

      int result = await pdf.insertToDatabase();

      print("El registro número $result, se creó");

    } else {

      final double amount = double.parse(pdfData['MONTO_TOTAL']);

      final Pdf pdf = Pdf(cufe: pdfData['CUFE'], nit: pdfData['NIT'], date: pdfData['FECHA'], totalAmount: amount);

      int result = await pdf.insertToDatabase();

      print("El registro número $result, se creó");
    }
    

  }

  Future<dynamic> fetchAllPdfs() async {
    DatabaseConnection databaseConnection = DatabaseConnection();
    var db = await databaseConnection.openDb();
    var result = await db.query('pdfs');
    return result;

  }


  Future<void> deletePdf(int id) async {
    try {
      DatabaseConnection databaseConnection = DatabaseConnection();
      var db = await databaseConnection.openDb(); 
      await db.delete('pdfs', where: '_id = ?', whereArgs: [id]);
      print("deleted");
    } catch (e){
      print("Could not delete: $e");
    }
  }

}