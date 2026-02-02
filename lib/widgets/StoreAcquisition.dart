import 'dart:convert';
import 'package:ashkerty_food/models/PurchaseRequest.dart';
import 'package:ashkerty_food/models/StockItem.dart';
import 'package:ashkerty_food/providers/Auth_provider.dart';
import 'package:ashkerty_food/static/drawer.dart';
import 'package:ashkerty_food/static/leadinButton.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../API/Store.dart' as api;
import 'package:ashkerty_food/Components/tables/PurchaseTable.dart';

class StoreAcquisitions extends StatefulWidget {
  const StoreAcquisitions({Key? key}) : super(key: key);

  @override
  State<StoreAcquisitions> createState() => _StoreAcquisitionsState();
}

class _StoreAcquisitionsState extends State<StoreAcquisitions> {
  List<PurchaseRequest> _items = [];
  List<PurchaseRequest> _filtered = [];
  List<StockItem> stores = [];
  bool _loading = true;
  String _search = '';
  final todayDate = DateTime.now();
  String period = "";

  @override
  void initState() {
    super.initState();
    _load(todayDate, todayDate, "اليوم");
    _loadStores();
  }

  Future _load(DateTime startDate, DateTime endDate, period) async {
    setState(() => _loading = true);

    final res = await api.APIStore.getPurchasesByDate({
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'type': 'بيع',
    });

    if (res.statusCode == 200) {
      final body = jsonDecode(res.body);

      List data = List.from(body);
      _items = data.map((e) => PurchaseRequest.fromJson(e)).toList();
    }
    _applyFilter();
    setState(() {
      _loading = false;
      this.period = period;
    });
  }

  Future _loadStores() async {
    //call
    final res = await api.APIStore.getItems({'type': 'بيع'});
    if (res.statusCode == 200) {
      final body = jsonDecode(res.body);
      List data = List.from(body);
      stores = data.map((e) => StockItem.fromJson(e)).toList();
    } else {
      // keep empty or show error
    }
  }

  void _applyFilter() {
    if (_search.trim().isEmpty) {
      _filtered = List.from(_items);
    } else {
      final q = _search.toLowerCase();
      _filtered = _items
          .where((it) => it.store.name.toString().toLowerCase().contains(q))
          .toList();
    }
  }

  double get totalStockValue =>
      _items.fold(0.0, (p, e) => p + e.buyPrice * e.quantity);

