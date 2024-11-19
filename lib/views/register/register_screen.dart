import 'package:flutter/material.dart';
import 'package:smartbill/views/register/register_form.dart';

class RegisterScreen extends StatelessWidget {

  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(),
      body: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.all(30),
        child: const Column(
          children: [
            Image(image: AssetImage("assets/images/empresa.png")),
            RegisterForm()
          ],
        )
      )
    );
  }
}