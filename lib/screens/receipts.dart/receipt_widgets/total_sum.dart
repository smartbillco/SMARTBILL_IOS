import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TotalSumWidget extends StatefulWidget {
  final double total;
  const TotalSumWidget({super.key, required this.total});

  @override
  State<TotalSumWidget> createState() => _TotalSumWidgetState();
}

class _TotalSumWidgetState extends State<TotalSumWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
              padding: const EdgeInsets.all(20),
              height: 120,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                gradient: const LinearGradient(colors: [Color.fromARGB(255, 68, 95, 109), Colors.black87])
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Tu total hasta hoy", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w200)),
                  const SizedBox(height: 5),
                  Text("\$${NumberFormat('#,##0', 'en_US').format(widget.total).toString()}",
                  style: const TextStyle(color: Colors.white,fontSize: 30, fontWeight: FontWeight.w600),),
                ],
                )
              );
  }
}