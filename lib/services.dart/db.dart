import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

 class DatabaseConnection {
  
  late Database db;

  Future openDb() async {
    var databasesPath = await getDatabasesPath();
    var path = join(databasesPath, 'smartbill.db');

    return db = await openDatabase(path, version: 1,
      onCreate: (Database db, int version) async {
        await db.execute('''create table xml_files(_id integer primary key autoincrement, xml_text text not null)''');
        
      },
    );
  }

  Future closeDB() async => db.close();



}