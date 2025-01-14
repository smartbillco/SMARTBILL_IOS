import 'package:flutter/material.dart';
import 'package:smartbill/screens/dashboard/qr_scanner.dart';
import 'package:smartbill/services.dart/auth.dart';
import 'package:smartbill/services.dart/xml.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:file_picker/file_picker.dart';
import 'package:xml/xml.dart';


class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {

  final Xmlhandler xmlhandler = Xmlhandler();
  Map? customer;
  Map? company;
  List<dynamic> _fileContent = [];
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
        
        await xmlhandler.getXml(fileResult.files.single.path!);

        getXmlFiles();

      } else {
        setState(() {
          _fileContent = [];
        });
      }

    } catch(e) {

      setState(() {
        _fileContent = ["No hay archivo seleccionado"];
      });
      
    }

  }


  void logginOut() {
    _auth.logout(context);
  }

  @override
  void initState() {
    
    super.initState();
    getXmlFiles();
  }

  void getXmlFiles() async {
    var xmlFiles = await xmlhandler.getXmls();
    List myFiles = [];
    for (var item in xmlFiles) {

      XmlDocument xmlDocument = XmlDocument.parse(item['xml_text']);

      Map parsedDoc = xmlhandler.xmlToMap(xmlDocument.rootElement);

      Map newXml = {
        '_id': item['_id'],
        'customer': parsedDoc['cac:ReceiverParty']['cac:PartyTaxScheme'],
        'company': parsedDoc['cac:SenderParty']['cac:PartyTaxScheme']
      };
          
      myFiles.add(newXml);
    }

    setState(() {
      _fileContent = myFiles;
    });
    
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
              child: _fileContent.isNotEmpty
                  ? ListView.builder(
                    itemCount: _fileContent.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: ListTile(
                          tileColor: const Color.fromARGB(240, 240, 240, 240),
                          subtitle: Text(_fileContent[index]['customer']['cbc:CompanyID']['text']),
                          title: Text(_fileContent[index]['customer']['cbc:RegistrationName']['text']),
                          trailing: IconButton(onPressed: () {
                            showDialog(context: context, builder: (_) => DeleteDialog(id:_fileContent[index]['_id'], func: getXmlFiles));
                            
                          }, icon: const Icon(Icons.delete)),
                        ),
                      );
                    },
                  )
                  : const Text("No hay archivo seleccionado"),
            ),
              
          ],
        ),
      )
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
      print("Delete");

    } catch(e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Eliminar factura"),
      content: const Text("Esta seguro que desea eliminar la factura?"),
      actions: [
        TextButton(onPressed: () {Navigator.pop(context);}, child: const Text("No")),
        TextButton(onPressed: () {
          deleteFile(widget.id);
          widget.func();
          Navigator.pop(context);
        }, child: const Text("Si"))
      ],
    );
  }
}