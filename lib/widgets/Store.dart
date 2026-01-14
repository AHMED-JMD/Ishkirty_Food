import 'dart:convert';
import 'package:ashkerty_food/providers/Auth_provider.dart';
import 'package:ashkerty_food/static/drawer.dart';
import 'package:ashkerty_food/static/formatter.dart';
import 'package:ashkerty_food/static/leadinButton.dart';
import 'package:ashkerty_food/widgets/PurchaseRequest.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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

    //call
    final res = await api.APIStore.getItems();
    if (res.statusCode == 200) {
      final body = jsonDecode(res.body);
      List data = List.from(body);
      _items = data.map((e) => StockItem.fromJson(e)).toList();
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
    bool isKilo = item != null
        ? item.isKilo
            ? true
            : false
        : false;
    final formKey = GlobalKey<FormState>();

    showDialog(
        context: context,
        builder: (_) => StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
              return AlertDialog(
                title: Center(
                    child: Text(
                        item == null ? 'اضافة عنصر للمخزون' : 'تعديل العنصر')),
                content: Form(
                  key: formKey,
                  child: Directionality(
                    textDirection: TextDirection.rtl,
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextFormField(
                            controller: nameCtrl,
                            decoration:
                                const InputDecoration(labelText: 'الاسم'),
                            validator: (v) => (v == null || v.trim().isEmpty)
                                ? 'Required'
                                : null,
                          ),
                          TextFormField(
                            controller: sellCtrl,
                            decoration:
                                const InputDecoration(labelText: 'سعر البيع'),
                            keyboardType: const TextInputType.numberWithOptions(
                                decimal: true),
                            validator: (v) => double.tryParse(v ?? '') == null
                                ? 'Invalid'
                                : null,
                          ),
                          TextFormField(
                            controller: buyCtrl,
                            decoration:
                                const InputDecoration(labelText: 'سعر الشراء'),
                            keyboardType: const TextInputType.numberWithOptions(
                                decimal: true),
                            validator: (v) => double.tryParse(v ?? '') == null
                                ? 'Invalid'
                                : null,
                          ),
                          CheckboxListTile(
                            title: const Text('الكمية بالكيلو'),
                            value: isKilo,
                            onChanged: (val) {
                              isKilo = val!;
                              setState(() {});
                            },
                            controlAffinity: ListTileControlAffinity.leading,
                          ),
                          TextFormField(
                            controller: qtyCtrl,
                            readOnly: item != null ? true : false,
                            decoration:
                                const InputDecoration(labelText: 'الكمية'),
                            keyboardType: const TextInputType.numberWithOptions(
                                decimal: true),
                            validator: (v) => int.tryParse(v ?? '') == null
                                ? 'Invalid'
                                : null,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                actions: [
                  TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text(
                        'الغاء',
                        style: TextStyle(color: Colors.black),
                      )),
                  ElevatedButton(
                    onPressed: () async {
                      if (!formKey.currentState!.validate()) return;
                      final dto = {
                        if (item?.id != null) 'id': item!.id,
                        'name': nameCtrl.text.trim(),
                        'sell_price': double.parse(sellCtrl.text.trim()),
                        'buy_price': double.parse(buyCtrl.text.trim()),
                        'quantity': int.parse(qtyCtrl.text.trim()),
                        'isKilo': isKilo,
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
                    child:
                        const Text('حفظ', style: TextStyle(color: Colors.teal)),
                  ),
                ],
              );
            }));
  }

  void _confirmDelete(StockItem it) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Center(child: Text('حذف العنصر')),
        content: Text(
          "سيتم حذف ${it.name} ولن يكون هناك صنف مرتبط به",
          textDirection: TextDirection.rtl,
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child:
                  const Text('الغاء', style: TextStyle(color: Colors.black))),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              final res = await api.APIStore.deleteItem({'id': it.id});
              if (res.statusCode == 200) {
                await _load();
              } else {
                _showError(res.body);
              }
            },
            child: const Text('حذف', style: TextStyle(color: Colors.redAccent)),
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
    return Consumer<AuthProvider>(builder: (context, value, child) {
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
            child: value.user == null || value.user!['role'] != 'admin'
                ? const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(
                        child: Text(
                          'انت غير مخول للوصول الى هذه الصفحة',
                          style: TextStyle(fontSize: 30, color: Colors.red),
                        ),
                      ),
                      SizedBox(height: 20),
                      Center(
                        child: Icon(
                          Icons.lock,
                          size: 100,
                          color: Colors.red,
                        ),
                      ),
                    ],
                  )
                : Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.4,
                                child: TextField(
                                  decoration: const InputDecoration(
                                      prefixIcon: Icon(Icons.search),
                                      hintText: 'ايجاد منتج بالاسم .....'),
                                  onChanged: (v) {
                                    setState(() {
                                      _search = v;
                                      _applyFilter();
                                    });
                                  },
                                ),
                              ),
                              const SizedBox(width: 20),
                              IconButton(
                                onPressed: _showForm,
                                icon: const Icon(
                                  Icons.add_circle,
                                  size: 30,
                                ),
                                tooltip: "اضافة منتج",
                              ),
                              IconButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) =>
                                              const PurchaseRequestPage()));
                                },
                                icon: const Icon(
                                  Icons.shopping_cart,
                                  size: 28,
                                ),
                                tooltip: "طلبات الشراء",
                              )
                            ],
                          ),
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        const Icon(Icons.monetization_on,
                                            color: Colors.orange),
                                        const SizedBox(height: 8),
                                        const Text('قيمة المخزون',
                                            style: TextStyle(fontSize: 12)),
                                        const SizedBox(height: 6),
                                        Text(
                                          "${numberFormatter(totalStockValue)} (جنيه)",
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
                      const SizedBox(height: 60),
                      Expanded(
                        child: _loading
                            ? const Center(child: CircularProgressIndicator())
                            : SizedBox(
                                width: double.infinity,
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    Expanded(
                                      child: SingleChildScrollView(
                                        child: DataTable(
                                          columns: const [
                                            DataColumn(
                                                label: Text(
                                              'الاسم',
                                              style: TextStyle(fontSize: 20),
                                            )),
                                            DataColumn(
                                                label: Text(
                                              'سعر البيع',
                                              style: TextStyle(fontSize: 20),
                                            )),
                                            DataColumn(
                                                label: Text(
                                              'سعر الشراء',
                                              style: TextStyle(fontSize: 20),
                                            )),
                                            DataColumn(
                                                label: Text(
                                              'الكمية',
                                              style: TextStyle(fontSize: 20),
                                            )),
                                            DataColumn(
                                                label: Text(
                                              'الإجراءات',
                                              style: TextStyle(fontSize: 20),
                                            )),
                                          ],
                                          rows: _filtered.map((it) {
                                            return DataRow(cells: [
                                              DataCell(Text(
                                                it.name,
                                                style: const TextStyle(
                                                    fontSize: 17),
                                              )),
                                              DataCell(Text(
                                                "${numberFormatter(it.sellPrice)} (جنيه)",
                                                style: const TextStyle(
                                                    fontSize: 17),
                                              )),
                                              DataCell(Text(
                                                "${numberFormatter(it.buyPrice)} (جنيه)",
                                                style: const TextStyle(
                                                    fontSize: 17),
                                              )),
                                              DataCell(Text(
                                                it.isKilo
                                                    ? "${numberFormatter(it.quantity, fractionDigits: 2)} / كجم"
                                                    : "${numberFormatter(it.quantity)} / قطع",
                                                style: const TextStyle(
                                                    fontSize: 17),
                                              )),
                                              DataCell(Row(
                                                children: [
                                                  IconButton(
                                                    icon: const Icon(Icons.edit,
                                                        size: 18),
                                                    onPressed: () =>
                                                        _showForm(item: it),
                                                  ),
                                                  IconButton(
                                                    icon: const Icon(
                                                      Icons.delete,
                                                      size: 18,
                                                    ),
                                                    onPressed: () =>
                                                        _confirmDelete(it),
                                                  ),
                                                ],
                                              )),
                                            ]);
                                          }).toList(),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                      ),
                    ],
                  ),
          ),
        ),
      );
    });
  }
}
