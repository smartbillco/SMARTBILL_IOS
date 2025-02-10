import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:smartbill/screens/dashboard/dashboard_widgets/dashboard_text.dart';
import 'package:smartbill/screens/QRcode/qr_scanner.dart';
import 'package:smartbill/screens/receipts.dart/receipt_screen.dart';
import 'package:smartbill/services.dart/pdf.dart';
import 'package:smartbill/services.dart/xml.dart';

class DashboardContainer extends StatefulWidget {
  const DashboardContainer({super.key});

  @override
  State<DashboardContainer> createState() => _DashboardContainerState();
}

class _DashboardContainerState extends State<DashboardContainer> {
  final Xmlhandler xmlhandler = Xmlhandler();
  final PdfHandler pdfHandler = PdfHandler();

  //Open files and save and display a new XML
  Future<void> _pickAndDisplayFile() async {
    
      FilePickerResult? fileResult = await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ['xml', 'pdf']);

      if (fileResult != null) {

        String filePath = fileResult.files.single.path!;
        String fileName = fileResult.files.single.name.toLowerCase();

        if(fileName.endsWith('.pdf')) {
          
          await pdfHandler.getPDFtext(filePath);

          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const ReceiptScreen()));

          

        } else if(fileName.endsWith('.xml')) {
          await xmlhandler.getXml(filePath);

          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const ReceiptScreen()));
        }


      } else {
        print("Se cancelo");
        _showSnackbarCancelXml();
      }
  }


  //redirect to receiptslist
  void redirectReceiptList() {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => const ReceiptScreen()));
  }



  //Redirect to QRcode
  void redirectQRcode() {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => const QRScanner()));
  }


  //Snackbar for receipt cancel
  //Cancelled picking a xml file
  void _showSnackbarCancelXml() {
    var snackbar = const SnackBar(content: Text("No elegiste una factura"), duration: Duration(seconds: 2),);
    ScaffoldMessenger.of(context).showSnackBar(snackbar);
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 35),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DashboardText(),

          //First row of navigation
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
             MenuButton(text: "Cargar factura", redirect: _pickAndDisplayFile, colors: const [Color.fromARGB(255, 126, 126, 126), Color.fromARGB(255, 31, 31, 31)]),
             MenuButton(text: "Escanear QR", redirect: redirectQRcode, colors: const [Color.fromARGB(255, 20, 82, 175), Color.fromARGB(255, 4, 34, 80)])
            ],
          ),
          const SizedBox(height: 15),

          //Second row of navigation
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
             MenuButton(text: "Mis facturas", redirect: redirectReceiptList, colors: const [Color.fromARGB(255, 238, 218, 42), Color.fromARGB(255, 175, 137, 11)]),
             MenuButton(text: "Consultas", redirect: () {}, colors: const [Color.fromARGB(255, 47, 180, 51), Color.fromARGB(255, 16, 78, 20)] )
            ],
          )
        ],
      ),
    );
  }
}

class MenuButton extends StatelessWidget {
  final String text;
  final VoidCallback redirect;
  final List<Color> colors;
  const MenuButton({super.key, required this.text, required this.redirect, required this.colors});

  @override
  Widget build(BuildContext context) {
    return Container(
                width: 160,
                height: 160,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: colors,
                  )
                ),
                child: TextButton(
                  onPressed: redirect,
                  child: Text(text, style: const TextStyle(color: Color.fromARGB(230, 255, 255, 255), fontSize: 16),)
                ),
              );
  }
}