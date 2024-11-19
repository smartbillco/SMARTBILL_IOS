import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class RegisterForm extends StatefulWidget {
  const RegisterForm({super.key});

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {

  final _keyForm = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _keyForm,
      child: Column(
        children: [
          TextFormField(
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25)
              ),
              labelText: "Correo",
            ),
          ),

          const SizedBox(height: 20),

          TextFormField(
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly
            ],
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25)
              ),
              labelText: "Documento"
            ),
          ),

          const SizedBox(height: 20),

          TextFormField(
            obscureText: true,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25)
              ),
              labelText: "Contraseña"
            ),
          ),

          const SizedBox(height: 40),

          ElevatedButton(
            onPressed: () {},
            style: const ButtonStyle(
              backgroundColor: WidgetStatePropertyAll(Colors.green)
            ),
            child: const Text("REGISTRARSE", style: TextStyle(color: Colors.white),)
          )
        ],
      ),
    );
  }
}