import 'dart:convert';
import 'package:ashkerty_food/Components/tables/StoreTable.dart';
import 'package:ashkerty_food/providers/Auth_provider.dart';
import 'package:ashkerty_food/static/drawer.dart';
import 'package:ashkerty_food/static/leadinButton.dart';
import 'package:ashkerty_food/widgets/Discharges.dart';
import 'package:ashkerty_food/widgets/StoreAcquisition.dart';
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

    final res = await api.APIStore.getItems({'type': 'بيع'});
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
      _items.fold(0.0, (p, e) => p + e.sellPrice * e.quantity);

  void _showPurchaseForm(String adminId) {
    final vendorCtrl = TextEditingController(text: "عام");
    final qtyCtrl = TextEditingController();
    final netQtyCtrl = TextEditingController();
    final storeCtrl = TextEditingController();
    DateTime pickedDate = DateTime.now();
    final formKey = GlobalKey<FormState>();

    String paymentMethod = 'كاش';
    showDialog(
        context: context,
        builder: (_) => StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
              return AlertDialog(
                title: const Center(child: Text('استلام جديد')),
                content: Form(
                  key: formKey,
                  child: Directionality(
                    textDirection: TextDirection.rtl,
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextFormField(
                            controller: vendorCtrl,
                            decoration:
                                const InputDecoration(labelText: 'المورد'),
                            validator: (v) => (v == null || v.trim().isEmpty)
                                ? 'Required'
                                : null,
                          ),
                          DropdownButtonFormField<String>(
                            decoration:
                                const InputDecoration(labelText: 'اختر الصنف'),
                            items: _items
                                .map((s) => DropdownMenuItem(
                                      value: s.id,
                                      child: Text(s.name),
                                    ))
                                .toList(),
                            onChanged: (val) {
                              storeCtrl.text = val ?? '';
                            },
                            validator: (v) =>
                                (v == null || v.isEmpty) ? 'Required' : null,
                          ),
                          TextFormField(
                            controller: qtyCtrl,
                            decoration:
                                const InputDecoration(labelText: 'الكمية'),
                            keyboardType: const TextInputType.numberWithOptions(
                                decimal: true),
                            validator: (v) => double.tryParse(v ?? '') == null
                                ? 'Invalid'
                                : null,
                          ),
                          TextFormField(
                            controller: netQtyCtrl,
                            decoration:
                                const InputDecoration(labelText: 'صافي الكمية'),
                            keyboardType: const TextInputType.numberWithOptions(
                                decimal: true),
                            validator: (v) => double.tryParse(v ?? '') == null
                                ? 'Invalid'
                                : null,
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                    pickedDate.toString().split(' ').first),
                              ),
                              ElevatedButton(
                                  onPressed: () async {
                                    final d = await showDatePicker(
                                        context: context,
                                        initialDate: DateTime.now(),
                                        firstDate: DateTime(2000),
                                        lastDate: DateTime(2100));
                                    if (d != null) {
                                      pickedDate = d;
                                      setState(() {});
                                    }
                                  },
                                  child: const Text('تحديد'))
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                actions: [
                  TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('الغاء',
                          style: TextStyle(color: Colors.black))),
                  ElevatedButton(
                    onPressed: () async {
                      if (!formKey.currentState!.validate()) return;
                      //check quantity bigger than net quantity
                      if (qtyCtrl.text.trim() != netQtyCtrl.text.trim()) {
                        final q = double.tryParse(qtyCtrl.text.trim()) ?? 0;
                        final netQ =
                            double.tryParse(netQtyCtrl.text.trim()) ?? 0;

                        if (q <= netQ) {
                          _showError("الكمية يجب ان تكون اكبر من صافي الكمية");
                          return;
                        }
                      }

                      final dto = {
                        'store_item': storeCtrl.text.trim(),
                        'vendor': vendorCtrl.text.trim(),
                        'quantity': double.parse(qtyCtrl.text.trim()),
                        'net_quantity': double.parse(netQtyCtrl.text.trim()),
                        'payment_method': paymentMethod,
                        'date': pickedDate.toIso8601String(),
                        'type': 'بيع',
                        'tran_type': 'اضافة',
                        'admin_id': adminId,
                      };
                      Navigator.pop(context);
                      final res = await api.APIStore.addPurchase(dto);
                      if (res.statusCode == 200) {
                        await _load();
                      } else {
                        _showError(res.body);
                      }
                    },
                    child: const Text('اضافة',
                        style: TextStyle(color: Colors.teal)),
                  ),
                ],
              );
            }));
  }

  void _showForm({StockItem? item, String? adminId}) {
    final nameCtrl = TextEditingController(text: item?.name ?? '');
    final sellCtrl = TextEditingController(
        text: item != null ? item.sellPrice.toString() : '0');
    final qtyCtrl = TextEditingController(
        text: item != null ? item.quantity.toString() : '0');
    final warnCtrl = TextEditingController(
        text: item != null ? item.warnValue.toString() : '0');
    final typeCtrl = TextEditingController(
        text: item != null ? item.type.toString() : 'بيع');
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
                    child:
                        Text(item == null ? 'اضافة منتج بيع' : 'تعديل المنتج')),
                content: Form(
                  key: formKey,
                  child: Directionality(
                    textDirection: TextDirection.rtl,
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const SizedBox(height: 10),
                          TextFormField(
                            controller: nameCtrl,
                            decoration:
                                const InputDecoration(labelText: 'اسم الصنف'),
                            validator: (v) => (v == null || v.trim().isEmpty)
                                ? 'Required'
                                : null,
                          ),
                          TextFormField(
                            controller: typeCtrl,
                            readOnly: true,
                            decoration:
                                const InputDecoration(labelText: 'نوع المخزن'),
                            validator: (v) => (v == null || v.trim().isEmpty)
                                ? 'Required'
                                : null,
                            onChanged: (val) {
                              setState(
                                () => typeCtrl.text = val,
                              );
                            },
                          ),
                          if (typeCtrl.text == 'تصنيع')
                            TextFormField(
                              controller: sellCtrl,
                              decoration:
                                  const InputDecoration(labelText: 'السعر'),
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                      decimal: true),
                              validator: (v) => double.tryParse(v ?? '') == null
                                  ? 'Invalid'
                                  : null,
                            ),
                          TextFormField(
                            controller: qtyCtrl,
                            readOnly: item != null ? true : false,
                            decoration:
                                const InputDecoration(labelText: 'الكمية'),
                            keyboardType: const TextInputType.numberWithOptions(
                                decimal: true),
                            validator: (v) => double.tryParse(v ?? '') == null
                                ? 'Invalid'
                                : null,
                          ),
                          TextFormField(
                            controller: warnCtrl,
                            decoration: const InputDecoration(
                                labelText: 'انذار الكمية'),
                            keyboardType: const TextInputType.numberWithOptions(
                                decimal: true),
                            validator: (v) => double.tryParse(v ?? '') == null
                                ? 'Invalid'
                                : null,
                          ),
                          const SizedBox(height: 10),
                          if (typeCtrl.text == 'تصنيع')
                            CheckboxListTile(
                              title: const Text('الكمية بالكيلو'),
                              value: isKilo,
                              onChanged: (val) {
                                isKilo = val!;
                                setState(() {});
                              },
                              controlAffinity: ListTileControlAffinity.leading,
                            ),
                          const SizedBox(height: 10),
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
                        'quantity': double.parse(qtyCtrl.text.trim()),
                        'sell_price': double.parse(sellCtrl.text.trim()),
                        'warn_value': int.parse(warnCtrl.text.trim()),
                        'type': typeCtrl.text,
                        'isKilo': isKilo,
                        'admin_id': adminId,
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

  void _confirmDelete(StockItem it, String adminId) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Center(child: Text('حذف العنصر')),
        content: Text(
          "سيتم حذف ${it.name} ولن يكون هناك صنف مرتبط به",
          style: const TextStyle(fontSize: 16),
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
              final res = await api.APIStore.deleteItem(
                  {'id': it.id, 'admin_id': adminId});
              if (res.statusCode == 200) {
                await _load();
              } else {
                _showError(res.body);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
            ),
            child: const Text('حذف', style: TextStyle(color: Colors.white)),
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
      bool isAdmin = value.user['role'] == 'admin' ? true : false;

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
              "مخزن البيع",
              style: TextStyle(fontSize: 25, color: Colors.white),
            )),
            actions: const [
              LeadingDrawerBtn(),
            ],
            toolbarHeight: 45,
          ),
          endDrawer: const MyDrawer(),
          body: Padding(
            padding: const EdgeInsets.all(40.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
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
                              const Icon(Icons.inventory_2, color: Colors.teal),
                              const SizedBox(height: 8),
                              const Text('اجمالي الاصناف',
                                  style: TextStyle(
                                      fontSize: 12, color: Colors.black)),
                              const SizedBox(height: 6),
                              Text(
                                '${_items.length}',
                                style: const TextStyle(
                                    fontSize: 22, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    // SizedBox(
                    //   width: 180,
                    //   child: Card(
                    //     color: Colors.white,
                    //     elevation: 2,
                    //     child: Padding(
                    //       padding: const EdgeInsets.symmetric(
                    //           vertical: 12.0, horizontal: 8.0),
                    //       child: Column(
                    //         mainAxisSize: MainAxisSize.min,
                    //         crossAxisAlignment: CrossAxisAlignment.center,
                    //         children: [
                    //           const Icon(Icons.monetization_on,
                    //               color: Colors.orange),
                    //           const SizedBox(height: 8),
                    //           const Text('قيمة المخزون',
                    //               style: TextStyle(fontSize: 12)),
                    //           const SizedBox(height: 6),
                    //           Text(
                    //             "${numberFormatter(totalStockValue)} (جنيه)",
                    //             style: const TextStyle(
                    //                 fontSize: 18, fontWeight: FontWeight.bold),
                    //           ),
                    //         ],
                    //       ),
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
                const SizedBox(height: 30),
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
                        if (isAdmin)
                          IconButton(
                            onPressed: () =>
                                _showForm(adminId: value.user['id'].toString()),
                            icon: const Icon(
                              Icons.add_circle,
                              size: 30,
                            ),
                            tooltip: "اضافة منتج",
                          ),
                        const SizedBox(width: 10),
                        if (isAdmin)
                          IconButton(
                            onPressed: () =>
                                _showPurchaseForm(value.user['id'].toString()),
                            icon: const Icon(
                              Icons.shopping_basket,
                              size: 30,
                            ),
                            tooltip: "اضافة استلام",
                          ),
                        const SizedBox(width: 20),
                        ElevatedButton.icon(
                            onPressed: () {
                              Navigator.pushReplacementNamed(
                                  context, '/store_products');
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.teal,
                            ),
                            icon: const Icon(
                              Icons.factory,
                              color: Colors.black,
                            ),
                            label: const Text(
                              'مخزن التصنيع',
                              style: TextStyle(color: Colors.white),
                            )),
                      ],
                    ),
                    Row(
                      children: [
                        SizedBox(
                          height: 40,
                          child: ElevatedButton.icon(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) =>
                                          const StoreAcquisitions()));
                            },
                            icon: const Icon(
                              Icons.download_for_offline,
                              color: Colors.black,
                            ),
                            label: const Text(
                              "الاستلامات",
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        SizedBox(
                          height: 40,
                          child: ElevatedButton.icon(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => const DischargesPage()));
                            },
                            icon: const Icon(
                              Icons.money_off,
                              color: Colors.black,
                            ),
                            label: const Text(
                              "المنصرفات",
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        )
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 60),
                Expanded(
                  child: _loading
                      ? const Center(child: CircularProgressIndicator())
                      : SizedBox(
                          width: double.infinity,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Expanded(
                                child: SingleChildScrollView(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      StoreTable(
                                          admin: value.user,
                                          type: 'بيع',
                                          items: _filtered,
                                          confirmDelete: _confirmDelete,
                                          showForm: _showForm)
                                    ],
                                  ),
                                ),
                              ),
                              const Divider(
                                thickness: 3,
                              ),
                              const SizedBox(height: 50),
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
