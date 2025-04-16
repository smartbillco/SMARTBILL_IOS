import 'package:smartbill/services/xml/xml.dart';
import 'package:xml/xml.dart';


class XmlPanama extends Xmlhandler {

  Map<String, dynamic> parsedPanamaXml(int id, XmlDocument xml) {

    Map<String, dynamic> newXml = {
      '_id': id,
      'id_bill': xml.findAllElements('dNroDF').first.innerText,
      'customer': xml.findAllElements('dNombRec').first.innerText,
      'customer_id': "${xml.findAllElements('dPaisExt').first.innerText} - ${xml.findAllElements('dIdExt').first.innerText}",
      'company': xml.findAllElements('dInfEmFE').first.innerText,
      'company_id': xml.findAllElements('dRuc').first.innerText,
      'price': xml.findAllElements('dVTotItems').first.innerText,
      'cufe': xml.findAllElements('dId').first.innerText,
      'date': xml.findAllElements('dFechaFab').first.innerText,
      'currency': 'USD',
    };

    return newXml;

  }




}