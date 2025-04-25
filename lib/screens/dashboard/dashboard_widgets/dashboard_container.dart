import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:smartbill/screens/PDFList/pdf_list.dart';
import 'package:smartbill/screens/QRcode/qrcode_link_screen.dart';
import 'package:smartbill/screens/QRcode/qrcode_screen.dart';
import 'package:smartbill/screens/dashboard/dashboard_widgets/dashboard_carrousel.dart';
//import 'package:smartbill/screens/camera/camera.dart';
import 'package:smartbill/screens/expenses/expenses.dart';
import 'package:smartbill/screens/dashboard/add_bill_choice.dart';
import 'package:smartbill/screens/dashboard/dashboard_widgets/dashboard_text.dart';
import 'package:smartbill/screens/QRcode/qr_scanner.dart';
import 'package:smartbill/screens/receipts.dart/receipt_screen.dart';
import 'package:smartbill/services/pdf.dart';
import 'package:smartbill/services/xml/xml.dart';

class DashboardContainer extends StatefulWidget {
  const DashboardContainer({super.key});

  @override
  State<DashboardContainer> createState() => _DashboardContainerState();
}

class _DashboardContainerState extends State<DashboardContainer> {
  final Xmlhandler xmlhandler = Xmlhandler();
  final PdfHandler pdfHandler = PdfHandler();
  bool isImageReceiptWorking = false;

  //redirect to receiptslist
  void redirectToScreen(Widget screen) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => screen));
  }

  @override
  Widget build(BuildContext context) {

    final String? phone = FirebaseAuth.instance.currentUser!.phoneNumber;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const DashboardText(),
          //Carrousel
          const DashboardCarrousel(),
          SizedBox(height: 20),
          //First row of navigation
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              MenuButton(
                  icon: const Icon(Icons.arrow_downward, color: Colors.white, size: 35),
                  text: "Agregar ingreso",
                  redirect: () {
                    redirectToScreen(const ExpensesScreen());
                  },
                  colors: const [
                    Color.fromARGB(255, 126, 126, 126),
                    Color.fromARGB(255, 31, 31, 31)
                  ]),

              MenuButton(
                icon: const Icon(Icons.receipt, color: Colors.white, size: 35),
                text: "Mis facturas",
                redirect: () {
                  redirectToScreen(const ReceiptScreen());
                },
                colors: const [
                Color.fromARGB(255, 20, 82, 175),
                  Color.fromARGB(255, 4, 34, 80)
                ]
              ),
            ]
          ),
          const SizedBox(height: 14),

          //Second row of navigation
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              MenuButton(
                icon: const Icon(Icons.upload, color: Colors.white, size: 35),
                text: "Cargar factura",
                redirect: () {Navigator.push(context, MaterialPageRoute(builder: (context) => const AddBillChoice()));},
                colors: const [
                  Color.fromARGB(255, 48, 20, 175),
                  Color.fromARGB(255, 15, 4, 80)
                ]),
              MenuButton(
                icon: const Icon(Icons.qr_code, color: Colors.white, size: 35),
                text: "Escanear QR",
                redirect: () {
                  redirectToScreen(const QrcodeLinkScreen(uri: 'https://catalogo-vpfe-hab.dian.gov.co/User/SearchDocument'));
                },
                colors: const [
                  Color.fromARGB(255, 252, 182, 30),
                  Color.fromARGB(255, 172, 116, 13)
                ])
            ],
          ),
          const SizedBox(height: 14),

          //Third row of navigation
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              phone!.startsWith('+57')
              ? MenuButton(
                icon: const Icon(Icons.picture_as_pdf_outlined, color: Colors.white, size: 35),
                text: "PDFs DIAN",
                redirect: () {
                  redirectToScreen(const PDFListScreen());
                },
                colors: const [
                  Color.fromARGB(255, 29, 148, 33),
                  Color.fromARGB(255, 10, 59, 13)
                ])
              : const SizedBox.shrink()
            ],
          ),
          const SizedBox(height: 50,)

        ],
      ),
    );
  }
}

// MenuButton(
//     icon: Icon(Icons.camera_alt, color: Colors.white, size: 35),
//     text: "Fotografíar Factura",
//     redirect: () {
//       redirectToScreen(const CameraShotScreen());
//     },
//     colors: const [
//        Color.fromARGB(255, 20, 82, 175),
//        Color.fromARGB(255, 4, 34, 80)
// ])


class MenuButton extends StatelessWidget {
  final Icon icon;
  final String text;
  final VoidCallback redirect;
  final List<Color> colors;
  
  const MenuButton(
      {super.key,
      required this.icon,
      required this.text,
      required this.redirect,
      required this.colors});

  @override
  Widget build(BuildContext context) {


    return Container(
      width: MediaQuery.of(context).size.width * 0.41,
      height: 160,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: colors,
          )),
      child: TextButton(
          onPressed: redirect,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              icon,
              const SizedBox(height: 6),
              Text(
                textAlign: TextAlign.center,
                text,
                style: const TextStyle(
                    color: Color.fromARGB(230, 255, 255, 255), fontSize: 18),
              ),
            ],
          )),
    );
  }
}
