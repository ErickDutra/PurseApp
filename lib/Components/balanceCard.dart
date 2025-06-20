import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class BalanceCard extends StatefulWidget {
  
  const BalanceCard({Key? key}) : super(key: key);

  @override
  State<BalanceCard> createState() => _BalanceCardState();
}

class _BalanceCardState extends State<BalanceCard> {
  double balance = 0.0;

  @override
  void initState() {
    super.initState();
    fetchBalance();
  }

  Future<void> fetchBalance() async {
  try {
    final prefs = await SharedPreferences.getInstance();
    final address = prefs.getString('address') ?? '';

    final url = Uri.parse('http://10.0.2.2:8082/balance/getBalance/$address');
    final response = await http.get(
      url,
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        balance = data['valueUSD'] is int ? (data['valueUSD'] as int).toDouble() : data['valueUSD'];
      });
    }
  } catch (e) {

  }
}
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Row(
          children: [
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.account_balance_wallet,
                            size: 29,
                            color: Color.fromARGB(255, 110, 82, 169),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Saldo disponível',
                            style: TextStyle(fontSize: 15, color: Colors.grey),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'ρ ${balance.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          '\$ ${(balance / 5).toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              alignment: Alignment.centerRight,
              width: 30,
              height: 50,
              margin: const EdgeInsets.only(left: 8),
              child: IconButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/extrato').then((_) {
                    fetchBalance(); // Atualiza o saldo ao voltar do extrato
                  });
                },
                icon: const Icon(Icons.arrow_forward_ios_rounded, color: Color.fromARGB(255, 110, 82, 169)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}