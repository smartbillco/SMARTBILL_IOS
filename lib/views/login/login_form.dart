import 'package:flutter/material.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _keyForm = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _keyForm,
      child: SingleChildScrollView(
        child: Column(
          children: [
            TextFormField(
              decoration: const InputDecoration(labelText: 'Correo'),
            ),
            const SizedBox(height: 20),
            TextFormField(
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Contraseña'),
            ),
            const SizedBox(height: 5),
            
            SizedBox(
                width: MediaQuery.of(context).size.width,
                child: TextLink(
                    text: "Restablecer contraseña",
                    link: const Placeholder(),
                    alignment: Alignment.centerRight)),

            const SizedBox(height: 30),

            SizedBox(
              width: MediaQuery.of(context).size.width - 20,
              child: ElevatedButton(
                  onPressed: () {},
                  style: const ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(Colors.green),
                  ),
                  child: const Padding(
                      padding: EdgeInsets.all(15),
                      child: Text("INICIAR SESION",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w400,
                              letterSpacing: 2)))),
            ),
          ],
        ),
      ),
    );
  }
}

//Reusable widget for both links
// ignore: must_be_immutable
class TextLink extends StatelessWidget {
  String text;
  Widget link;
  AlignmentGeometry alignment;

  TextLink(
      {super.key,
      required this.text,
      required this.link,
      required this.alignment});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => link,
          ),
        );
      },
      style: const ButtonStyle(),
      child: Align(
          alignment: alignment,
          child: Text(text,
              style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w300,
                  decoration: TextDecoration.underline))),
    );
  }
}