  void _showForm(String adminId) {
    final vendorCtrl = TextEditingController(text: "عام");
    final qtyCtrl = TextEditingController();

    final netQtyCtrl = TextEditingController();
    // final priceCtrl = TextEditingController();
    final storeCtrl = TextEditingController();
    DateTime pickedDate = todayDate;
    final formKey = GlobalKey<FormState>();

    String paymentMethod = 'كاش';
    showDialog(
        context: context,
        builder: (_) => StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
              return AlertDialog(
                title: const Center(child: Text('استلام مطبخ')),
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
                          // DropdownButtonFormField<String>(
                          //   initialValue: paymentMethod,
                          //   items: const [
                          //     DropdownMenuItem(
                          //         value: 'كاش', child: Text('كاش')),
                          //     DropdownMenuItem(
                          //         value: 'بنكك', child: Text('بنكك')),
                          //   ],
                          //   onChanged: (v) =>
                          //       setState(() => paymentMethod = v ?? 'كاش'),
                          //   decoration:
                          //       const InputDecoration(labelText: 'طريقة الدفع'),
                          // ),
                          DropdownButtonFormField<String>(
                            decoration:
                                const InputDecoration(labelText: 'اختر المخزن'),
                            items: stores
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
                          // TextFormField(
                          //   controller: priceCtrl,
                          //   decoration:
                          //       const InputDecoration(labelText: 'سعر الشراء'),
                          //   keyboardType: const TextInputType.numberWithOptions(
                          //       decimal: true),
                          //   validator: (v) => double.tryParse(v ?? '') == null
                          //       ? 'Invalid'
                          //       : null,
                          // ),
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
                      final dto = {
                        'store_item': storeCtrl.text.trim(),
                        'vendor': vendorCtrl.text.trim(),
                        'quantity': double.parse(qtyCtrl.text.trim()),
                        'net_quantity': double.parse(netQtyCtrl.text.trim()),
                        'payment_method': paymentMethod,
                        'date': pickedDate.toIso8601String(),
                        'type': 'بيع',
                        'admin_id': adminId,
                      };
                      Navigator.pop(context);
                      final res = await api.APIStore.addPurchase(dto);
                      if (res.statusCode == 200) {
                        await _load(todayDate, todayDate, "اليوم");
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

  void _confirmDelete(PurchaseRequest it, String adminId) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Center(child: Text('حذف كمية الاستلام')),
        content: Text(
          "سيتم حذف الاستلام ${it.vendor}",
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
              final res = await api.APIStore.deletePurchase(
                  {'id': it.id, 'admin_id': adminId});
              if (res.statusCode == 200) {
                await _load(todayDate, todayDate, "اليوم");
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
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back,
                size: 37,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/store_sell');
              },
            ),
            backgroundColor: Colors.teal,
            title: const Center(
                child: Text(
              "استلامات المطبخ",
              style: TextStyle(fontSize: 25, color: Colors.white),
            )),
            actions: const [LeadingDrawerBtn()],
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
                    Row(
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.4,
                          child: TextField(
                            decoration: const InputDecoration(
                                prefixIcon: Icon(Icons.search),
                                hintText: 'ايجاد طلب بالصنف .....'),
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
                          onPressed: () {
                            _showForm(value.user['id'].toString());
                          },
                          icon: const Icon(
                            Icons.add_circle,
                            size: 30,
                          ),
                          tooltip: "استلام منتج",
                        ),
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
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const Icon(Icons.shopping_bag,
                                      color: Colors.teal),
                                  const SizedBox(height: 8),
                                  const Text('اجمالي طلبات الاستلام',
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
                        //           const Text('قيمة المشتروات',
                        //               style: TextStyle(fontSize: 12)),
                        //           const SizedBox(height: 6),
                        //           Text(
                        //             "${numberFormatter(totalStockValue)} (جنيه)",
                        //             style: const TextStyle(
                        //                 fontSize: 18,
                        //                 fontWeight: FontWeight.bold),
                        //           ),
                        //         ],
                        //       ),
                        //     ),
                        //   ),
                        // ),
                      ],
                    )
                  ],
                ),
                const SizedBox(height: 80),
                Expanded(
                  child: _loading
                      ? const Center(child: CircularProgressIndicator())
                      : SizedBox(
                          width: double.infinity,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'استلامات : ($period)',
                                    style: const TextStyle(fontSize: 30),
                                  ),
                                  const SizedBox(width: 10),
                                  PopupMenuButton(
                                    icon: const Icon(
                                      Icons.date_range_rounded,
                                      size: 36,
                                      color: Colors.teal,
                                    ),
                                    tooltip: "تصفية",
                                    onSelected: (value) {},
                                    itemBuilder: (BuildContext context) {
                                      return [
                                        PopupMenuItem(
                                          value: 'week',
                                          onTap: () {
                                            // Get the date of a week before the current date
                                            DateTime weekBeforeDate =
                                                todayDate.subtract(
                                                    const Duration(days: 7));

                                            //call server
                                            _load(weekBeforeDate, todayDate,
                                                "الإسبوع");
                                          },
                                          child: const Text(
                                            'استلامات الإسبوع',
                                            style:
                                                TextStyle(color: Colors.black),
                                          ),
                                        ),
                                        PopupMenuItem(
                                            value: 'month',
                                            onTap: () {
                                              // Get the date of a week before the current date
                                              DateTime monthBeforeDate =
                                                  todayDate.subtract(
                                                      const Duration(days: 30));
                                              //call server
                                              _load(monthBeforeDate, todayDate,
                                                  "الشهر");
                                            },
                                            child: const Text(
                                              'استلامات الشهر',
                                              style: TextStyle(
                                                  color: Colors.black),
                                            )),
                                        PopupMenuItem(
                                            value: 'day',
                                            onTap: () => _load(
                                                todayDate, todayDate, "اليوم"),
                                            child: const Text(
                                              'استلامات اليوم',
                                              style: TextStyle(
                                                  color: Colors.black),
                                            )),
                                        PopupMenuItem(
                                          value: 'search_day',
                                          child: Form(
                                              child: Row(
                                            children: [
                                              ElevatedButton(
                                                onPressed: () async {
                                                  final d =
                                                      await showDatePicker(
                                                          context: context,
                                                          initialDate:
                                                              DateTime.now(),
                                                          firstDate:
                                                              DateTime(2000),
                                                          lastDate:
                                                              DateTime(2100));
                                                  if (d != null) {
                                                    //call server
                                                    _load(d, d, "يوم محدد");
                                                  }
                                                  Navigator.pop(context);
                                                },
                                                child: const Text(
                                                  'تحديد يوم',
                                                  style: TextStyle(
                                                      color: Colors.black),
                                                ),
                                              ),
                                            ],
                                          )),
                                        ),
                                      ];
                                    },
                                  ),
                                ],
                              ),
                              const SizedBox(height: 30),
                              Expanded(
                                child: PurchaseTable(
                                  admin: value.user,
                                  type: 'بيع',
                                  items: _filtered,
                                  onDelete: (it, adminId) =>
                                      _confirmDelete(it, adminId),
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
