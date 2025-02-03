import 'package:flutter/material.dart';

class DashboardText extends StatelessWidget {
  const DashboardText({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
        children: [
          Text("Bienvenido a Smartbill!", style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
          SizedBox(height: 5),
          Text("Tu App de factura electrónica.", style: TextStyle(fontSize: 19,)),
          SizedBox(height: 40),
        ],
    );
  }
}