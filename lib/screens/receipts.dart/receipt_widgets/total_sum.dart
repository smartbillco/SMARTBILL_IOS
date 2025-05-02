import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TotalSumWidget extends StatefulWidget {
  final double totalColombia;
  final double totalPeru;
  final double totalPanama;
  const TotalSumWidget({super.key, required this.totalColombia, required this.totalPeru, required this.totalPanama});

  @override
  State<TotalSumWidget> createState() => _TotalSumWidgetState();
}

class _TotalSumWidgetState extends State<TotalSumWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
              padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 15),
              height: 200,
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
                  const SizedBox(height: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("\$${NumberFormat('#,##0', 'en_US').format(widget.totalColombia).toString()}", style: const TextStyle(color: Colors.white,fontSize: 30, fontWeight: FontWeight.w600),),
                      const SizedBox(height:2),
                      Text("S/.${NumberFormat('#,##0', 'en_US').format(widget.totalPeru).toString()}", style: const TextStyle(color: Colors.white,fontSize: 30, fontWeight: FontWeight.w600),),
                      const SizedBox(height:2),
                      Text("USD ${NumberFormat('#,##0.00', 'en_US').format(widget.totalPanama).toString()}", style: const TextStyle(color: Colors.white,fontSize: 30, fontWeight: FontWeight.w600),),
                    ] 
                  ),
                ],
                )
              );
  }
}