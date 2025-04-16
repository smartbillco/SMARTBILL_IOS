import 'package:smartbill/services/db.dart';

class Pdf {
  final int? id;
  final String cufe;
  final String nit;
  final String date;
  final double totalAmount;

  DatabaseConnection databaseConnection = DatabaseConnection();

  Pdf({this.id, required this.cufe, required this.nit, required this.date, required this.totalAmount});

  //Factory to create Pdf
  factory Pdf.fromMap(Map<String, dynamic> map) {
    return Pdf(
      id: map['id'],
      cufe: map['cufe'],
      nit: map['nit'],
      date: map['date'],
      totalAmount: map['totalAmount']

    );

  }

  //Turn result into Map
  Map<String, dynamic> pdfToMap() {
    final map = {
      'cufe': cufe,
      'nit': nit,
      'date': date,
      'total_amount': totalAmount
    };
    if (id != null) {
      map['id'] = id!;
    }
    return map;
  }

  //Insert into database
  Future<int> insertToDatabase() async{
    var db = await databaseConnection.openDb();
    return await db.insert('pdfs', pdfToMap());
  }

}