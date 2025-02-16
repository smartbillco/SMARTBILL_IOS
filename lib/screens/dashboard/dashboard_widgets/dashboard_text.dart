import 'package:flutter/material.dart';

class DashboardText extends StatelessWidget {
  const DashboardText({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Bienvenido a Smartbill!", style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
          SizedBox(height: 8),
          Text("Tu App de factura electrónica.", style: TextStyle(fontSize: 17,)),
          SizedBox(height: 30),
        ],
    );
  }
}