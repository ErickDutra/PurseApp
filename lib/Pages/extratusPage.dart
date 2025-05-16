import 'package:flutter/material.dart';

class ExtratusPage extends StatelessWidget {
  final List<Map<String, dynamic>> extratos;
  final DateTime? selectedDate;
  final void Function(DateTime?)? onDateChanged;

  const ExtratusPage({
    Key? key,
    this.extratos = const [],
    this.selectedDate,
    this.onDateChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> filteredExtratos = selectedDate == null
        ? extratos
        : extratos.where((item) {
            DateTime date = item['date'] as DateTime;
            return date.year == selectedDate!.year &&
                date.month == selectedDate!.month &&
                date.day == selectedDate!.day;
          }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Extrato'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                const Text(
                  'Filtrar por data:',
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: () async {
                    DateTime? picked = await showDatePicker(
                      context: context,
                      initialDate: selectedDate ?? DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                    );
                    if (onDateChanged != null) {
                      onDateChanged!(picked);
                    }
                  },
                  child: Text(selectedDate == null
                      ? 'Selecionar data'
                      : '${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}'),
                ),
              ],
            ),
          ),
          Expanded(
            child: filteredExtratos.isEmpty
                ? const Center(child: Text('Nenhum extrato encontrado.'))
                : ListView.builder(
                    itemCount: filteredExtratos.length,
                    itemBuilder: (context, index) {
                      final item = filteredExtratos[index];
                      return ListTile(
                        leading: Icon(
                          item['type'] == 'entrada'
                              ? Icons.arrow_downward
                              : Icons.arrow_upward,
                          color: item['type'] == 'entrada'
                              ? Colors.green
                              : Colors.red,
                        ),
                        title: Text(item['description'] ?? ''),
                        subtitle: Text(
                          '${item['date'].day}/${item['date'].month}/${item['date'].year}',
                        ),
                        trailing: Text(
                          'R\$ ${item['value'].toStringAsFixed(2)}',
                          style: TextStyle(
                            color: item['type'] == 'entrada'
                                ? Colors.green
                                : Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}