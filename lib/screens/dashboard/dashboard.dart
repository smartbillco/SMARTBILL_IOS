import 'package:flutter/material.dart';
import 'package:smartbill/screens/dashboard/qr_scanner.dart';
import 'package:smartbill/services.dart/auth.dart';
import 'package:smartbill/services.dart/xml.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:file_picker/file_picker.dart';


class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {

  final Xmlhandler xmlhandler = Xmlhandler();
  Map? customer;
  Map? company;
  Map _fileContent = {};
  String? extractedData;
  String? name;
  final AuthService _auth = AuthService();
 
  String? _result;

  bool isQR = false;


  //Get result from QR scanning
  void setResult(String result) {

    setState(() {
      _result = result;
      isQR = true;
    });

  }

  //Get and display XML
  Future<void> _pickAndDisplayXml() async {
    try {

      FilePickerResult? fileResult = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['xml']
      );

      if(fileResult != null) {
        
        Map parsedContent = await xmlhandler.getXml(fileResult.files.single.path!);

          setState(() {
            _fileContent = parsedContent;
            customer = _fileContent['cac:ReceiverParty']['cac:PartyTaxScheme'];
            company = _fileContent['cac:SenderParty']['cac:PartyTaxScheme'];

          });

          print(_fileContent);

      } else {
        setState(() {
          _fileContent = {};
        });
      }

    } catch(e) {

      setState(() {
        _fileContent = {"response":"$e"};
      });
      
    }

  }


  void logginOut() {
    _auth.logout(context);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Dashboard"),
        actions: [
          PopupMenuButton(
            itemBuilder: (BuildContext context) => [
              PopupMenuItem(
                onTap: logginOut,
                child: const Text("Logout")
              ),
            ],
          ),
        ],
      ),
      body: Container(
        margin: const EdgeInsets.all(30),
        child: Column(
          children: [
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    style: const ButtonStyle(
                      backgroundColor: WidgetStatePropertyAll(Color.fromARGB(255, 51, 51, 51))),
                    onPressed: _pickAndDisplayXml,
                    child: const Text("Cargar XML", style: TextStyle(color: Colors.white, fontSize: 17),)
                  ),
                  ElevatedButton(
                    style: const ButtonStyle(
                      backgroundColor: WidgetStatePropertyAll(Color.fromARGB(255, 51, 51, 51))),
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => QRScanner(setResult:  setResult,)));
                    },
                    child: const Text("Leer QR", style: TextStyle(color: Colors.white, fontSize: 17),)
                  ),
                ],
              ),
              const SizedBox(height: 30),
              InkWell(
                onTap: () {
                  launchUrl(Uri.parse(_result!));
                },
                child: Text(_result ?? "", style: const TextStyle(fontSize: 18, decoration: TextDecoration.underline, color: Colors.blue),),
              ),

              Expanded(
              child: SingleChildScrollView(
                child: _fileContent.isNotEmpty
                    ? SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: Card(
                        shadowColor: Colors.grey,
                        elevation: 2,
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Text("Cliente: ", style: TextStyle(fontWeight: FontWeight.w500, color: Colors.blueAccent)),
                                  Text("${customer?['cbc:RegistrationName']['text']}")
                                ],
                              ),
                              Text("Cedula: ${customer?['cbc:CompanyID']['text']}"),
                              Text("Empresa: ${company?['cbc:RegistrationName']['text']}", style: const TextStyle(fontWeight: FontWeight.w500, color: Colors.blueAccent)),
                            ],
                          ),
                        ),
                      ),
                    )
                    : const Text("No hay archivo seleccionado"),
              ),
            ),
              
          ],
        ),
      )
    );
  }
}