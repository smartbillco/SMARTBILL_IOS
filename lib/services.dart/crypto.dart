import 'dart:convert';

import 'package:http/http.dart' as http;

class Crypto {

  final uri = 'https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=5&page=1&sparkline=false';


  Future<dynamic> getCoins() async {

    final url = Uri.parse(uri);

    try {
      final response = await http.get(url);

      if(response.statusCode == 200) {
        final topCryptos = jsonDecode(response.body);
        return topCryptos;
        
      } else {
        return jsonDecode("Couldn't load");
      }

    } catch(e) {
      return e;
    }
    
  }

}