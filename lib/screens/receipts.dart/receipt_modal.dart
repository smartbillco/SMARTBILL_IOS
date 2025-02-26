import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:smartbill/screens/receipts.dart/receipt_screen.dart';
import 'package:smartbill/screens/receipts.dart/receipt_widgets/delete_dialog.dart';

class BillDetailScreen extends StatefulWidget {
  final Map receipt;
  const BillDetailScreen({super.key, required this.receipt});

  @override
  State<BillDetailScreen> createState() => _BillDetailScreenState();
}

class _BillDetailScreenState extends State<BillDetailScreen> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(widget.receipt);
  }

  void returnToReceipts() {
    Navigator.pop(context);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const ReceiptScreen()),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Detalles de la factura"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: widget.receipt.containsKey('text') ?
        Container(
          child: Column(
            children: [
              Text.rich(_buildTextSpan(widget.receipt['text']),),
              Center(
                    child: ElevatedButton(
                      style: const ButtonStyle(
                        backgroundColor: WidgetStatePropertyAll(Colors.redAccent)
                      ),
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (_) => DeleteDialogWidget(
                              item: widget.receipt,
                              func: returnToReceipts));
                      },
                      child: const Text("Eliminar", style: TextStyle(color: Colors.white),)),
                  )
            ]
             
          ),
        )
        : Container(
          padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 45),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius:BorderRadius.all(Radius.circular(15))
          ),
          child: Column(
            children: [
              const Icon(Icons.check, size: 60, color: Colors.green,),
              const SizedBox(height: 20,),
              Text("Factura: ${widget.receipt['id_bill']}", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),),
              Text("ID Empresa: ${widget.receipt['company_id']}", style: TextStyle(fontSize: 17)),
              const SizedBox(height: 20,),
              const Divider(
                  color: Colors.grey, // Line color
                  thickness: 1, // Line thickness
                  indent: 20, // Left padding
                  endIndent: 20, // Right padding
                ),
              const SizedBox(height: 20,),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ReceiptRows(type: "Cliente", value: widget.receipt['customer'].toUpperCase()),
                  ReceiptRows(type: "Identificación", value: widget.receipt['company'].toUpperCase()),
                  ReceiptRows(type: "Compañia", value: widget.receipt['company_id']),
                  ReceiptRows(type: "Fecha", value: widget.receipt['date']),
                  ReceiptRows(type: "Hora", value: widget.receipt['time']),
                  ReceiptRows(type: "Precio", value: NumberFormat('#,##0', 'en_US').format(double.parse(widget.receipt['price'])).toString()),
                  ReceiptRows(type: "No Factura", value: widget.receipt['cufe']),
                  ReceiptRows(type: "Ciudad", value: widget.receipt['city']),
                  const SizedBox(height: 15,),
                  Center(
                    child: ElevatedButton(
                      style: const ButtonStyle(
                        backgroundColor: WidgetStatePropertyAll(Colors.redAccent)
                      ),
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (_) => DeleteDialogWidget(
                              item: widget.receipt,
                              func: returnToReceipts));
                      },
                      child: const Text("Eliminar", style: TextStyle(color: Colors.white),)),
                  )
                ],
              )
              
          
            ],
          ),
        ),
      )
    );
  }
}


class ReceiptRows extends StatelessWidget {
  final String type;
  final dynamic value;
  const ReceiptRows({super.key, required this.type, required this.value});

  @override
  Widget build(BuildContext context) {

    return Column(
      children: [
        Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("$type     ", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            Flexible(child: Text(value, softWrap: true, )),
          ],
        ),
        SizedBox(height: 7,)
      ]
       
    );
  }
}

TextSpan _buildTextSpan(String input) {
    List<TextSpan> spans = [];
    
    for (int i = 0; i < input.length; i++) {
      String char = input[i];

      spans.add(TextSpan(
        text: char,
        style: char.contains(RegExp(r'[A-Z]'))
            ? const TextStyle(fontWeight: FontWeight.bold, fontSize: 17)
            : const TextStyle(fontWeight: FontWeight.normal, fontSize: 15),
      ));
    }

    return TextSpan(children: spans);
  }