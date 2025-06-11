import 'package:flutter/material.dart';

class CustomDrawerHeader extends StatefulWidget {
  const CustomDrawerHeader({super.key});

  @override
  State<CustomDrawerHeader> createState() => _CustomDrawerHeaderState();
}

class _CustomDrawerHeaderState extends State<CustomDrawerHeader> {
  final String nome = "João da Silva";
  final String cpf = "123.456.789-00";

  @override
  Widget build(BuildContext context) {
    return UserAccountsDrawerHeader(
      decoration: const BoxDecoration(
        color: Color.fromARGB(255, 110, 82, 169),
      ),
      accountName: Text(nome, style: const TextStyle(fontWeight: FontWeight.bold)),
      accountEmail: Text("CPF: $cpf"),
      currentAccountPicture: const CircleAvatar(
        backgroundColor: Colors.white,
        child: Icon(Icons.person, color: Color.fromARGB(255, 110, 82, 169)),
      ),
      otherAccountsPictures: [
        IconButton(
          icon: const Icon(Icons.logout, color: Colors.white),
          onPressed: () {
            // Aqui você pode adicionar a lógica de logout
            Navigator.of(context).pop(); // Fecha o Drawer
            // Exemplo: Navigator.of(context).pushReplacementNamed('/login');
          },
        ),
      ],
    );
  }
}