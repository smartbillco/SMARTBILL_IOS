import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:smartbill/screens/cryptocurrencies/crypto_currency.dart';
import 'package:smartbill/screens/deleteAccount/delete_account.dart';
import 'package:smartbill/screens/settings/settings.dart';
import 'package:smartbill/services/auth.dart';

class DrawerMenu extends StatefulWidget {
  const DrawerMenu({super.key});

  @override
  State<DrawerMenu> createState() => _DrawerMenuState();
}

class _DrawerMenuState extends State<DrawerMenu> {
  final AuthService _auth = AuthService();
  User? user = FirebaseAuth.instance.currentUser;
  String? userName;
  String? phoneNumber;


  String formatPhoneNumber(String number) {
    
    if(number.length == 13) {
      return "${number.substring(0,3)} (${number.substring(3,6)}) ${number.substring(6,13)}";
    } // Remove non-numeric characters
    return number; // Return as is if the format is not correct
  }

  String? formatName(String? name) {
    return name!.split(' ').first;
  }

  void setValues() {
    setState(() {
      userName = user!.displayName.toString();
      phoneNumber = formatPhoneNumber(user!.phoneNumber.toString());
    });
  }

  //Logout
  void redirectDeleteAccount() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => const DeleteAccountScreen()));
  }

  void redirectSettings() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => const SettingsScreen()));
  }

  void redirectCrypto() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => const CryptoListScreen()));
  }

  @override
  void initState() {
    super.initState();
    setValues();
  }

  //Logout
  void logginOut() {
    _auth.logout(context);
  }
  

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color.fromARGB(255, 57, 67, 73), Colors.black87],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter
                )
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 25),
                  user!.displayName == null || user!.displayName == ''
                  ? const Text("Bievenido!", style: TextStyle(color: Colors.white, fontSize: 26))
                  : Text("Hola, ${formatName(user!.displayName).toString()}", style: const TextStyle(color: Colors.white, fontSize: 26)),
                  const SizedBox(height: 20),
                  Text(phoneNumber.toString(), style: const TextStyle(color: Colors.white, fontSize: 18)),
                  
                ],
              ),
            ),
            const SizedBox(height: 20),
            ListTile(
              leading: const Icon(Icons.currency_bitcoin),
              title: const Text("Criptomonedas"),
              onTap: () {
                Navigator.pop(context);
                redirectCrypto();
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text("Configuración"),
              onTap: () {
                Navigator.pop(context);
                redirectSettings();
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text("Cerrar sesión"),
              onTap: () {
                Navigator.pop(context);
                logginOut();
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete_forever),
              title: const Text("Eliminar cuenta"),
              onTap: () {
                Navigator.pop(context);
                redirectDeleteAccount();
              },
            ),
          ],
        ),
      );
  }
}