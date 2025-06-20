import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:purseapp/Components/send_dialog_information.dart';
import 'package:purseapp/Pages/qrCode_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SendPage extends StatefulWidget {
  const SendPage({Key? key}) : super(key: key);

  @override
  State<SendPage> createState() => _SendPageState();
}

class _SendPageState extends State<SendPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _cryptoController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();

  String _symbolCrypto = '';
  String _nameCrypto = '';

  CryptoDto cripto = CryptoDto(id: '', name: '', symbol: '');

  String address = '';
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
  }

  Future<void> sendValue({
    required String idWalletDestination,
    required String idCripto,
    required double amount,
  }) async {
    final url = Uri.parse('http://10.0.2.2:8082/send');
    final body = jsonEncode({
      "idAddressOrigin": address,
      "idAddressDestination": idWalletDestination,
      "idCrypto": idCripto,
      "amount": amount,
      "date":  DateTime.now().toIso8601String(),
    });
    print('Enviando dados: $body');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: body,
    );

    if (response.statusCode == 200) {
      // Sucesso
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Transferência realizada com sucesso!')),
      );
    } else {
      // Erro
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao enviar: ${response.body}')),
      );
    }
  }

  void _abrirDialog(BuildContext context) async {
    final result = await showDialog(
      context: context,
      builder: (_) => const SelectCryptoDialog(),
    );

    if (result != null) {
      setState(() {
        cripto = result['crypto'];
        _symbolCrypto = cripto.symbol;
        _nameCrypto = cripto.name;
        _cryptoController.text = cripto.id;
        _amountController.text = result['amount'];
      });
    }
  }

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
                  'Endereço do destinatário',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _addressController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.person_search),
                          hintText: 'Digite o Endereço',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Informe o Endereço';
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
                            _addressController.text = result;
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
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        readOnly: true,
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          labelText:
                              _nameCrypto.isEmpty ? 'Criptomoeda' : _nameCrypto,
                          prefix: Text(_symbolCrypto),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextFormField(
                        controller: _amountController,
                        readOnly: true,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Quantidade',
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () => _abrirDialog(context),
                      child: Text('Selecinar Cripto'),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () async {
                    if (address.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Aguarde carregar o endereço de origem!',
                          ),
                        ),
                      );
                      return;
                    }
                    if (_addressController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Informe o endereço de destino!'),
                        ),
                      );
                      return;
                    }
                    if (_cryptoController.text.isEmpty ||
                        _amountController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Selecione a cripto e a quantidade!'),
                        ),
                      );
                      return;
                    }
                    print('Enviando:');
                    print('Origem: $address');
                    print('Destino: ${_addressController.text}');
                    print('Cripto: ${_cryptoController.text}');
                    print('Quantidade: ${_amountController.text}');
                    await sendValue(
                      idWalletDestination: _addressController.text,
                      idCripto: _cryptoController.text,
                      amount: double.parse(_amountController.text),
                    );
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
