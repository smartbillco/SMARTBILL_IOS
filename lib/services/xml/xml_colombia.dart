
import 'package:smartbill/services/xml/xml.dart';
import 'package:xml/xml.dart';

class XmlColombia extends Xmlhandler {

  String extractCData(XmlDocument xmlDocument) {

    final cDataContent = xmlDocument
          .findAllElements('cbc:Description')
          .first
          .children
          .whereType<XmlCDATA>()
          .map((cdata) => cdata.value)
          .join();

    return cDataContent;
  }

  XmlDocument parseCDataToXml(String cDataContent) {

    final xmlCData = XmlDocument.parse(cDataContent);

    return xmlCData;

  }

  Map<String, dynamic> parseColombianXml(int id, Map parsedDoc, XmlDocument xmlCData) {
    Map<String, dynamic> newXml = {
        '_id': id,
        'id_bill': parsedDoc['cbc:ID']['text'],
        'customer': parsedDoc['cac:ReceiverParty']['cac:PartyTaxScheme']['cbc:RegistrationName']['text'],
        'customer_id': parsedDoc['cac:ReceiverParty']['cac:PartyTaxScheme']['cbc:CompanyID']['text'],
        'company': parsedDoc['cac:SenderParty']['cac:PartyTaxScheme']['cbc:RegistrationName']['text'],
        'company_id': parsedDoc['cac:SenderParty']['cac:PartyTaxScheme']['cbc:CompanyID']['text'],
        'price': xmlCData
            .findAllElements('cbc:TaxInclusiveAmount')
            .toList()
            .last
            .innerText,
        'cufe': xmlCData
            .findAllElements('cbc:UUID')
            .toList()
            .last
            .innerText,
        'date': parsedDoc['cbc:IssueDate']['text'],
        'currency': 'COP'

    };

    return newXml;
  
  }

}