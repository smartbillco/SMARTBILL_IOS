import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:smartbill/screens/receipts.dart/receipt_modal.dart';
import 'package:smartbill/screens/receipts.dart/receipt_widgets/delete_dialog.dart';
import 'package:smartbill/screens/receipts.dart/receipt_widgets/searchbar.dart';
import 'package:smartbill/screens/receipts.dart/receipt_widgets/total_sum.dart';
import 'package:smartbill/services.dart/pdf.dart';
import 'package:smartbill/services.dart/xml.dart';
import 'package:xml/xml.dart';

class ReceiptScreen extends StatefulWidget {
  const ReceiptScreen({super.key});

  @override
  State<ReceiptScreen> createState() => _ReceiptScreenState();
}

class _ReceiptScreenState extends State<ReceiptScreen> {
  final Xmlhandler xmlhandler = Xmlhandler();
  final PdfHandler pdfHandler = PdfHandler();
  double total = 0;
  List<dynamic> _fileContent = [];

  //Extract values from pdfText
  dynamic extractValuesFromPdf(String value, List pdfLines) {
    for (var text in pdfLines) {
      var textLowerCase = text.toLowerCase();
      if (textLowerCase.startsWith(value)) {
        var selectText = textLowerCase.toString().substring(4,);
        return selectText;
      }
    }
  }

  //Get all XML files from sqlite
  void getReceipts() async {
    var xmlFiles = await xmlhandler.getXmls();
    var pdfFiles = await pdfHandler.getPdfs();
    
    double totalPaid = 0;

    List myFiles = [];

    for (var item in xmlFiles) {
      XmlDocument xmlDocument = XmlDocument.parse(item['xml_text']);

      final cdataContent = xmlDocument
          .findAllElements('cbc:Description')
          .first
          .children
          .whereType<XmlCDATA>()
          .map((cdata) => cdata.value)
          .join();

      final xmlCData = XmlDocument.parse(cdataContent);


      Map parsedDoc = xmlhandler.xmlToMap(xmlDocument.rootElement);

      Map newXml = {
        '_id': item['_id'],
        'id_bill': parsedDoc['cbc:ID'],
        'customer': parsedDoc['cac:ReceiverParty']['cac:PartyTaxScheme'],
        'company': parsedDoc['cac:SenderParty']['cac:PartyTaxScheme'],
        'nit': parsedDoc['cac:SenderParty']['cac:PartyTaxScheme']
            ['cbc:CompanyID']['text'],
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
        'city': xmlCData
            .findAllElements('cbc:CityName')
            .toList()
            .last
            .innerText,
        'date': parsedDoc['cbc:IssueDate']['text'],
        'time': parsedDoc['cbc:IssueTime']['text'],
      };

      totalPaid += double.parse(newXml['price']);

      myFiles.add(newXml);
    }

    for(var item in pdfFiles) {

      List pdfTextLines = item['pdf_text'].split('\n');

      Map<String, dynamic> newPdf = {
        '_id': item['_id'],
        'nit': extractValuesFromPdf('nit', pdfTextLines),
        'price': '0'
      };

      myFiles.add(newPdf);

    }

    if (mounted) {
      setState(() {
        _fileContent = myFiles;
        total = totalPaid;
      });
    }
  }


  void redirectToBillDetail(Map receipt) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => BillDetailScreen(receipt: receipt)));
  }

  @override
  void initState() {
    super.initState();
    getReceipts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Mis recibos"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TotalSumWidget(total: total),
            const SizedBox(height: 25),
            const SearchbarWidget(),
            const SizedBox(height: 15),
            Expanded(
              child: _fileContent.isNotEmpty
                  ? ListView.builder(
                    padding: const EdgeInsets.all(7),
                      itemCount: _fileContent.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 5, horizontal: 0),
                          child: Material(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10)),
                            elevation: 12,
                            shadowColor: const Color.fromARGB(255, 185, 185, 185),
                            child: ListTile(
                              onTap: () => redirectToBillDetail(_fileContent[index]),
                              contentPadding:
                                  const EdgeInsets.fromLTRB(10, 3, 2, 3),
                              leading: CircleAvatar(
                                backgroundColor:
                                    const Color.fromARGB(255, 51, 51, 51),
                                child: _fileContent[index]['customer'] != null ?
                                Text(_fileContent[index]['customer']['cbc:RegistrationName']['text'][0].toUpperCase(),
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w400),
                                )  : const Text('F', style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 21,
                                      fontWeight: FontWeight.w500)),
                              ),
                              tileColor: const Color.fromARGB(244, 238, 238, 238),
                              title: _fileContent[index]['customer'] != null ?
                              Text(
                                  _fileContent[index]['customer']
                                          ['cbc:RegistrationName']['text']
                                      .toUpperCase(),
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16,
                                      height: 1.3)) : Text('PDF', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
                              subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 4),
                                    _fileContent[index]['company'] != null ?
                                    Text(
                                        _fileContent[index]['company']
                                            ['cbc:RegistrationName']['text'],
                                        style: const TextStyle(fontSize: 15))
                                    : const Text('Factura electrónica', style: TextStyle(fontSize: 16)),
                                    const SizedBox(height: 4),
                                    Text(
                                        "NIT: ${_fileContent[index]['nit']}"),
                                    Text("\$${NumberFormat('#,##0', 'en_US').format(double.parse(_fileContent[index]['price'])).toString()}"),
                                  ]),
                              trailing: IconButton(
                                  onPressed: () {
                                    showDialog(
                                        context: context,
                                        builder: (_) => DeleteDialogWidget(
                                            item: _fileContent[index],
                                            func: getReceipts));
                                  },
                                  icon: const Icon(Icons.delete, size: 25, color: Color.fromARGB(255, 218, 106, 99))),
                            ),
                          ),
                        );
                      },
                    )
                  : const Text("No hay archivos todavia"),
            ),
        ]),
      ),
    );
  }
}


