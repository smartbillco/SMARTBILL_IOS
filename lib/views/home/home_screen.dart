import 'package:flutter/material.dart';
import 'package:smartbill/views/home/flag_icon.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 2,
        backgroundColor: const Color.fromARGB(255, 10, 47, 102),
        leading: IconButton(
            onPressed: () {},
            iconSize: 30,
            icon: const Icon(Icons.person_rounded),
            style: const ButtonStyle(backgroundColor: WidgetStatePropertyAll(Colors.white))
          ),
        actions: const [
          FlagIcon()
        ],
      ),

      body: const Center(
            child: Text("Smartbill")
        )
    );
  }
}