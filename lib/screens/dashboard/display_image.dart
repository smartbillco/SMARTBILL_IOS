import 'dart:io';

import 'package:flutter/material.dart';

class DisplayImageScreen extends StatefulWidget {

  final File? image;
  final String? recognizedText;
  const DisplayImageScreen({super.key, required this.image, required this.recognizedText});

  @override
  State<DisplayImageScreen> createState() => _DisplayImageScreenState();
}


class _DisplayImageScreenState extends State<DisplayImageScreen> {

  String nit = '';
  String code = '';
  String customer = '';
  double total = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _extractData();
  }


  void _extractData() {
    // final RegExp companyRegex = RegExp(r'\b(NIT|NIF)\s*([\w\d.-]+)', caseSensitive: false);
    // final RegExp idRegex = RegExp(r'\b\d{10}\b');
    // final RegExp dateRegex = RegExp(r'\b\d{1,2}[/.-]\d{1,2}[/.-]\d{2,4}\b');

    final lines = widget.recognizedText!.split('\n');
    final regex = RegExp(r'^[A-Za-z]\d{3}-\d{5}$');

    String companyid = '';
    String customerId = '';
    String billCode = '';
    
    for(var line in lines) {

      companyid = line.toLowerCase().startsWith('nit') && !line.toLowerCase().contains('cc') ? line : 'No encontrado';
      customerId = line.toLowerCase().contains('cc') ? line : 'No encontrado';
      billCode = regex.hasMatch(line) ? line : 'No encontrado';

      print(companyid);

    }

    setState(() {
      nit = companyid;
      customer = customerId;
      code = billCode;
    });

    print("Nit $nit");
    print("Cliente: $customer");

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Imagen"),
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              widget.image != null ? Image.file(widget.image!, width: 250,) : Center(child: Text("La imagen no se pudo cargar")),
              const SizedBox(height: 20),
              Text(widget.recognizedText!)
            ],
          ),
        ),
      ),
    );
  }
}