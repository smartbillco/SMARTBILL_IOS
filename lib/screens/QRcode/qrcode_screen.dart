import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:smartbill/services/colombian_bill.dart';
import 'package:smartbill/services/pdf.dart';
import 'package:smartbill/services/peruvian_bill.dart';


class QrcodeScreen extends StatefulWidget {
  final String qrResult;
  const QrcodeScreen({super.key, required this.qrResult});

  @override
  State<QrcodeScreen> createState() => _QrcodeScreenState();
}

class _QrcodeScreenState extends State<QrcodeScreen> {
  ColombianBill colombianBill = ColombianBill();
  PeruvianBill peruvianBill = PeruvianBill();
  PdfHandler pdfHandler = PdfHandler();
  bool isColombia = false;
  bool isPeru =  false;
  Map<String, Object?> pdfContent = {};


  @override
  void initState() {
    super.initState();
    pdfFormat();
  }


  void pdfFormat() {
    print(widget.qrResult);
    if(widget.qrResult.contains('|')) {
      setState(() {
        isColombia = false;
        isPeru = true;
        pdfContent = pdfHandler.parseQrPeru(widget.qrResult);
      });

    } else if(widget.qrResult.contains('NumFac')) {
      setState(() {
        isPeru = false;
        isColombia = true;
        pdfContent = pdfHandler.parseQrColombia(widget.qrResult);
        
      });
    } else {
      setState(() {
        isPeru = false;
        isColombia = false;
      });
    }

    print("QRContent: $pdfContent");
  }

  @override
  void dispose() {
    super.dispose();
  }

  void showSnackbar(String content) {
    var snackbar = SnackBar(content: Text(content));

    ScaffoldMessenger.of(context).showSnackBar(snackbar);
  }

  //Navigator is changing screens before the file has been created
  Future<void> delayNagivation() async {
    await Future.delayed(const Duration(seconds: 5));
    print("Changing screens");

  }


  Future<void> saveNewColombianBill() async {
    await colombianBill.saveColombianBill(pdfContent);
    Navigator.pop(context);
  }

  Future<void> saveNewPeruvianBill() async {
    await peruvianBill.savePeruvianBill(pdfContent);
    Navigator.pop(context);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Descargar factura"),
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
              isColombia
              ? _cardColombia(pdfContent, context, saveNewColombianBill)
              : _cardPeru(pdfContent, context, saveNewPeruvianBill)
          ],
        ),
      ),
    );
  }
}


Widget _cardColombia(Map pdfContent, context, Future<void> Function() saveFunction) {
  return SingleChildScrollView(
    child: SizedBox(
      child: Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: 
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Factura No. ${pdfContent['bill_number']}",
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const Divider(),
            const SizedBox(height: 10),
            _buildRow("NIT", pdfContent['nit']),
            _buildRow("Id Clientes", pdfContent['customer_id']),
            _buildRow("Sin IVA", NumberFormat('#,##0', 'en_US').format(double.parse(pdfContent['amount_before_iva'])).toString()),
            _buildRow("IVA", NumberFormat('#,##0', 'en_US').format(double.parse(pdfContent['iva'])).toString()),
            _buildRow("Pago", NumberFormat('#,##0', 'en_US').format(double.parse(pdfContent['total_amount'])).toString()),
            _buildRow("Fecha", pdfContent['date']),
            _buildRow("Hora", pdfContent['time']),
            _buildRow("CUFE", pdfContent['cufe']),
            const SizedBox(height: 30),
            SizedBox(
              width: MediaQuery.of(context).size.width - 10,
              child: ElevatedButton(
                  style: const ButtonStyle(
                      backgroundColor:
                          WidgetStatePropertyAll(Colors.greenAccent)),
                  onPressed: () {
                    saveFunction();
                  },
                  child: const Text("Guardar factura")),
            )
          ],
        ),
      ),
    )),
  );
}



Widget _cardPeru(pdfContent, context, Future<void> Function() saveFunction) {
  return SingleChildScrollView(
    child: SizedBox(
      height: 450,
      child: Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 40, horizontal: 15),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Factura No. ${pdfContent['code_start']} - ${pdfContent['code_end']}",style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const Divider(),
            const SizedBox(height:10),
            _buildRow("NIF", pdfContent['ruc_company']),
            _buildRow("Código", pdfContent['receipt_id']),
            _buildRow("IGV", pdfContent['igv']),
            _buildRow("Pago", pdfContent['amount']),
            _buildRow("Fecha", pdfContent['date']),
            _buildRow("RUC Cliente", pdfContent['ruc_customer']),
            const SizedBox(height: 30),
            SizedBox(
              width: MediaQuery.of(context).size.width - 10,
              child: ElevatedButton(
                style: const ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(Colors.greenAccent)
                  ),
                onPressed: () {
                  saveFunction();
                },
                child: const Text("Guardar factura")
                ),
              )
            ],
          ),
        ),
      )
    ),
  );
}


Widget _buildRow(String title, String value) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 4),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
        ),
        SizedBox(
          width: 140,
          child: Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 16),
          ),
        ),
      ],
    ),
  );
}

