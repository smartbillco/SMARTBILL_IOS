import 'package:flutter/material.dart';
import 'package:smartbill/views/login/login_form.dart';
import 'package:smartbill/views/register/register_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          children: [
            const SizedBox(height: 40),
            const Image(image: AssetImage('assets/images/empresa.png')),
            const SizedBox(height: 20),
            const LoginForm(),
            const SizedBox(height:5),
            TextLink(text: "Crear una nueva cuenta", link: RegisterScreen(), alignment: Alignment.center,)
          ],
        ),
      ),
    );
  }
}