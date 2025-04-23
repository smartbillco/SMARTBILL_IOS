import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:smartbill/services/db.dart';

class DashboardCarrousel extends StatefulWidget {
  const DashboardCarrousel({super.key});

  @override
  State<DashboardCarrousel> createState() => _DashboardCarrouselState();
}

class _DashboardCarrouselState extends State<DashboardCarrousel> {
  final DatabaseConnection databaseConnection = DatabaseConnection();
  String id = FirebaseAuth.instance.currentUser!.uid;
  List items = [
    'Item 1',
    'Item 2',
    'Item 3'
  ];


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchFavoriteCrypto();

  }


  Future<void> fetchFavoriteCrypto() async {
    var db = await databaseConnection.openDb();
    var results = await db.query('favorites', where: 'userId = ?', whereArgs: [id]);

    List<Map<String, dynamic>> favoriteCryptos = [];
    
    try {
      final uri = Uri.parse(
        'https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=10&page=1&sparkline=false');

      var cryptoCurrencies = await http.get(uri);

      if(cryptoCurrencies.statusCode == 200) {


      }

    } catch(e) {
      print(e);
    }

  }




  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: PageView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          return Text(items[index]);
        },
      ),
    );
  }
}