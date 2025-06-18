import 'package:flutter/material.dart';

class BalanceCard extends StatelessWidget {
  final double balance;
  final String currency;


  
void _getBalance() async {
  if (_formKey.currentState!.validate()) {
    final email = _emailController.text.trim();
    final senha = _senhaController.text.trim();

    final url = Uri.parse('http://10.0.2.2:8082/user/login');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': senha}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final idUser = data['id'];
      final nome = data['name'];
      final address = data['address'];
      final email = data['email'];
      

      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('idUser', idUser);
      await prefs.setString('name', nome);
      await prefs.setString('address', address);
      await prefs.setString('email', email);
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Login inválido!')),
      );
    }
  }
}



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
