import 'dart:io';
import 'package:xml/xml.dart';
import 'db.dart';

class Xmlhandler {


  Map<String, dynamic> xmlToMap(XmlElement element) {
    final Map<String, dynamic> map = {};

    // If the element has attributes, add them to the map
    for (var attribute in element.attributes) {
      map[attribute.name.toString()] = attribute.value;
    }

    // Add children or text content
    for (final node in element.children) {
      if (node is XmlElement) {
        // Recursive call for nested elements
        map[node.name.toString()] = xmlToMap(node);
      } else if (node is XmlText && node.value.trim().isNotEmpty) {
        map['text'] = node.value.trim();
      }
    }

    return map;
  }


  Future<Map> getXml(String pathFile) async {
    try {

      File file = File(pathFile);
      String fileData = await file.readAsString();

      final xmlDocument = XmlDocument.parse(fileData);

      insertXml(xmlDocument.toString());

      Map<String, dynamic> parsedMap = xmlToMap(xmlDocument.rootElement);

      return parsedMap;


    } catch (e) {
      return {"response":"Couldn't upload XML file: $e"};

    }
  }
   Future insertXml(String xml) async {
    DatabaseConnection databaseConnection = DatabaseConnection();
    var db = await databaseConnection.openDb();
    var result = await db.insert('xml_files', {'xml_text':xml});
    databaseConnection.closeDB();
    return result;

  }

  Future getXmls() async {
    DatabaseConnection databaseConnection = DatabaseConnection();
    var db = await databaseConnection.openDb();
    var xmlFiles = await db.query('xml_files');
    databaseConnection.closeDB();
    return xmlFiles;
  }
  Future<void> deleteXml(int id) async {
    DatabaseConnection databaseConnection = DatabaseConnection();
    var db = await databaseConnection.openDb();
    
    await db.delete('xml_files', where: '_id = ?', whereArgs: [id]);
    databaseConnection.closeDB();
  }

}