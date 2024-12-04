import 'package:flutter/material.dart';

class PhoneImage extends StatelessWidget {
  const PhoneImage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Image(image: AssetImage('assets/images/llamada-telefonica.png'), width: 70, height: 110,),
        SizedBox(height: 30,),
        Text("Ingresa tu número: ", style: TextStyle(fontSize: 21),),
        SizedBox(height: 30,),
        Text(
            "Te enviremos un mensaje de texto con tu código de verificación",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 17)),
        SizedBox(height: 20,),
      ],
    );
  }
}