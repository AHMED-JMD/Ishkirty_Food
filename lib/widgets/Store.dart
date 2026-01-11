import 'dart:convert';
import 'package:ashkerty_food/static/drawer.dart';
import 'package:ashkerty_food/static/leadinButton.dart';
import 'package:flutter/material.dart';
import '../API/Store.dart' as api;
import '../models/StockItem.dart';

class StorePage extends StatefulWidget {
  const StorePage({Key? key}) : super(key: key);

  @override
  State<StorePage> createState() => _StorePageState();
}

class _StorePageState extends State<StorePage> {
  List<StockItem> _items = [];
  List<StockItem> _filtered = [];
  bool _loading = true;
  String _search = '';

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future _load() async {
    setState(() {
      _loading = true;
    });
    final res = await api.APIStore.getItems();
    if (res.statusCode == 200) {
      final body = jsonDecode(res.body);
      if (body is List) {
        _items = body.map((e) => StockItem.fromJson(e)).toList();
      } else if (body['data'] is List) {
        _items =
            (body['data'] as List).map((e) => StockItem.fromJson(e)).toList();
      }
    } else {
      // keep empty or show error
    }
    _applyFilter();
    setState(() {
      _loading = false;
    });
  }

  void _applyFilter() {
    if (_search.trim().isEmpty) {
      _filtered = List.from(_items);
    } else {
      final q = _search.toLowerCase();
      _filtered =
          _items.where((it) => it.name.toLowerCase().contains(q)).toList();
    }
  }

  double get totalStockValue =>
      _items.fold(0.0, (p, e) => p + e.buyPrice * e.quantity);

  void _showForm({StockItem? item}) {
    final nameCtrl = TextEditingController(text: item?.name ?? '');
    final sellCtrl = TextEditingController(
        text: item != null ? item.sellPrice.toString() : '');
    final buyCtrl = TextEditingController(
        text: item != null ? item.buyPrice.toString() : '');
    final qtyCtrl = TextEditingController(
        text: item != null ? item.quantity.toString() : '');
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(item == null ? 'Add Stock Item' : 'Edit Stock Item'),
        content: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: nameCtrl,
                  decoration: const InputDecoration(labelText: 'Name'),
                  validator: (v) =>
                      (v == null || v.trim().isEmpty) ? 'Required' : null,
                ),
                TextFormField(
                  controller: sellCtrl,
                  decoration: const InputDecoration(labelText: 'Sell Price'),
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  validator: (v) =>
                      double.tryParse(v ?? '') == null ? 'Invalid' : null,
                ),
                TextFormField(
                  controller: buyCtrl,
                  decoration: const InputDecoration(labelText: 'Buy Price'),
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  validator: (v) =>
                      double.tryParse(v ?? '') == null ? 'Invalid' : null,
                ),
                TextFormField(
                  controller: qtyCtrl,
                  decoration: const InputDecoration(labelText: 'Quantity'),
                  keyboardType: TextInputType.number,
                  validator: (v) =>
                      int.tryParse(v ?? '') == null ? 'Invalid' : null,
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              if (!formKey.currentState!.validate()) return;
              final dto = {
                if (item?.id != null) '_id': item!.id,
                'name': nameCtrl.text.trim(),
                'sellPrice': double.parse(sellCtrl.text.trim()),
                'buyPrice': double.parse(buyCtrl.text.trim()),
                'quantity': int.parse(qtyCtrl.text.trim()),
              };

              Navigator.pop(context);
              // call API
              if (item == null) {
                final res = await api.APIStore.addItem(dto);
                if (res.statusCode == 200) {
                  await _load();
                } else {
                  _showError(res.body);
                }
              } else {
                final res = await api.APIStore.updateItem(dto);
                if (res.statusCode == 200) {
                  await _load();
                } else {
                  _showError(res.body);
                }
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(StockItem it) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete item'),
        content: Text('Delete "${it.name}"?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              final res = await api.APIStore.deleteItem({'_id': it.id});
              if (res.statusCode == 200) {
                await _load();
              } else {
                _showError(res.body);
              }
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _showError(String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context), child: const Text('OK'))
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.teal,
          leading: IconButton(
            icon: const Icon(
              Icons.home_work,
              size: 37,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/home');
            },
          ),
          title: const Center(
              child: Text(
            "المخزن",
            style: TextStyle(fontSize: 25),
          )),
          actions: const [
            LeadingDrawerBtn(),
          ],
          toolbarHeight: 45,
        ),
        endDrawer: const MyDrawer(),
        body: Padding(
          padding: const EdgeInsets.all(50.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.4,
                    child: TextField(
                      decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.search),
                          hintText: 'Search by name'),
                      onChanged: (v) {
                        setState(() {
                          _search = v;
                          _applyFilter();
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Row(
                    children: [
                      SizedBox(
                        width: 160,
                        child: Card(
                          color: Colors.white,
                          elevation: 2,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 12.0, horizontal: 8.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Icon(Icons.inventory_2,
                                    color: Colors.teal),
                                const SizedBox(height: 8),
                                const Text('اجمالي الاصناف',
                                    style: TextStyle(fontSize: 12)),
                                const SizedBox(height: 6),
                                Text(
                                  '${_items.length}',
                                  style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      SizedBox(
                        width: 180,
                        child: Card(
                          color: Colors.white,
                          elevation: 2,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 12.0, horizontal: 8.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Icon(Icons.monetization_on,
                                    color: Colors.orange),
                                const SizedBox(height: 8),
                                const Text('قيمة المخزون',
                                    style: TextStyle(fontSize: 12)),
                                const SizedBox(height: 6),
                                Text(
                                  totalStockValue.toStringAsFixed(2),
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
              const SizedBox(height: 12),
              Expanded(
                child: _loading
                    ? const Center(child: CircularProgressIndicator())
                    : LayoutBuilder(builder: (context, constraints) {
                        return SingleChildScrollView(
                          child: ConstrainedBox(
                            constraints: BoxConstraints(
                                minHeight: constraints.maxHeight),
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: DataTable(
                                columns: const [
                                  DataColumn(label: Text('Name')),
                                  DataColumn(label: Text('Sell Price')),
                                  DataColumn(label: Text('Buy Price')),
                                  DataColumn(label: Text('Quantity')),
                                  DataColumn(label: Text('Actions')),
                                ],
                                rows: _filtered.map((it) {
                                  return DataRow(cells: [
                                    DataCell(Text(it.name)),
                                    DataCell(
                                        Text(it.sellPrice.toStringAsFixed(2))),
                                    DataCell(
                                        Text(it.buyPrice.toStringAsFixed(2))),
                                    DataCell(Text(it.quantity.toString())),
                                    DataCell(Row(
                                      children: [
                                        IconButton(
                                          icon:
                                              const Icon(Icons.edit, size: 18),
                                          onPressed: () => _showForm(item: it),
                                        ),
                                        IconButton(
                                          icon: const Icon(Icons.delete,
                                              size: 18),
                                          onPressed: () => _confirmDelete(it),
                                        ),
                                      ],
                                    )),
                                  ]);
                                }).toList(),
                              ),
                            ),
                          ),
                        );
                      }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
