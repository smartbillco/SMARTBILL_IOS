import 'package:flutter/material.dart';

class BalanceContainer extends StatefulWidget {
  final String balance;
  const BalanceContainer({super.key, required this.balance});

  @override
  State<BalanceContainer> createState() => _BalanceContainerState();
}

class _BalanceContainerState extends State<BalanceContainer> {
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(20),
        height: 160,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            gradient: const LinearGradient(
                colors: [Color.fromARGB(255, 68, 95, 109), Colors.black87])),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Tu saldo:", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w200, fontSize: 16)),
            Text(widget.balance.toString(), style: const TextStyle(color: Colors.white,fontSize: 44, fontWeight: FontWeight.w600),)
          ],
      ));
  }
}
