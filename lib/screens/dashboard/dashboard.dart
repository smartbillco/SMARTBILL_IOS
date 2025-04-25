import 'package:flutter/material.dart';
import 'package:smartbill/drawer/drawer.dart';
import 'package:smartbill/screens/dashboard/dashboard_widgets/dashboard_container.dart';
import 'package:smartbill/screens/deleteAccount/delete_account.dart';
import 'package:smartbill/screens/settings/settings.dart';
import 'package:smartbill/services/auth.dart';
import 'package:smartbill/services/colombian_bill.dart';
import 'package:smartbill/services/pdf_reader.dart';
import 'package:smartbill/services/peruvian_bill.dart';
import 'package:smartbill/services/xml/xml.dart';
import 'package:smartbill/route_observer.dart';


class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> with RouteAware {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final Xmlhandler xmlhandler = Xmlhandler();
  final ColombianBill colombianBill = ColombianBill();
  final PeruvianBill peruvianBill = PeruvianBill();
  final PdfService pdfService = PdfService();
  final AuthService _auth = AuthService();

  int billsAmount = 0;
  

  @override
  void initState() {
    super.initState();
    getNumberOfBills();
  }


  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPopNext() {
    // your refresh logic
    getNumberOfBills();
  }

  //Get bills amount
  Future<void> getNumberOfBills() async {

    if(mounted) {
      var resultXmls = await xmlhandler.getXmls();
      var resultPdfs = await pdfService.fetchAllPdfs();
      var allColombianBills = await colombianBill.getColombianBills();
      var allPeruvianBills = await peruvianBill.getPeruvianBills();
      var total = await resultXmls.length + resultPdfs.length + allColombianBills.length + allPeruvianBills.length;

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

  //Logout
  void redirectDeleteAccount() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => const DeleteAccountScreen()));
  }

  void redirectSettings() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => const SettingsScreen()));
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      key: _scaffoldKey,
      drawer: const DrawerMenu(),
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
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AppBar(
                title: const Text("Dashboard", style: TextStyle(color: Colors.white)),
                centerTitle: true,
                backgroundColor: Colors.transparent,           
                leading: IconButton(
                    icon: const Icon(Icons.more_horiz, color: Colors.white,),
                    onPressed: () {
                      _scaffoldKey.currentState?.openDrawer(); // Open the drawer
                    },
                ),
                
              ),
              Text(
                billsAmount > 0 ? billsAmount.toString() : "0",
                style: const TextStyle(color: Colors.white, fontSize: 36),
              ),
              const Text("Facturas", style: TextStyle(color: Colors.white, fontSize: 16)),
              const SizedBox(height: 20),
            ],
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