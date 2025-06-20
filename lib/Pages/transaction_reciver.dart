import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class TransactionReciver extends StatefulWidget {
  const TransactionReciver({Key? key}) : super(key: key);

  @override
  State<TransactionReciver> createState() => _TransactionReciverState();
}

class _TransactionReciverState extends State<TransactionReciver> {
  List<Map<String, dynamic>> _transactions = [];
  bool _loading = true;
  String address = '';

  @override
  void initState() {
    super.initState();
    fetchAddress();
  }

  Future<void> fetchAddress() async {
    final prefs = await SharedPreferences.getInstance();
    address = prefs.getString('address') ?? '';
    setState(() {
      address = address;
    });
    fetchTransactions();
  }

  Future<void> acceptTransaction(String transactionID, String signature) async {
  final url = Uri.parse('http://10.0.2.2:8082/acceptTransaction');
  final response = await http.post(
    url,
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({
      'transactionID': transactionID,
      'signature': signature,
    }),
  );
  if (response.statusCode == 200) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Transação aceita com sucesso!')),
    );
    fetchTransactions(); // Atualiza a lista após aceitar
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Erro ao aceitar: ${response.body}')),
    );
  }
}

  Future<void> fetchTransactions() async {
    setState(() {
      _loading = true;
    });
    final url = Uri.parse(
      'http://10.0.2.2:8082/getTransactionsDestination/${address}',
    );
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      setState(() {
        _transactions = data.cast<Map<String, dynamic>>();
        _loading = false;
      });
    } else {
      setState(() {
        _loading = false;
      });
      // Trate o erro conforme necessário
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16),
      child:
          _loading
              ? const Padding(
                padding: EdgeInsets.all(24),
                child: Center(child: CircularProgressIndicator()),
              )
              : _transactions.isEmpty
              ? const Padding(
                padding: EdgeInsets.all(24),
                child: Center(child: Text('Nenhuma transação para aceitar')),
              )
              : ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _transactions.length,
                itemBuilder: (context, index) {
                  final tx = _transactions[index];
                  return ListTile(
                    title: Text(
                      'Cripto: ${tx['idCrypto']} - Valor: ${tx['amount']}',
                    ),
                    subtitle: Text(
                      'Origem: ${tx['idAddressOrigin']}',
                    ),
                    trailing: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: tx['status'] == 'CONFIRMED' ? Colors.green : null,
                    ),
                    onPressed: tx['status'] == 'CONFIRMED'
                        ? null 
                        : () {
                            acceptTransaction(tx['idTransaction'], address);
                          },
                    child: const Text('Aceitar'),
                  ),
                  );
                },
              ),
    );
  }
}
