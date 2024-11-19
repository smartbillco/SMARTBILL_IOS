import 'package:flutter/material.dart';

class FlagIcon extends StatefulWidget {
  const FlagIcon({super.key});

  @override
  State<FlagIcon> createState() => _FlagIconState();
}

class _FlagIconState extends State<FlagIcon> {
  
  String _flag = "assets/images/colombian_flag.png";

  void changeFlag(String newFlagAsset) {
    setState(() {
      _flag = newFlagAsset;
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
        style: const ButtonStyle(
            iconColor: WidgetStatePropertyAll(Colors.white),
            iconSize: WidgetStatePropertyAll(30)),
        icon: Image(image: AssetImage(_flag)),
        itemBuilder: (BuildContext context) => [
              PopupMenuItem(
                onTap: () {
                  changeFlag("assets/images/colombian_flag.png");
                },
                child: const Row(
                  children: <Widget>[
                    Image(image: AssetImage("assets/images/colombian_flag.png"), width: 40, height: 40,),
                    SizedBox(width: 20,),
                    Text("Colombia")
                  ]
                )
              ),
              PopupMenuItem(
                onTap: () {
                  changeFlag("assets/images/peruvian_flag.png");
                },
                child: const Row(
                  children: <Widget>[
                    Image(image: AssetImage("assets/images/peruvian_flag.png"), width: 40, height: 40,),
                    SizedBox(width: 20,),
                    Text("Peru")
                  ]
                )
              )
              
            ]);
  }
}
