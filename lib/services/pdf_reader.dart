import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:http_parser/http_parser.dart'; 

class PdfService {


  Future<void> fetchPdfExtractor(File pdf) async {
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
      var pdfText = jsonDecode(responseString);
      print(pdfText['data']);
      
    } else {
      print('Upload failed with status: ${response.statusCode}');
    }

  }

}