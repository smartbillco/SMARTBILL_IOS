import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:smartbill/screens/home/home_screen.dart';
import 'package:smartbill/services/auth.dart';

class DeleteAccountScreen extends StatefulWidget {
  const DeleteAccountScreen({super.key});

  @override
  State<DeleteAccountScreen> createState() => _DeleteAccountScreenState();
}

class _DeleteAccountScreenState extends State<DeleteAccountScreen> {
  AuthService _auth = AuthService();
  User? user = FirebaseAuth.instance.currentUser;

  Future<void> deleteCurrentAccount() async {
    try {
      await _auth.deleteAccount();
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
        (route) => false, // Removes all previous routes
      );
    } catch(e) {
      print(e);
    }
  }


  @override
  Widget build(BuildContext context) {

    print(user);

    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text("¿Esta seguro que desea eliminar la cuenta ${user!.phoneNumber}?", style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w600)),
            const SizedBox(height: 15),
            const Text("Por favor, recuerde que todas sus facturas serán eliminadas.", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w300)),
            const SizedBox(height: 25),
            Row(
              children: [
                ElevatedButton(
                  style: const ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(Colors.green)
                  ),
                  onPressed: deleteCurrentAccount,
                  child: const Text("Sí", style: TextStyle(color: Colors.white, fontSize: 18))
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  style: const ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(Colors.redAccent)
                  ),
                  onPressed: () {},
                  child: const Text("No", style: TextStyle(color: Colors.white, fontSize: 18))
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}