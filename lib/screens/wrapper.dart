import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smartbill/screens/dashboard/dashboard.dart';
import 'package:smartbill/screens/home/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Wrapper extends StatefulWidget {
  const Wrapper({super.key});

  @override
  State<Wrapper> createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {

  @override
  Widget build(BuildContext context) {

    User? user = Provider.of(context);

    print("THIS IS THE USER: $user");

    if(user == null){
      return const HomeScreen();
    }

    else {
      return const  DashboardScreen();
    }
  }
}