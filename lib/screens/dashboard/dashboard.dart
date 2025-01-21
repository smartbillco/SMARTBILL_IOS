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

  @override
  void initState() {
    super.initState();
    getXmlFiles();
  }


  //Get result from QR scanning
  void setResult(String result) {
    setState(() {
      _result = result;
      isQR = true;
    });
  }

  //Open files and save and display a new XML
  Future<void> _pickAndDisplayXml() async {
    
      FilePickerResult? fileResult = await FilePicker.platform
          .pickFiles(type: FileType.custom, allowedExtensions: ['xml']);

      if (fileResult != null) {
        await xmlhandler.getXml(fileResult.files.single.path!);

        getXmlFiles();

      } else {
        _showSnackbarCancelXml();
        getXmlFiles();
      }
  }
 

  
  //Get all XML files from sqlite
  void getXmlFiles() async {

    var xmlFiles = await xmlhandler.getXmls();

    List myFiles = [];

    
      for (var item in xmlFiles) {

        XmlDocument xmlDocument = XmlDocument.parse(item['xml_text']);

        Map parsedDoc = xmlhandler.xmlToMap(xmlDocument.rootElement);

        Map newXml = {
          '_id': item['_id'],
          'customer': parsedDoc['cac:ReceiverParty']['cac:PartyTaxScheme'],
          'company': parsedDoc['cac:SenderParty']['cac:PartyTaxScheme'],
          'date': parsedDoc['cbc:IssueDate'],
        };

        myFiles.add(newXml);
      }
      

      if (mounted) {

        setState(() {
          _fileContent = myFiles;
        });
      } 

  }

  //Logout
  void logginOut() {
    _auth.logout(context);
  }

  //Snackbar for error when loading an XML
  void _showSnackbarError() {
    var snackbar = const SnackBar(content: Text("Hubo un error cargando el archivo, intentalo de nuevo o elige otro archivo."));
    ScaffoldMessenger.of(context).showSnackBar(snackbar);
  }

  //Cancelled picking a xml file
  void _showSnackbarCancelXml() {
    var snackbar = const SnackBar(content: Text("Cancelaste elegir un xml"), duration: Duration(seconds: 2),);
    ScaffoldMessenger.of(context).showSnackBar(snackbar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Dashboard"),
          actions: [
            PopupMenuButton(
              itemBuilder: (BuildContext context) => [
                PopupMenuItem(onTap: logginOut, child: const Text("Logout")),
              ],
            ),
          ],
        ),
        body: Container(
          margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                      style: const ButtonStyle(
                          backgroundColor: WidgetStatePropertyAll(
                              Color.fromARGB(255, 51, 51, 51))),
                      onPressed: _pickAndDisplayXml,
                      child: const Text(
                        "Cargar XML",
                        style: TextStyle(color: Colors.white, fontSize: 17),
                      )),
                  ElevatedButton(
                      style: const ButtonStyle(
                          backgroundColor: WidgetStatePropertyAll(
                              Color.fromARGB(255, 51, 51, 51))),
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => QRScanner(
                                  setResult: setResult,
                                )));
                      },
                      child: const Text(
                        "Leer QR",
                        style: TextStyle(color: Colors.white, fontSize: 17),
                      )),
                ],
              ),
              const SizedBox(height: 10),
              InkWell(
                onTap: () {
                  launchUrl(Uri.parse(_result!));
                  setState(() {
                    _result = "";
                  });
                },
                child: Text(
                  _result ?? "",
                  style: const TextStyle(
                      fontSize: 18,
                      decoration: TextDecoration.underline,
                      color: Colors.blue),
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: _fileContent.isNotEmpty
                    ? ListView.builder(
                        itemCount: _fileContent.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 0),
                            child: Material(
                              borderRadius: const BorderRadius.all(Radius.circular(10)),
                              elevation: 12,
                              shadowColor: Colors.grey,
                              child: ListTile(
                                contentPadding:const EdgeInsets.fromLTRB(12, 5, 2, 5),
                                leading: CircleAvatar(
                                  backgroundColor: const Color.fromARGB(255, 51, 51, 51),
                                  child: Text(_fileContent[index]['customer']['cbc:RegistrationName']['text'][0],
                                    style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w400),
                                  ),
                                  
                                  ),
                                tileColor:const Color.fromARGB(244, 226, 226, 226),
                                title: 
                                  Text(_fileContent[index]['customer']['cbc:RegistrationName']['text'],
                                    style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 17, height: 1.3),
                                  ),
                                subtitle: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(height: 4),
                                      Text(_fileContent[index]['company']
                                          ['cbc:RegistrationName']['text'],
                                          style: const TextStyle(fontSize: 15)),
                                      const SizedBox(height: 4),
                                      Text(_fileContent[index]['date']['text'])
                                    ]),
                                trailing: IconButton(
                                    onPressed: () {
                                      showDialog(
                                          context: context,
                                          builder: (_) => DeleteDialog(
                                              id: _fileContent[index]['_id'],
                                              func: getXmlFiles));
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
            ],
          ),
        ));
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
            child: const Text("No", style: TextStyle(color: Colors.redAccent, fontSize: 17),)),
        TextButton(
            onPressed: () {
              deleteFile(widget.id);
              widget.func();
              Navigator.pop(context);
            },
            child: const Text("Si", style: TextStyle(color: Colors.green, fontSize: 17)))
      ],
    );
  }
}
