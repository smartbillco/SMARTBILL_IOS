import 'dart:io';
import 'package:xml/xml.dart';


class Xmlhandler {


  Map<String, dynamic> xmlToMap(XmlElement element) {
    final Map<String, dynamic> map = {};

    // If the element has attributes, add them to the map
    element.attributes.forEach((attribute) {
      map[attribute.name.toString()] = attribute.value;
    });

    // Add children or text content
    for (final node in element.children) {
      if (node is XmlElement) {
        // Recursive call for nested elements
        map[node.name.toString()] = xmlToMap(node);
      } else if (node is XmlText && node.text.trim().isNotEmpty) {
        map['text'] = node.text.trim();
      }
    }

    return map;
  }


  Future<Map> getXml(String pathFile) async {
    try {

      File file = File(pathFile);
      String fileData = await file.readAsString();

      final xmlDocument = XmlDocument.parse(fileData);

      Map<String, dynamic> parsedMap = this.xmlToMap(xmlDocument.rootElement);

      return parsedMap;


    } catch (e) {
      return {"response":"Couldn't upload XML file: $e"};

    }
  }

}