import 'package:flutter/material.dart';

class DashboardText extends StatelessWidget {
  const DashboardText({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 15),
          Text("Bienvenido a Smartbill", style: TextStyle(fontSize: 20,)),
          SizedBox(height: 24),
        ],
    );
  }
}