import 'dart:convert';
import 'package:ashkerty_food/models/Discharge.dart';
import 'package:ashkerty_food/providers/Auth_provider.dart';
import 'package:ashkerty_food/static/drawer.dart';
import 'package:ashkerty_food/static/leadinButton.dart';
import 'package:ashkerty_food/static/formatter.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../API/Discharges.dart' as api;
import 'package:ashkerty_food/Components/tables/DischargeTable.dart';

class DischargesPage extends StatefulWidget {
  const DischargesPage({Key? key}) : super(key: key);

  @override
  State<DischargesPage> createState() => _DischargesPageState();
}

class _DischargesPageState extends State<DischargesPage> {
  List<Discharge> _items = [];
  List<Discharge> _filtered = [];
  bool _loading = true;
  String _search = '';
  final todayDate = DateTime.now();
  String period = '';

  @override
  void initState() {
    super.initState();
    _load(todayDate, todayDate, 'اليوم');
  }

  Future _load(DateTime startDate, DateTime endDate, String periodText) async {
    setState(() => _loading = true);
    final res = await api.APIDischarges.getByDate({
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String()
    });

    if (res.statusCode == 200) {
      final body = jsonDecode(res.body);
      List data = List.from(body);
      print(data);
      _items = data.map((e) => Discharge.fromJson(e)).toList();
    }

    _applyFilter();
    setState(() {
      _loading = false;
      period = periodText;
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

  double get totalAmount => _items.fold(0.0, (p, e) => p + e.price);

  void _showForm(String adminId) {
    final nameCtrl = TextEditingController();
    final amountCtrl = TextEditingController();
    DateTime pickedDate = todayDate;
    bool isMonthly = false;
    final formKey = GlobalKey<FormState>();

    String paymentMethod = 'كاش';
    showDialog(
        context: context,
        builder: (_) => StatefulBuilder(
                builder: (BuildContext context, StateSetter setStateSB) {
              return AlertDialog(
                title: const Center(child: Text('اضافة مصروف')),
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
                          DropdownButtonFormField<String>(
                            initialValue: paymentMethod,
                            items: const [
                              DropdownMenuItem(
                                  value: 'كاش', child: Text('كاش')),
                              DropdownMenuItem(
                                  value: 'بنكك', child: Text('بنكك')),
                            ],
                            onChanged: (v) =>
                                setStateSB(() => paymentMethod = v ?? 'كاش'),
                            decoration:
                                const InputDecoration(labelText: 'طريقة الدفع'),
                          ),
                          TextFormField(
                            controller: amountCtrl,
                            decoration:
                                const InputDecoration(labelText: 'المبلغ'),
                            keyboardType: const TextInputType.numberWithOptions(
                                decimal: true),
                            validator: (v) => double.tryParse(v ?? '') == null
                                ? 'Invalid'
                                : null,
                          ),
                          // Row(
                          //   children: [
                          //     const Text('شهري؟'),
                          //     Checkbox(
                          //         value: isMonthly,
                          //         onChanged: (v) {
                          //           isMonthly = v ?? false;
                          //           setStateSB(() {});
                          //         }),
                          //   ],
                          // ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Expanded(
                                  child: Text(
                                      pickedDate.toString().split(' ').first)),
                              ElevatedButton(
                                  onPressed: () async {
                                    final d = await showDatePicker(
                                        context: context,
                                        initialDate: DateTime.now(),
                                        firstDate: DateTime(2000),
                                        lastDate: DateTime(2100));
                                    if (d != null) {
                                      pickedDate = d;
                                      setStateSB(() {});
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
                        'name': nameCtrl.text.trim(),
                        'price': double.parse(amountCtrl.text.trim()),
                        'date': pickedDate.toIso8601String(),
                        'isMonthly': isMonthly,
                        'paymentMethod': paymentMethod,
                        'admin_id': adminId,
                      };
                      Navigator.pop(context);
                      final res = await api.APIDischarges.addDischarge(dto);
                      if (res.statusCode == 200) {
                        await _load(todayDate, todayDate, 'اليوم');
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

  void _confirmDelete(Discharge it, String adminId) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Center(child: Text('حذف المصروف')),
        content: Text('سيتم حذف المصروف ${it.name}',
            textDirection: TextDirection.rtl),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child:
                  const Text('الغاء', style: TextStyle(color: Colors.black))),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);

              final res = await api.APIDischarges.deleteDischarge(
                  {'id': it.id, 'admin_id': adminId});
              if (res.statusCode == 200) {
                await _load(todayDate, todayDate, 'اليوم');
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
                child: Text('المصروفات', style: TextStyle(fontSize: 25))),
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
                                hintText: 'ايجاد مصروف .....'),
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
                            onPressed: () =>
                                _showForm(value.user['id'].toString()),
                            icon: const Icon(Icons.add_circle, size: 30),
                            tooltip: 'اضافة مصروف'),
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
                                  const Icon(Icons.account_balance_wallet,
                                      color: Colors.teal),
                                  const SizedBox(height: 8),
                                  const Text('اجمالي المصروفات',
                                      style: TextStyle(fontSize: 12)),
                                  const SizedBox(height: 6),
                                  Text('${_items.length}',
                                      style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold)),
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
                                  const Text('قيمة المصروفات',
                                      style: TextStyle(fontSize: 12)),
                                  const SizedBox(height: 6),
                                  Text("${numberFormatter(totalAmount)} (جنيه)",
                                      style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold)),
                                ],
                              ),
                            ),
                          ),
                        ),
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
                                    Text('المصروفات: ($period)',
                                        style: const TextStyle(fontSize: 30)),
                                    const SizedBox(width: 10),
                                    PopupMenuButton(
                                      icon: const Icon(Icons.date_range_rounded,
                                          size: 36, color: Colors.teal),
                                      tooltip: 'تصفية',
                                      onSelected: (value) {},
                                      itemBuilder: (BuildContext context) {
                                        return [
                                          PopupMenuItem(
                                            value: 'week',
                                            onTap: () {
                                              DateTime weekBeforeDate =
                                                  todayDate.subtract(
                                                      const Duration(days: 7));
                                              _load(weekBeforeDate, todayDate,
                                                  'الإسبوع');
                                            },
                                            child: const Text(
                                                'المصروفات الإسبوع',
                                                style: TextStyle(
                                                    color: Colors.black)),
                                          ),
                                          PopupMenuItem(
                                              value: 'month',
                                              onTap: () {
                                                DateTime monthBeforeDate =
                                                    todayDate.subtract(
                                                        const Duration(
                                                            days: 30));
                                                _load(monthBeforeDate,
                                                    todayDate, 'الشهر');
                                              },
                                              child: const Text(
                                                  'المصروفات الشهر',
                                                  style: TextStyle(
                                                      color: Colors.black))),
                                          PopupMenuItem(
                                              value: 'day',
                                              onTap: () => _load(todayDate,
                                                  todayDate, 'اليوم'),
                                              child: const Text(
                                                  'المصروفات اليوم',
                                                  style: TextStyle(
                                                      color: Colors.black))),
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
                                                      _load(d, d, 'يوم محدد');
                                                    }
                                                    Navigator.pop(context);
                                                  },
                                                  child: const Text('تحديد يوم',
                                                      style: TextStyle(
                                                          color: Colors.black)),
                                                ),
                                              ],
                                            )),
                                          ),
                                        ];
                                      },
                                    ),
                                  ]),
                              const SizedBox(height: 30),
                              Expanded(
                                  child: DischargeTable(
                                      admin: value.user,
                                      items: _filtered,
                                      onDelete: (it, adminId) =>
                                          _confirmDelete(it, adminId))),
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
