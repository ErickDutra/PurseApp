import 'package:flutter/material.dart';

class BalanceCard extends StatelessWidget {
  final double balance;
  final String currency;

  const BalanceCard({Key? key, required this.balance, this.currency = 'R\$'})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Card(
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
                              color:  Color.fromARGB(255, 110, 82, 169),
                            ),
                            const SizedBox(height: 8),
                            Text(
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
                margin: const EdgeInsets.only(left: 90),
                child: IconButton(onPressed: () {
                Navigator.pushNamed(context, '/extrato');
                  }, icon: Icon(Icons.arrow_forward_ios_rounded, color: Color.fromARGB(255, 110, 82, 169),))),
            ],
          ),
        ),
      ),
    );
  }
}
