import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SelectCryptoDialog extends StatefulWidget {
  const SelectCryptoDialog({Key? key}) : super(key: key);

  @override
  State<SelectCryptoDialog> createState() => _SelectCryptoDialogState();
}
class CryptoDto{
  final String id;
  final String name;
  final String symbol;

  CryptoDto({
    required this.id,
    required this.name,
    required this.symbol,
  });
}

class _SelectCryptoDialogState extends State<SelectCryptoDialog> {
  String? _selectedCryptoId;
  CryptoDto? _selectedCryptoDto;
  final TextEditingController _amountController = TextEditingController();
  List<Map<String, dynamic>> _cryptos = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    fetchCryptos();
  }

  Future<void> fetchCryptos() async {
    try {
      final url = Uri.parse('http://10.0.2.2:8082/crypto/all');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        setState(() {
          _cryptos = data.cast<Map<String, dynamic>>();
          _loading = false;
        });
      } else {
        throw Exception('Erro ao buscar criptos');
      }
    } catch (e) {
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Selecionar Criptomoeda'),
      content: _loading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButtonFormField<String>(
                  value: _selectedCryptoId,
                  items: _cryptos
                      .map(
                        (crypto) => DropdownMenuItem<String>(
                          value: crypto['id'].toString(),
                          child: Text('${crypto['name']} (${crypto['symbol']})'),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedCryptoId = value;
                      final selected = _cryptos.firstWhere(
                        (c) => c['id'].toString() == value,
                        orElse: () => {},
                      );
                      if (selected.isNotEmpty) {
                        _selectedCryptoDto = CryptoDto(
                          id: selected['id'].toString(),
                          name: selected['name'].toString(),
                          symbol: selected['symbol'].toString(),
                        );
                      } else {
                        _selectedCryptoDto = null;
                      }
                    });
                  },
                  decoration: const InputDecoration(
                    labelText: 'Criptomoeda',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) =>
                      value == null ? 'Selecione uma criptomoeda' : null,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _amountController,
                  keyboardType: TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  decoration: const InputDecoration(
                    labelText: 'Quantidade',
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_selectedCryptoDto != null &&
                _amountController.text.isNotEmpty) {
              Navigator.of(context).pop({
                'crypto': _selectedCryptoDto,
                'amount': _amountController.text,
              });
            }
          },
          child: const Text('Confirmar'),
        ),
      ],
    );
  }
}
