import 'package:flutter/material.dart';

class FunctionsBar extends StatelessWidget {
  const FunctionsBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(

      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 15),
      child:  Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        Expanded(
          child: Card(
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: _FunctionButton(
                icon: Icons.send,
                label: 'Enviar',
                onTap: () {
                  Navigator.pushNamed(context, '/send');
                },
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Card(
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: _FunctionButton(
                icon: Icons.attach_money,
                label: 'Receber',
                onTap: () {
                  Navigator.pushNamed(context, '/receive');
                },
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Card(
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: _FunctionButton(
                icon: Icons.arrow_downward,
                label: 'Depositar',
                onTap: () {
                  Navigator.pushNamed(context, '/deposit');
                },
              ),
            ),
          ),
        ),
      ],
    ),
    );
  }
}

class _FunctionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _FunctionButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        IconButton(
          icon: Icon(icon, color:  Color.fromARGB(255, 110, 82, 169)),
          onPressed: onTap,
        ),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}
