import 'package:smartbill/services/db.dart';
import 'package:sqflite/sqflite.dart';


class Transaction {
  
  final String userId;
  final double amount;
  final String date;
  final String description;
  final String category;
  final String type;

  Transaction({required this.userId, required this.amount, required this.date, required this.description, required this.category, required this.type});

  Map<String, dynamic> converTransactionToMap() {
    return {
      'userId': userId,
      'amount': amount,
      'date': date,
      'description': description,
      'category': category,
      'type': type
    };
  }


  Future<void> saveNewTransaction() async {

    try {
      DatabaseConnection databaseConnection = DatabaseConnection();
      var db = await databaseConnection.openDb();

      await db.insert('transactions', converTransactionToMap(),conflictAlgorithm: ConflictAlgorithm.replace,);

    } catch(e) {
      print("Error al guardar transaccion: $e");
    } finally {
      print("Se termino el proceso");
    }
    
  }

}