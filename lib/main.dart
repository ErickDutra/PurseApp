import 'package:flutter/material.dart';
import 'package:purseapp/Components/analiticBalance.dart';
import 'package:purseapp/Components/balanceCard.dart';
import 'package:purseapp/Components/custom_drawer.dart';
import 'package:purseapp/Components/functionsBar.dart';
import 'package:purseapp/Pages/LoginPage.dart';
import 'package:purseapp/Pages/depositPage.dart';
import 'package:purseapp/Pages/extratusPage.dart';
import 'package:purseapp/Pages/receivePage.dart';
import 'package:purseapp/Pages/sendPage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Purse',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Color.fromARGB(255, 110, 82, 169),
        ),
      ),
      home: const LoginPage(),
      routes: {
        '/home': (context) => const MyHomePage(title: 'Purse'),
        '/extrato':(context) => ExtratusPage(),
        '/send':(context) => SendPage(),
        '/receive':(context) => ReceivePage(),
        '/deposit':(context) => DepositPage()
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 110, 82, 169),
        title: Container(
          padding: const EdgeInsets.symmetric(horizontal: 105),
          child: Text(
            'Purse',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              fontFamily: 'San Francisco',
              color: Colors.white,
              shadows: [Shadow(color: Colors.black, offset: Offset(1, 1))],
            ),
          ),
        ),
      ),
       drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const CustomDrawerHeader(),
            ListTile(
              title: const Text('Item 1'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Item 2'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      body: Center(
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color.fromARGB(255, 110, 82, 169),
                Color.fromARGB(255, 110, 82, 169),
                Color.fromARGB(134, 45, 42, 51),
              ],
            ),
          ),
          child: ListView(
            children: [
              BalanceCard(balance: 1000.00),
              FunctionsBar(),
              AnaliticBalance(income: 100, outcome: 100),
            ],
          ),
        ),
      ),
    );
  }
}
