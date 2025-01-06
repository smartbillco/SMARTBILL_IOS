import 'package:flutter/material.dart';
import 'package:smartbill/services.dart/crypto.dart';


class CryptoList extends StatefulWidget {
  const CryptoList({super.key});

  @override
  State<CryptoList> createState() => _CryptoListState();
}

class _CryptoListState extends State<CryptoList> {

  Crypto crypto = Crypto();
  bool isLoading = true;

  dynamic topCryptos;


  Future getTopCryptos() async {

    final result = await crypto.getCoins();

    if(mounted) {

      setState(() {
        topCryptos = result;
        isLoading = false;
    });


    }

    print(topCryptos);
  }



  @override
  void initState() {

    super.initState();

    getTopCryptos();


  }


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.symmetric(vertical: 20),
      child: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: topCryptos.length,
              itemBuilder: (context, index) {
                final crypto = topCryptos[index];
                return Card(
                  color: const Color.fromARGB(206, 255, 255, 255),
                  margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ListTile(
                    leading: Image.network(
                      crypto['image'],
                      width: 40,
                      height: 40,
                    ),
                    title: Text(
                      crypto['name'],
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    subtitle: Text(
                      "Precio: \$${crypto['current_price']}\nMarket Cap Rank: ${crypto['market_cap_rank']}",
                    ),
                    trailing: Text(
                      "\$${crypto['current_price']}",
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.green),
                    ),
                  ),
                );
              },
            ),
    );
  }
}