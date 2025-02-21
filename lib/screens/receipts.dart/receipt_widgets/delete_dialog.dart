import 'package:flutter/material.dart';
import 'package:smartbill/services.dart/pdf.dart';
import 'package:smartbill/services.dart/xml.dart';


//Creating the delete confirm dialog
class DeleteDialogWidget extends StatefulWidget {
  final dynamic item;
  final Function func;
  const DeleteDialogWidget({super.key, required this.item, required this.func});

  @override
  State<DeleteDialogWidget> createState() => _DeleteDialogWidgetState();
}

class _DeleteDialogWidgetState extends State<DeleteDialogWidget> {
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
            onPressed: () async {
              await deleteFile(widget.item);
              Navigator.pop(context);
              widget.func();
              
            },
            child: const Text("Si",
                style: TextStyle(color: Colors.green, fontSize: 17)))
      ],
    );
  }
}