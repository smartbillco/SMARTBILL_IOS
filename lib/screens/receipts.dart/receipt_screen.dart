import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:smartbill/screens/receipts.dart/receipt_modal.dart';
import 'package:smartbill/screens/receipts.dart/receipt_widgets/delete_dialog.dart';
import 'package:smartbill/screens/receipts.dart/receipt_widgets/searchbar.dart';
import 'package:smartbill/screens/receipts.dart/receipt_widgets/total_sum.dart';
import 'package:smartbill/services.dart/pdf.dart';
import 'package:smartbill/services.dart/xml/xml.dart';
import 'package:smartbill/services.dart/xml/xml_colombia.dart';
import 'package:smartbill/services.dart/xml/xml_peru.dart';
import 'package:xml/xml.dart';

class ReceiptScreen extends StatefulWidget {
  const ReceiptScreen({super.key});

  @override
  State<ReceiptScreen> createState() => _ReceiptScreenState();
}

class _ReceiptScreenState extends State<ReceiptScreen> {
  final XmlColombia xmlColombia = XmlColombia();
  final XmlPeru xmlPeru = XmlPeru();
  final Xmlhandler xmlhandler = Xmlhandler();
  final PdfHandler pdfHandler = PdfHandler();
  double totalColombia = 0;
  double totalPeru = 0;
  List<dynamic> _fileContent = [];

  //Extract values from pdfText
  dynamic extractValuesFromPdf(String value, List<String>pdfLines) {

    for (String text in pdfLines) {
      
      if(text.toLowerCase().contains(value.toLowerCase())) {
        return text;
      }
      
    }

    return "NIT de la empresa";
  }

  //Get all XML files from sqlite
  void getReceipts() async {
    var xmlFiles = await xmlhandler.getXmls();
    var pdfFiles = await pdfHandler.getPdfs();
    List myFiles = [];
    double totalPaidColombia = 0;
    double totalPaidPeru = 0;


    for (var item in xmlFiles) {

      XmlDocument xmlDocument = XmlDocument.parse(item['xml_text']);

      Map parsedDoc = xmlhandler.xmlToMap(xmlDocument.rootElement);

      if(xmlDocument.findAllElements('cac:Signature').isNotEmpty) {
        //Peru logic
        final Map newPeruvianXml = xmlPeru.parsePeruvianXml(item['_id'], parsedDoc, xmlDocument);

        totalPaidPeru += double.parse(newPeruvianXml['price']);

        myFiles.add(newPeruvianXml);

      } else {

        //Colombian logic
        final String cDataContent = xmlColombia.extractCData(xmlDocument);

        final XmlDocument xmlCData = xmlColombia.parseCDataToXml(cDataContent);

        final Map newColombianXml = xmlColombia.parseColombianXml(item['_id'], parsedDoc, xmlCData);

        totalPaidColombia += double.parse(newColombianXml['price']);

        myFiles.add(newColombianXml);

        
      }

      
    }

    for(var item in pdfFiles) {

      List<String> pdfTextLines = item['pdf_text'].split('\n');

      final companyId = extractValuesFromPdf('nit', pdfTextLines);

      final Map newPdf = pdfHandler.parsePdf(item['_id'], companyId, item['pdf_text']);

      myFiles.add(newPdf);

    }

    if (mounted) {
      setState(() {
        _fileContent = myFiles;
        totalColombia = totalPaidColombia;
        totalPeru = totalPaidPeru;
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
    return Scaffold(
      appBar: AppBar(
        title: const Text("Mis recibos"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TotalSumWidget(totalColombia: totalColombia, totalPeru: totalPeru),
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
                            child: ListReceipts(fileContent: _fileContent, index: index, getReceipts: getReceipts,)
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


//Tiles for the receipts
class ListReceipts extends StatefulWidget {
  final dynamic fileContent;
  final int index;
  final Function getReceipts;
  const ListReceipts({super.key, required this.fileContent, required this.index, required this.getReceipts});

  @override
  State<ListReceipts> createState() => _ListReceiptsState();
}

class _ListReceiptsState extends State<ListReceipts> {

  void redirectToBillDetail(Map receipt) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => BillDetailScreen(receipt: receipt)));
  }


  @override
  void initState() {
    super.initState();
  } 

  @override
  Widget build(BuildContext context) {

    return ListTile(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15), // Rounded corners
      ),
      onTap: () => redirectToBillDetail(widget.fileContent[widget.index]),
      contentPadding: const EdgeInsets.fromLTRB(10, 5, 5, 3),
      tileColor: const Color.fromARGB(244, 238, 238, 238),
      title: Text(widget.fileContent[widget.index]['customer'], style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(widget.fileContent[widget.index]['company'], style: const TextStyle(fontSize: 18)),
          Text(widget.fileContent[widget.index]['company_id'], style: const TextStyle(fontSize: 16)),
          Text('${widget.fileContent[widget.index]['currency']}: ${NumberFormat('#,##0', 'en_US').format(double.parse(widget.fileContent[widget.index]['price']))}', style: const TextStyle(fontSize: 16)),
        ]
      ),
      trailing:  IconButton(
         onPressed: () {
           showDialog(
             context: context,
             builder: (_) => DeleteDialogWidget(
              item: widget.fileContent[widget.index],
              func: widget.getReceipts));
          },
          icon: const Icon(Icons.delete, size: 25, color: Colors.redAccent)),

    );
  }
}


