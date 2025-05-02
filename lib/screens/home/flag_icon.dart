import 'package:flutter/material.dart';
import 'package:smartbill/models/country.dart';

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
        icon: Image(image: AssetImage(_currentCountry.flag)),
        onSelected: (value) {
          switch (value) {
            case 1:
              changeFlag(colombia);
              break;
            case 2:
              changeFlag(peru);
              break;

            case 3:
              changeFlag(eu);
              break;
            case 4:
              changeFlag(chile);
              break;
            case 5:
              changeFlag(panama);
              break;
            case 6:
              changeFlag(ecuador);
              break;
            case 7:
              changeFlag(usa);
              break;

          }
        },
        initialValue: _currentCountry.id,
        itemBuilder: (BuildContext context) => [
              PopupMenuItem(
                value: 1,
                child: Row(
                  children: <Widget>[
                    Image(image: AssetImage(colombia.flag), width: 40, height: 40,),
                    const SizedBox(width: 20,),
                    Text(colombia.name)
                  ]
                )
              ),
              PopupMenuItem(
                value: 2,
                child: Row(
                  children: <Widget>[
                    Image(image: AssetImage(peru.flag), width: 40, height: 40,),
                    const SizedBox(width: 20,),
                    Text(peru.name)
                  ]
                )
              ),
              PopupMenuItem(
                value: 3,
                child: Row(
                  children: <Widget>[
                    Image(image: AssetImage(eu.flag), width: 40, height: 40,),
                    const SizedBox(width: 20,),
                    Text(eu.name)
                  ]
                )
              ),
              PopupMenuItem(
                value: 4,
                child: Row(
                  children: <Widget>[
                    Image(image: AssetImage(chile.flag), width: 40, height: 40,),
                    const SizedBox(width: 20,),
                    Text(chile.name)
                  ]
                )
              ),
              PopupMenuItem(
                value: 5,
                child: Row(
                  children: <Widget>[
                    Image(image: AssetImage(panama.flag), width: 40, height: 40,),
                    const SizedBox(width: 20,),
                    Text(panama.name)
                  ]
                )
              ),
              PopupMenuItem(
                value: 6,
                child: Row(
                  children: <Widget>[
                    Image(image: AssetImage(ecuador.flag), width: 40, height: 40,),
                    const SizedBox(width: 20,),
                    Text(ecuador.name)
                  ]
                )
              ),
              PopupMenuItem(
                value: 7,
                child: Row(
                  children: <Widget>[
                    Image(image: AssetImage(usa.flag), width: 40, height: 40,),
                    const SizedBox(width: 20,),
                    Text(usa.name)
                  ]
                )
              )
              
            ]);
  }
}