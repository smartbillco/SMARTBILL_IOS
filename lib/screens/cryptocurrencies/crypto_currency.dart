import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:smartbill/services/db.dart';

import '../../models/cryptos.dart';

class CryptoListScreen extends StatefulWidget {
  const CryptoListScreen({super.key});

  @override
  State<CryptoListScreen> createState() => _CryptoListScreenState();
}

class _CryptoListScreenState extends State<CryptoListScreen> {
  String userId = FirebaseAuth.instance.currentUser!.uid;
  List<Crypto> cryptos = [];
  Set<String> favoriteIds = {};
  DatabaseConnection databaseConnection = DatabaseConnection();


  Future<void> fetchCryptos() async {
    final url = Uri.parse(
        'https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=10&page=1&sparkline=false');

    final response = await http.get(url);
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      setState(() {
        cryptos = data.map((json) => Crypto.fromJson(json)).toList();
      });
    }
  }

  Future<void> fetchAllFavorites() async {
    try {
      var dbConnection = await databaseConnection.openDb();
      var result = await dbConnection.query('favorites', where: 'userId = ?', whereArgs: [userId]);
      print("Set: $result");
      Set<String> cryptos = {};
      for(var item in result) {
        cryptos.add(item['cryptoId']);
      }

      setState(() {
        favoriteIds = cryptos;
      });

    } catch(e) {
      print("Hubo un problema: $e");
    }

  }

  Future<void> _addNewFavorite(String cryptoId) async {
    var dbConnection = await databaseConnection.openDb();
    var resultId = await dbConnection.insert('favorites', {'userId': userId, 'cryptoId': cryptoId});
    print("Guardado: $resultId");
  }

  Future<void> _removeFavorite(String cryptoId) async {
    var dbConnection = await databaseConnection.openDb();
    var resultId = await dbConnection.delete('favorites', where: 'cryptoId = ?', whereArgs: [cryptoId]);
    print("Removed: $resultId");
  }


  @override
  void initState() {
    super.initState();
    fetchCryptos();
    fetchAllFavorites();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Criptomonedas')),
      body: cryptos.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                const SizedBox(height: 20),
                const Text("Top 10 de Criptomonedas", style: TextStyle(fontSize: 22, letterSpacing: 1, fontWeight: FontWeight.w500)),
                const SizedBox(height: 50),
                Expanded(
                  child: ListView.builder(
                      itemCount: cryptos.length,
                      itemBuilder: (context, index) {
                        final crypto = cryptos[index];
                        final isFavorite = favoriteIds.contains(crypto.id);
                  
                        return ListTile(
                          leading: Image.network(crypto.image, width: 32, height: 32),
                          title: Text('${crypto.name} (${crypto.symbol.toUpperCase()})'),
                          subtitle: Text('\$${crypto.price.toStringAsFixed(2)}'),
                          trailing: isFavorite
                              ? const Icon(Icons.star, color: Colors.amber)
                              : const Icon(Icons.star_border),
                          onTap: () async {
                            if (favoriteIds.contains(crypto.id)) {
                              await _removeFavorite(crypto.id);
                              setState(() {
                                favoriteIds.remove(crypto.id);
                              });
                              
                            } else {  
                              favoriteIds.add(crypto.id);
                              await _addNewFavorite(crypto.id);
                              setState(() {
                                favoriteIds.add(crypto.id);
                              });
                            }
                          },
                        );
                      },
                          ),
                ),
              ],
            ),
          );
  }
}