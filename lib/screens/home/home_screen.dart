import 'package:flutter/material.dart';
import 'package:smartbill/screens/home/app_bar_widgets.dart';
import 'package:smartbill/screens/home/crypto_list.dart';
import 'package:smartbill/screens/home/flag_icon.dart';
import 'package:smartbill/services.dart/trm.dart';
import 'package:smartbill/screens/models/country.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  String uri = "https://v6.exchangerate-api.com/v6/b68f1074f3d7d6240f3db214/latest/USD";


  Country _currentCountry = Country(id: 1, flag: "assets/images/colombian_flag.png", name: "Colombia", currency: "COP");

  String data = "\$...";

  Future<void> onCountryChange(Country newCountry) async {

    setState(() {
      _currentCountry = newCountry;
      
    });

    await getData();
  }


  //Get echange currency
  Future<dynamic> getData() async {
    Trm trm = Trm(uri);
    dynamic response = await trm.getExchangeCurrency();

    if(mounted) {
      setState(() {
        data = response['conversion_rates'][_currentCountry.currency].toStringAsFixed(2);
      });

    }
    
  }

  @override
  void initState() {
    
    super.initState();

    getData();

  }


  @override
  Widget build(BuildContext context) {

    
    return Scaffold(
      appBar: AppBar(
        elevation: 2,
        backgroundColor: const Color.fromARGB(255, 29, 29, 29),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(30),
          ),
        ),
        leading: const AppBarIcon(),
        actions: [
          FlagIcon(changeFlag: onCountryChange),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(170),
          child: Container(
            padding: const EdgeInsets.only(bottom: 30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Valor del dolar", style: TextStyle(color: Colors.white)),
                const SizedBox(height: 20),
                Text("${_currentCountry.currency} $data", style: const TextStyle(color: Colors.white, fontSize: 42, fontWeight: FontWeight.bold)),
                const SizedBox(height: 7),
              ],
            ),
          )
        ),
      ),

      body: const CryptoList()
    );
  }
}