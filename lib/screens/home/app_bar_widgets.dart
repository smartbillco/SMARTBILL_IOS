import 'package:flutter/material.dart';
import 'package:smartbill/screens/authentication/authenticate.dart';

class AppBarIcon extends StatefulWidget {
  const AppBarIcon({super.key});

  @override
  State<AppBarIcon> createState() => _AppBarIconState();
}

class _AppBarIconState extends State<AppBarIcon> {
  @override
  Widget build(BuildContext context) {
    return IconButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const AuthenticateScreen()));
            },
            iconSize: 30,
            icon: const Icon(Icons.person),
            style: const ButtonStyle(iconColor: WidgetStatePropertyAll(Colors.white))
        );
  }
}