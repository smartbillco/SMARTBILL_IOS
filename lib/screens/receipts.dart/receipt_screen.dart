import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
        'customer': parsedDoc['cac:ReceiverParty']['cac:PartyTaxScheme'],
        'company': parsedDoc['cac:SenderParty']['cac:PartyTaxScheme'],
        'nit': parsedDoc['cac:SenderParty']['cac:PartyTaxScheme']
            ['cbc:CompanyID']['text'],
        'price': xmlCData
            .findAllElements('cbc:TaxInclusiveAmount')
            .toList()
            .last
            .innerText
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

  @override
  void initState() {
    super.initState();
    getReceipts();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) {
        if(didPop) {
          return;
        } 
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Mis recibos"),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                height: 120,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  gradient: const LinearGradient(colors: [Color.fromARGB(255, 68, 95, 109), Colors.black87])
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Tu total hasta hoy", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w200)),
                    const SizedBox(height: 5),
                    Text("\$${NumberFormat('#,##0', 'en_US').format(total).toString()}",
                    style: const TextStyle(color: Colors.white,fontSize: 30, fontWeight: FontWeight.w600),),
                  ],
                  )
                ),
              const SizedBox(height: 20,),
              SizedBox(
                  width: MediaQuery.of(context).size.width - 30,
                  child: const TextField(
                    decoration: InputDecoration(label: Text("Buscar...")),
                  )),
              const SizedBox(height: 20),
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
                                      : Text('Factura electrónica', style: TextStyle(fontSize: 16)),
                                      const SizedBox(height: 4),
                                      Text(
                                          "NIT: ${_fileContent[index]['nit']}"),
                                      Text("\$${NumberFormat('#,##0', 'en_US').format(double.parse(_fileContent[index]['price'])).toString()}"),
                                    ]),
                                trailing: IconButton(
                                    onPressed: () {
                                      showDialog(
                                          context: context,
                                          builder: (_) => DeleteDialog(
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
      ),
    );
  }
}

//Creating the delete confirm dialog
class DeleteDialog extends StatefulWidget {
  final dynamic item;
  final Function func;
  const DeleteDialog({super.key, required this.item, required this.func});

  @override
  State<DeleteDialog> createState() => _DeleteDialogState();
}

class _DeleteDialogState extends State<DeleteDialog> {
  Xmlhandler xmlhandler = Xmlhandler();
  PdfHandler pdfHandler = PdfHandler();

  Future deleteFile(item) async {
    try {
      if(item['customer'] != null) {
        await xmlhandler.deleteXml(item['_id']);
      } else {
        await pdfHandler.deletePdf(item['_id']);
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Eliminar factura"),
      content: const Text("¿Está seguro que desea eliminar la factura?"),
      actions: [
        TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text(
              "No",
              style: TextStyle(color: Colors.redAccent, fontSize: 17),
            )),
        TextButton(
            onPressed: () {
              deleteFile(widget.item);
              widget.func();
              Navigator.pop(context);
            },
            child: const Text("Si",
                style: TextStyle(color: Colors.green, fontSize: 17)))
      ],
    );
  }
}
