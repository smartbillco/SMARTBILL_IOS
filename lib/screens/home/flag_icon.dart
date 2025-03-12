import 'package:flutter/material.dart';
import 'package:smartbill/screens/models/country.dart';

class FlagIcon extends StatefulWidget {
  final Function(Country) changeFlag;
  const FlagIcon({super.key, required this.changeFlag});


  @override
  State<FlagIcon> createState() => _FlagIconState();
}

class _FlagIconState extends State<FlagIcon> {


  Country colombia = Country(id: 1, flag: "assets/images/colombian_flag.png", name: "Colombia", currency: "COP");
  Country peru = Country(id: 2, flag: "assets/images/peruvian_flag.png", name: "Peru", currency: "PEN");
  Country eu = Country(id: 3, flag: "assets/images/european_union_flag.png", name: "UE", currency: "EUR");
  Country chile = Country(id: 4, flag: "assets/images/chile.png", name: "Chile", currency: "CLP");
  Country panama = Country(id: 5, flag: "assets/images/panama.png", name: "Panama", currency: "USD");
  Country ecuador = Country(id: 6, flag: "assets/images/ecuador.png", name: "Ecuador", currency: "USD");
  Country usa = Country(id: 4, flag: "assets/images/estados-unidos-de-america.png", name: "Estados Unidos", currency: "USD");

  
  Country _currentCountry = Country(id: 1, flag: "assets/images/colombian_flag.png", name: "Colombia",  currency: "COP");

  @override
  void initState() {
    super.initState();

    _currentCountry = colombia;
  }

  void changeFlag(Country newCountry) { 
    setState(() {
      _currentCountry = newCountry;
    });
    widget.changeFlag(_currentCountry);
  }

  @override
  Widget build(BuildContext context) {


    return PopupMenuButton(
        style: const ButtonStyle(
            iconColor: WidgetStatePropertyAll(Colors.white),
            iconSize: WidgetStatePropertyAll(30)),
        icon: Image(image: AssetImage(_currentCountry.flag)),
        itemBuilder: (BuildContext context) => [
              PopupMenuItem(
                onTap: () {
                  changeFlag(colombia);
                },
                child: Row(
                  children: <Widget>[
                    Image(image: AssetImage(colombia.flag), width: 40, height: 40,),
                    const SizedBox(width: 20,),
                    Text(colombia.name)
                  ]
                )
              ),
              PopupMenuItem(
                onTap: () {
                  changeFlag(peru);
                },
                child: Row(
                  children: <Widget>[
                    Image(image: AssetImage(peru.flag), width: 40, height: 40,),
                    const SizedBox(width: 20,),
                    Text(peru.name)
                  ]
                )
              ),
              PopupMenuItem(
                onTap: () {
                  changeFlag(eu);
                },
                child: Row(
                  children: <Widget>[
                    Image(image: AssetImage(eu.flag), width: 40, height: 40,),
                    const SizedBox(width: 20,),
                    Text(eu.name)
                  ]
                )
              ),
              PopupMenuItem(
                onTap: () {
                  changeFlag(chile);
                },
                child: Row(
                  children: <Widget>[
                    Image(image: AssetImage(chile.flag), width: 40, height: 40,),
                    const SizedBox(width: 20,),
                    Text(chile.name)
                  ]
                )
              ),
              PopupMenuItem(
                onTap: () {
                  changeFlag(panama);
                },
                child: Row(
                  children: <Widget>[
                    Image(image: AssetImage(panama.flag), width: 40, height: 40,),
                    const SizedBox(width: 20,),
                    Text(panama.name)
                  ]
                )
              ),
              PopupMenuItem(
                onTap: () {
                  changeFlag(ecuador);
                },
                child: Row(
                  children: <Widget>[
                    Image(image: AssetImage(ecuador.flag), width: 40, height: 40,),
                    const SizedBox(width: 20,),
                    Text(ecuador.name)
                  ]
                )
              )
              
            ]);
  }
}
