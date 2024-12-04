import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smartbill/screens/dashboard/dashboard.dart';
import 'package:smartbill/services.dart/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';

class OtpScreen extends StatefulWidget {
  
  final String? code;

  const OtpScreen({super.key, required this.code});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {

  final TextEditingController _codeText = TextEditingController();
  final AuthService _auth = AuthService();
  //Simulating http request with loading time
  bool is_loading = false;


  //Fuction for simulating http request with Future.delay

  Future<void> simHttpRequest() async {
    setState(() {
      is_loading = true;
    });

    print(widget.code);

    User? user = await _auth.signInWithCode(widget.code.toString(), _codeText.text.trim());

    if(user != null) {
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const DashboardScreen()), (r) => false);
    } if(user == null) {
      _showSnackbar();

    }

    setState(() {
      is_loading = false;
    });


  }

  void _showSnackbar() {
    const snackBar = SnackBar(
              content: Text("El codigo no es valido"),
              duration: Duration(seconds: 3),
            );

    FocusScope.of(context).unfocus();

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text("Verifica tu numero"),
      ),
      body: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 90),
        //Begin layout
        child: Column(
          children: [
            //Image of receiving text
            const Image(image: AssetImage('assets/images/notificacion_texto.png'), width: 100, height: 120,),
            const SizedBox(height: 30,),
            //Enter OTP
            const Text("Ingresa tu codigo: ", style: TextStyle(fontSize: 22),),
            const SizedBox(height: 30,),
            SizedBox(
              width: 150,
              child: TextField(
                textAlign: TextAlign.center,
                controller: _codeText,
                style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold, letterSpacing: 5),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly
                ],
                decoration: const InputDecoration(
                  label: Text("Ingresar codigo")
                ),
              ),
            ),
            const SizedBox(height: 30,),
            is_loading ? const CircularProgressIndicator() : 
            ElevatedButton(onPressed: simHttpRequest,
            style: const ButtonStyle(backgroundColor: WidgetStatePropertyAll(Colors.blueGrey)),
            child: const Text("Verificar", style: TextStyle(color: Colors.white, fontSize: 20)),
            ),
            
            //Form for four digits
          ],
        ),
      ),
    );
  }
}