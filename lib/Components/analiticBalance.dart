import 'package:flutter/material.dart';

class AnaliticBalance extends StatelessWidget {
  final double income;
  final double outcome;

  const AnaliticBalance({
    Key? key,
    required this.income,
    required this.outcome,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _BalanceInfo(
              label: 'Entradas',
              value: income,
              valueColor: Colors.green,
              icon: Icons.arrow_downward,
            ),
            _BalanceInfo(
              label: 'Saídas',
              value: outcome,
              valueColor: Colors.red,
              icon: Icons.arrow_upward,
            ),
          ],
        ),
      ),
    );
  }
}

class _BalanceInfo extends StatelessWidget {
  final String label;
  final double value;
  final Color valueColor;
  final IconData icon;

  const _BalanceInfo({
    required this.label,
    required this.value,
    required this.valueColor,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: valueColor, size: 28),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(fontSize: 14, color: Colors.grey),
        ),
        const SizedBox(height: 2),
        Text(
          'R\$ ${value.toStringAsFixed(2)}',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: valueColor,
          ),
        ),
      ],
    );
  }
}