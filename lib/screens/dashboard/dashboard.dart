import 'package:flutter/material.dart';
import 'package:smartbill/screens/dashboard/dashboard_widgets/dashboard_container.dart';
import 'package:smartbill/services.dart/auth.dart';
import 'package:smartbill/services.dart/pdf.dart';
import 'package:smartbill/services.dart/xml.dart';
import 'package:intl/intl.dart';



class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final Xmlhandler xmlhandler = Xmlhandler();
  final PdfHandler pdfHandler = PdfHandler();
  int billsAmount = 0;
  final AuthService _auth = AuthService();

  @override
  void initState() {
    super.initState();
    getNumberOfBills();

  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    getNumberOfBills();// Forces a rebuild when dependencies change
  }

  //Get bills amount
  Future<void> getNumberOfBills() async {

    print("UPdating");


    if(mounted) {
      var resultXmls = await xmlhandler.getXmls();
      var resultPdfs = await pdfHandler.getPdfs();
      var total = await resultXmls.length + resultPdfs.length;

      if(mounted) {
        setState(() {
          billsAmount = total;
        });
      }

      
    }
  
  }


  //Logout
  void logginOut() {
    _auth.logout(context);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(170),
          child: Container(
            decoration: const BoxDecoration(
              boxShadow: [
                BoxShadow(
                   color: Colors.black38,
                  blurRadius: 10,
                  offset: Offset(0, 5),
                ),
              ],
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color.fromARGB(255, 53, 53, 53), Colors.black]
              )
            ),
            
            child: AppBar(
              title: const Text("Dashboard", style: TextStyle(color: Colors.white)),
              backgroundColor: Colors.transparent,
              actions: [
                PopupMenuButton(
                  icon: const Icon(Icons.menu_rounded, color: Colors.white,),
                  itemBuilder: (BuildContext context) => [
                    PopupMenuItem(onTap: logginOut, child: const Text("Logout")),
                  ],
                ),
              ],
              bottom: PreferredSize(
                preferredSize: Size.zero,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 10, 0, 30),
                  child: Column(
                    children: [
                      billsAmount > 0 ?
                      Text(billsAmount.toString(), style: const TextStyle(color: Colors.white, fontSize: 36),) :
                      const Text("0", style: TextStyle(color: Colors.white, fontSize: 36),),
                      const Text("Facturas", style: TextStyle(color: Colors.white, fontSize: 16),)
                      
                    ],
                  ),
                )
              ),
            ),
          ),
        ),
        body: RefreshIndicator(
          onRefresh: getNumberOfBills,
          child: const SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            child: DashboardContainer()
          )
        )
      );
  }
}