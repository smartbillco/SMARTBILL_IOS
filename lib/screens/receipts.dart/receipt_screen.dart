import 'package:flutter/material.dart';
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
  double total = 0;
  List<dynamic> _fileContent = [];

  //Extract values from pdfText
  dynamic extractValuesFromPdf(String value, List pdfLines) {
    for (var text in pdfLines) {
      if (text.contains(value)) {
        String range = text.substring(0, 16);
        return range;
      }
    }
  }

  //Get all XML files from sqlite
  void getReceipts() async {
    var xmlFiles = await xmlhandler.getXmls();
    
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
            ['cbc:CompanyID'],
        'price': xmlCData
            .findAllElements('cbc:TaxInclusiveAmount')
            .toList()
            .last
            .innerText
      };

      totalPaid += double.parse(newXml['price']);

      myFiles.add(newXml);
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
                    Text("\$${total..toStringAsFixed(2)}",
                    style: const TextStyle(color: Colors.white,fontSize: 22, fontWeight: FontWeight.w400),),
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
                                  child: Text(
                                    _fileContent[index]['customer']
                                            ['cbc:RegistrationName']['text'][0]
                                        .toUpperCase(),
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.w400),
                                  ),
                                ),
                                tileColor: const Color.fromARGB(244, 238, 238, 238),
                                title: Text(
                                    _fileContent[index]['customer']
                                            ['cbc:RegistrationName']['text']
                                        .toUpperCase(),
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16,
                                        height: 1.3)),
                                subtitle: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(height: 4),
                                      Text(
                                          _fileContent[index]['company']
                                              ['cbc:RegistrationName']['text'],
                                          style: const TextStyle(fontSize: 15)),
                                      const SizedBox(height: 4),
                                      Text(
                                          "NIT: ${_fileContent[index]['nit']['text']}"),
                                      Text("\$${_fileContent[index]['price']}"),
                                    ]),
                                trailing: IconButton(
                                    onPressed: () {
                                      showDialog(
                                          context: context,
                                          builder: (_) => DeleteDialog(
                                              id: _fileContent[index]['_id'],
                                              func: getReceipts));
                                    },
                                    icon: const Icon(
                                      Icons.delete,
                                      size: 25,
                                      color: Color.fromARGB(255, 218, 106, 99),
                                    )),
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
  final int id;
  final Function func;
  const DeleteDialog({super.key, required this.id, required this.func});

  @override
  State<DeleteDialog> createState() => _DeleteDialogState();
}

class _DeleteDialogState extends State<DeleteDialog> {
  Xmlhandler xmlhandler = Xmlhandler();

  Future deleteFile(id) async {
    try {
      await xmlhandler.deleteXml(id);
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
              deleteFile(widget.id);
              widget.func();
              Navigator.pop(context);
            },
            child: const Text("Si",
                style: TextStyle(color: Colors.green, fontSize: 17)))
      ],
    );
  }
}
