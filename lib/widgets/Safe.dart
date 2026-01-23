import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ashkerty_food/providers/Auth_provider.dart';
import 'package:ashkerty_food/API/Client.dart' as clientApi;
import 'package:ashkerty_food/API/Safe.dart';

class SafePage extends StatefulWidget {
  const SafePage({Key? key}) : super(key: key);

  @override
  State<SafePage> createState() => _SafePageState();
}

class _SafePageState extends State<SafePage> {
  double bankAmount = 0;
  double cashAmount = 0;
  double deptAmount = 0;
  bool loading = true;

  List clients = [];
  String? selectedClient;
  String transferType = 'cash_to_bank';
  double transferAmount = 0;

  @override
  void initState() {
    super.initState();
    _loadSafe();
    _loadClients();
  }

  Future<void> _loadSafe() async {
    setState(() => loading = true);

    final res = await APISafe.getSafe();
    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);
      setState(() {
        bankAmount = data['bankAmount'] ?? 0;
        cashAmount = data['cashAmount'] ?? 0;
        deptAmount = data['deptAmount'] ?? 0;
        loading = false;
      });
    } else {
      setState(() => loading = false);
    }
  }

  Future<void> _loadClients() async {
    final res = await clientApi.APIClient.Get();
    if (res.statusCode == 200) {
      setState(() {
        clients = jsonDecode(res.body);
      });
    }
  }

  Future<void> _transfer() async {
    final body = {
      'type': transferType,
      'amount': transferAmount,
      'clientId': selectedClient,
    };
    final res = await APISafe.transfer(body);
    if (res.statusCode == 200) {
      Navigator.pop(context);
      _loadSafe();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تم التحويل بنجاح')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('خطأ: ${res.body}')),
      );
    }
  }

  void _showTransferModal() {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text('تحويل مبلغ'),
          content: StatefulBuilder(
            builder: (context, setModalState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DropdownButtonFormField<String>(
                    initialValue: transferType,
                    items: [
                      DropdownMenuItem(
                        value: 'cash_to_bank',
                        child: Text('من النقدي إلى البنك'),
                      ),
                      DropdownMenuItem(
                        value: 'bank_to_cash',
                        child: Text('من البنك إلى النقدي'),
                      ),
                      DropdownMenuItem(
                        value: 'cash_to_dept',
                        child: Text('من النقدي إلى الدين'),
                      ),
                      DropdownMenuItem(
                        value: 'bank_to_dept',
                        child: Text('من البنك إلى الدين'),
                      ),
                      DropdownMenuItem(
                        value: 'dept_to_cash',
                        child: Text('من الدين إلى النقدي'),
                      ),
                      DropdownMenuItem(
                        value: 'dept_to_bank',
                        child: Text('من الدين إلى البنك'),
                      ),
                    ],
                    onChanged: (v) => setModalState(() => transferType = v!),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    decoration: const InputDecoration(
                      labelText: 'المبلغ',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (v) => setModalState(
                        () => transferAmount = double.tryParse(v) ?? 0),
                  ),
                  if (transferType.contains('dept'))
                    DropdownButtonFormField<String>(
                      initialValue: selectedClient,
                      items: clients
                          .map<DropdownMenuItem<String>>(
                              (c) => DropdownMenuItem(
                                    value: c['id'].toString(),
                                    child: Text(c['name']),
                                  ))
                          .toList(),
                      onChanged: (v) => setModalState(() => selectedClient = v),
                      decoration: const InputDecoration(
                        labelText: 'اختر العميل',
                        border: OutlineInputBorder(),
                      ),
                    ),
                ],
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('إلغاء'),
            ),
            ElevatedButton(
              onPressed: _transfer,
              child: const Text('تحويل'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(builder: (context, value, child) {
      if (value.user == null || value.user!['role'] != 'admin') {
        return const Center(
          child: Text('انت غير مخول للوصول الى هذه الصفحة',
              style: TextStyle(fontSize: 30, color: Colors.red)),
        );
      }
      return Scaffold(
        appBar: AppBar(
          title: const Text('الخزنة'),
          backgroundColor: Colors.teal,
        ),
        body: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildCard('رصيد البنك', bankAmount, Colors.blue),
                  _buildCard('رصيد النقدي', cashAmount, Colors.green),
                  _buildCard('رصيد الدين', deptAmount, Colors.red),
                ],
              ),
              const SizedBox(height: 40),
              ElevatedButton.icon(
                onPressed: _showTransferModal,
                icon: const Icon(Icons.compare_arrows),
                label: const Text('تحويل بين الأرصدة'),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildCard(String title, double amount, Color color) {
    return Card(
      elevation: 4,
      color: color.withOpacity(0.1),
      child: Container(
        width: 200,
        height: 120,
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(title,
                style: TextStyle(
                    fontSize: 20, color: color, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Text(amount.toStringAsFixed(2),
                style: TextStyle(fontSize: 28, color: color)),
          ],
        ),
      ),
    );
  }
}
