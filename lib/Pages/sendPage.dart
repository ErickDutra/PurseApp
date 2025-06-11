import 'package:flutter/material.dart';
import 'package:purseapp/Pages/qrCode_page.dart';

class SendPage extends StatefulWidget {
  const SendPage({Key? key}) : super(key: key);

  @override
  State<SendPage> createState() => _SendPageState();
}

class _SendPageState extends State<SendPage> {
  final TextEditingController _cpfController = TextEditingController();
  final TextEditingController _valorController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Enviar')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'CPF do destinatário',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _cpfController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.person_search),
                          hintText: 'Digite o CPF',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Informe o CPF';
                          }
                          if (value.length != 11) {
                            return 'CPF deve ter 11 dígitos';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      icon: const Icon(Icons.qr_code_scanner),
                      tooltip: 'Ler QR Code',
                      onPressed: () async {
                        final result = await Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => const QRScanPage()),
                        );
                        if (result != null && result is String) {
                          setState(() {
                            _cpfController.text = result;
                          });
                        }
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                const Text(
                  'Valor para enviar',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _valorController,
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.attach_money),
                    hintText: 'Digite o valor',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Informe o valor';
                    }
                    final valor = double.tryParse(value.replaceAll(',', '.'));
                    if (valor == null || valor <= 0) {
                      return 'Valor inválido';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // Aqui você pode buscar a conta pelo CPF e enviar o valor
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Valor enviado!')),
                      );
                    }
                  },
                  child: const Text('Enviar'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
