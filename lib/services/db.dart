import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

 class DatabaseConnection {
  
  late Database db;

  Future openDb() async {
    var databasesPath = await getDatabasesPath();
    var path = join(databasesPath, 'smartbill.db');

    return db = await openDatabase(path, version: 4,
      //If creating the database for the first time
      onCreate: (Database db, int version) async {

        //Version 1
        await db.execute('''create table if not exists xml_files(_id integer primary key autoincrement, xml_text text not null)''');
        
        //Version 2
        await db.execute('''create table if not exists pdf_files(_id integer primary key autoincrement, pdf_text text not null)''');

        //Version 3
        await db.execute('''create table if not exists colombian_bill(_id integer primary key autoincrement, bill_number text not null, date text, time text, nit text, customer_id text, amount_before_iva text, iva text, other_tax text, total_amount text, cufe text)''');
        await db.execute('''create table if not exists peruvian_bill(_id integer primary key autoincrement, ruc_company text not null, receipt_id text, code_start text, code_end text, igv text, amount text, date text, percentage text, ruc_customer text, summery text)''');

        //Version 4
        await db.execute('''create table if not exists transactions(_id integer primary key autoincrement, userId text not null, amount real, date text, category text, description text, type text)''');

        //Version 5
        await db.execute('''create table if not exists favorites(_id integer primary key autoincrement, userId text not null, cryptoId text unique)''');
      
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if(oldVersion < 2) {
          await db.execute('''create table if not exists  pdf_files(_id integer primary key autoincrement, pdf_text text not null)''');
          await db.execute('''create table if not exists colombian_bill(_id integer primary key autoincrement, bill_number text not null, date text, time text, nit text, customer_id text, amount_before_iva text, iva text, other_tax text, total_amount text, cufe text)''');
          await db.execute('''create table if not exists peruvian_bill(_id integer primary key autoincrement, ruc_company text not null, receipt_id text, code_start text, code_end text, igv text, amount text, date text, percentage text, ruc_customer text, summery text)''');
          await db.execute('''create table if not exists income(_id integer primary key autoincrement, userId text not null, amount real, date text, category text, description text)''');
          await db.execute('''create table if not exists transactions(_id integer primary key autoincrement, userId text not null, amount real, date text, category text, description text, type text)''');
          await db.execute('''create table if not exists favorites(_id integer primary key autoincrement, userId text not null, cryptoId text unique)''');
        }
        if(oldVersion < 3) {
          await db.execute('''create table if not exists colombian_bill(_id integer primary key autoincrement, bill_number text not null, date text, time text, nit text, customer_id text, amount_before_iva text, iva text, other_tax text, total_amount text, cufe text)''');
          await db.execute('''create table if not exists peruvian_bill(_id integer primary key autoincrement, ruc_company text not null, receipt_id text, code_start text, code_end text, igv text, amount text, date text, percentage text, ruc_customer text, summery text)''');
          await db.execute('''create table if not exists transactions(_id integer primary key autoincrement, userId text not null, amount real, date text, category text, description text, type text)''');
          await db.execute('''create table if not exists favorites(_id integer primary key autoincrement, userId text not null, cryptoId text unique)''');
        }
        if(oldVersion < 4) {
          await db.execute('''create table if not exists transactions(_id integer primary key autoincrement, userId text not null, amount real, date text, category text, description text, type text)''');
          await db.execute('''create table if not exists favorites(_id integer primary key autoincrement, userId text not null, cryptoId text unique)''');
        } if(oldVersion < 5) {
          await deleteDatabase(path);
        }
      }
    );
  }

  Future closeDB() async => db.close();
  


  Future deleteDb() async {

    var databasesPath = await getDatabasesPath();
    var path = join(databasesPath, 'smartbill.db');

    await deleteDatabase(path);

    print("Couldn't delete database. Doesnt exists");
    
  }

}