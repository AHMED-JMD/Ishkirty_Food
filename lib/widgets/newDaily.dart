import 'dart:convert';

import 'package:ashkerty_food/API/Daily.dart';
import 'package:ashkerty_food/API/Discharges.dart';
import 'package:ashkerty_food/Components/tables/DischargeTable.dart';
import 'package:ashkerty_food/Components/tables/PurchaseTable.dart';
import 'package:ashkerty_food/models/Discharge.dart';
import 'package:ashkerty_food/models/PurchaseRequest.dart';
import 'package:ashkerty_food/Components/tables/EmployeeTransTable.dart';
import 'package:ashkerty_food/models/EmpTrans.dart';
import 'package:ashkerty_food/models/Employee.dart';
import 'package:ashkerty_food/models/StockItem.dart';
import 'package:ashkerty_food/providers/Auth_provider.dart';
import 'package:ashkerty_food/static/drawer.dart';
import 'package:ashkerty_food/static/leadinButton.dart';
import 'package:ashkerty_food/static/formatter.dart';
import '../static/SalesCard.dart';
import 'package:ashkerty_food/API/Sales.dart' as sales_api;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../API/Store.dart' as api;
import '../API/Employee.dart' as emp_api;

class NewDailyPage extends StatefulWidget {
  const NewDailyPage({Key? key}) : super(key: key);

  @override
  State<NewDailyPage> createState() => _NewDailyPageState();
}

class _NewDailyPageState extends State<NewDailyPage> {
  List<Discharge> _discharges = [];
  List<PurchaseRequest> _purchases = [];
  List<EmpTransaction> _empTrans = [];
  List<Employee> _employees = [];
  List<StockItem> _stores = [];
  bool _loading = true;
  double cashSales = 0.0;
  double bankSales = 0.0;

  // Sales cards state (morning / evening)
  int cashMor = 0;
  int bankMor = 0;
  int accountMor = 0;
  int totalMor = 0;
  int cashEv = 0;
  int bankEv = 0;
  int accountEv = 0;
  int totalEv = 0;
  String period = 'اليوم';

  //total spices from sales costs
  double totalSalesCosts = 0;

  //total employee Trans value
  double get totalEmpTransValue => _empTrans.fold(0.0, (p, e) => p + e.amount);

  //total purchases value
  double get totalPurchaseValue =>
      _purchases.fold(0.0, (p, e) => p + e.buyPrice * e.quantity);

  //total Discharges value
  double get totalDischargesValue =>
      _discharges.fold(0.0, (p, e) => p + e.price);

  @override
  void initState() {
    super.initState();
    _loadDischarges();
    _loadPurchases();
    _loadEmpTrans();
    _loadStores();
    _loadEmployees();
    _loadSalesCosts();
    _loadSales(DateTime.now(), DateTime.now());
  }

  // fetch API'S
  Future _loadSales(DateTime startDate, DateTime endDate) async {
    setState(() {
      _loading = true;
    });

    Map datas = {};
    datas['start_date'] = startDate.toIso8601String();
    datas['end_date'] = endDate.toIso8601String();

    final response = await sales_api.APISales.TodaySales(datas);
    if (response.statusCode == 200) {
      final res = jsonDecode(response.body);
      setState(() {
        _loading = false;
        cashMor = res["cashMor"].toInt();
        bankMor = res["bankMor"].toInt();
        accountMor = res["accountMor"].toInt();
        totalMor = res["totalMor"].toInt();
        cashEv = res["cashEv"].toInt();
        bankEv = res["bankEv"].toInt();
        accountEv = res["accountEv"].toInt();
        totalEv = res["totalEv"].toInt();
        period = 'اليوم';
      });
    } else {
      setState(() {
        _loading = false;
      });
    }
  }

  Future _loadSalesCosts() async {
    setState(() => _loading = true);
    // load today's purchases as sample
    final today = DateTime.now();
    final res = await sales_api.APISales.todayCosts({
      'startDate': today.toIso8601String(),
      'endDate': today.toIso8601String()
    });
    if (res.statusCode == 200) {
      final body = jsonDecode(res.body);
      totalSalesCosts = body['totalCosts'];
    }

    setState(() => _loading = false);
  }

  Future _loadDischarges() async {
    setState(() => _loading = true);
    // load today's purchases as sample
    final today = DateTime.now();
    final res = await APIDischarges.getByDate({
      'startDate': today.toIso8601String(),
      'endDate': today.toIso8601String()
    });
    if (res.statusCode == 200) {
      final body = jsonDecode(res.body);
      List data = List.from(body);
      _discharges = data.map((e) => Discharge.fromJson(e)).toList();
    }

    // rudimentary totals (placeholder — replace with real sales API if available)
    cashSales = _purchases.fold(0.0, (p, e) => p + (e.buyPrice * e.quantity));
    bankSales = 0.0;

    setState(() => _loading = false);
  }

  Future _loadPurchases() async {
    setState(() => _loading = true);
    // load today's purchases as sample
    final today = DateTime.now();
    final res = await api.APIStore.getPurchasesByDate({
      'startDate': today.toIso8601String(),
      'endDate': today.toIso8601String()
    });
    if (res.statusCode == 200) {
      final body = jsonDecode(res.body);
      List data = List.from(body);
      _purchases = data.map((e) => PurchaseRequest.fromJson(e)).toList();
    }

    // rudimentary totals (placeholder — replace with real sales API if available)
    cashSales = _purchases.fold(0.0, (p, e) => p + (e.buyPrice * e.quantity));
    bankSales = 0.0;

    setState(() => _loading = false);
  }

  Future _loadStores() async {
    final res = await api.APIStore.getItems();
    if (res.statusCode == 200) {
      final body = jsonDecode(res.body);
      List data = List.from(body);
      _stores = data.map((e) => StockItem.fromJson(e)).toList();
    }
  }

  Future _loadEmployees() async {
    try {
      final res = await emp_api.APIEmployee.getAll();
      if (res.statusCode == 200) {
        final body = jsonDecode(res.body);
        List data = List.from(body);
        _employees = data.map((e) => Employee.fromJson(e)).toList();
      }
    } catch (e) {
      // ignore
    }
  }

  Future _loadEmpTrans() async {
    setState(() => _loading = true);
    final today = DateTime.now();
    final res = await emp_api.APIEmployee.getTransByDate({
      'startDate': today.toIso8601String(),
      'endDate': today.toIso8601String()
    });
    if (res.statusCode == 200) {
      final body = jsonDecode(res.body);
      List data = List.from(body);
      _empTrans = data.map((e) => EmpTransaction.fromJson(e)).toList();
    }
    setState(() => _loading = false);
  }

//POST API'S
  Future _createDaily() async {
    setState(() => _loading = true);

    double totalCosts = totalSalesCosts +
        totalEmpTransValue +
        totalDischargesValue +
        totalPurchaseValue;

    double cashSales = cashMor.toDouble() + cashEv.toDouble();
    double bankSales = bankMor.toDouble() + bankEv.toDouble();
    double accountSales = accountMor.toDouble() + accountEv.toDouble();

    final today = DateTime.now();
    final res = await APIDaily.addDaily({
      'date': today.toIso8601String(),
      'cash_sales': cashSales,
      'bank_sales': bankSales,
      'account_sales': accountSales,
      'today_costs': totalCosts
    });
    if (res.statusCode == 200) {
      _showMessage(res.body);
    }
    _showMessage(res.body);
    setState(() => _loading = false);
  }

//models for form control
  void _showAddPurchaseDialog() async {
    final vendorCtrl = TextEditingController(text: "عام");
    final qtyCtrl = TextEditingController();
    final storeCtrl = TextEditingController();
    DateTime pickedDate = DateTime.now();
    final formKey = GlobalKey<FormState>();

    await showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            title: const Center(child: Text('اضافة طلب شراء')),
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
                        decoration: const InputDecoration(labelText: 'المورد'),
                        validator: (v) =>
                            (v == null || v.trim().isEmpty) ? 'Required' : null,
                      ),
                      DropdownButtonFormField<String>(
                        decoration:
                            const InputDecoration(labelText: 'اختر المخزن'),
                        items: _stores
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
                        decoration: const InputDecoration(labelText: 'الكمية'),
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true),
                        validator: (v) =>
                            double.tryParse(v ?? '') == null ? 'Invalid' : null,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: Text(pickedDate.toString().split(' ').first),
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
                  onPressed: () => Navigator.pop(ctx),
                  child: const Text('الغاء',
                      style: TextStyle(color: Colors.black))),
              ElevatedButton(
                onPressed: () async {
                  if (!formKey.currentState!.validate()) return;
                  final dto = {
                    'store_item': storeCtrl.text.trim(),
                    'vendor': vendorCtrl.text.trim(),
                    'quantity': double.parse(qtyCtrl.text.trim()),
                    'date': pickedDate.toIso8601String(),
                  };
                  Navigator.pop(ctx);
                  final res = await api.APIStore.addPurchase(dto);
                  if (res.statusCode == 200) {
                    await _loadPurchases();
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(res.body ?? 'Error')));
                  }
                },
                child:
                    const Text('اضافة', style: TextStyle(color: Colors.teal)),
              ),
            ],
          );
        });
  }

  void _showDischargesForm() {
    final nameCtrl = TextEditingController();
    final amountCtrl = TextEditingController();
    DateTime pickedDate = DateTime.now();
    bool isMonthly = false;
    final formKey = GlobalKey<FormState>();

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
                          Row(
                            children: [
                              const Text('شهري؟'),
                              Checkbox(
                                  value: isMonthly,
                                  onChanged: (v) {
                                    isMonthly = v ?? false;
                                    setStateSB(() {});
                                  }),
                            ],
                          ),
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
                      };
                      Navigator.pop(context);
                      final res = await APIDischarges.addDischarge(dto);
                      if (res.statusCode == 200) {
                        await _loadDischarges();
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(res.body ?? 'Error')));
                      }
                    },
                    child: const Text('اضافة',
                        style: TextStyle(color: Colors.teal)),
                  ),
                ],
              );
            }));
  }

  void _showAddEmpTrans() async {
    final amountCtrl = TextEditingController();
    Employee? selected = _employees.isNotEmpty ? _employees.first : null;
    String type = 'خصم';
    DateTime date = DateTime.now();

    await showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            title: const Center(child: Text('اضافة معاملة للعامل')),
            content: Directionality(
              textDirection: TextDirection.rtl,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    DropdownButtonFormField<Employee>(
                      initialValue: selected,
                      items: _employees
                          .map((e) =>
                              DropdownMenuItem(value: e, child: Text(e.name)))
                          .toList(),
                      onChanged: (v) => selected = v,
                      decoration:
                          const InputDecoration(labelText: 'اختر العامل'),
                    ),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      value: type,
                      items: const [
                        DropdownMenuItem(value: 'خصم', child: Text('خصم'))
                      ],
                      onChanged: (v) => type = v ?? 'خصم',
                      decoration: const InputDecoration(labelText: 'النوع'),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: amountCtrl,
                      decoration: const InputDecoration(labelText: 'المبلغ'),
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 8),
                    Row(children: [
                      const Text('التاريخ: '),
                      TextButton(
                          onPressed: () async {
                            final d = await showDatePicker(
                                context: context,
                                initialDate: date,
                                firstDate: DateTime(2000),
                                lastDate: DateTime(2100));
                            if (d != null) date = d;
                          },
                          child: Text('${date.year}/${date.month}/${date.day}'))
                    ])
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: const Text('الغاء',
                      style: TextStyle(color: Colors.black))),
              ElevatedButton(
                  onPressed: () async {
                    if (selected == null) return;
                    Navigator.pop(ctx);
                    final dto = {
                      'emp_id': selected!.id,
                      'type': type,
                      'amount': double.tryParse(amountCtrl.text) ?? 0,
                      'date': date.toIso8601String()
                    };
                    final res = await emp_api.APIEmployee.addTrans(dto);
                    if (res.statusCode == 200) {
                      await _loadEmpTrans();
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(res.body ?? 'Error')));
                    }
                  },
                  child:
                      const Text('اضافة', style: TextStyle(color: Colors.teal)))
            ],
          );
        });
  }

  void _showMessage(String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Center(child: Text('تم بنجاح')),
        content: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Text(
            message,
            style: const TextStyle(fontSize: 17),
          ),
        ),
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
                Navigator.pushReplacementNamed(context, '/daily');
              },
            ),
            backgroundColor: Colors.teal,
            title: const Center(child: Text('اليومية')),
            actions: const [LeadingDrawerBtn()],
            toolbarHeight: 45,
          ),
          endDrawer: const MyDrawer(),
          body: Padding(
            padding: const EdgeInsets.all(24.0),
            child: _loading
                ? const Center(child: CircularProgressIndicator())
                : value.user != null && value.user['role'] != 'admin'
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
                    : SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // Section 0: totals (sales cards)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Column(
                                  children: [
                                    Text(
                                      'إجمالي الإيرادات $period',
                                      style: const TextStyle(fontSize: 30),
                                    ),
                                    Text(
                                      "${numberFormatter(totalMor + totalEv)} / (جنيه) ",
                                      style: const TextStyle(fontSize: 30),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        const Text(
                                          ' تكاليف الاصناف ',
                                          style: TextStyle(
                                              fontSize: 20,
                                              color: Colors.redAccent,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          " = ${numberFormatter(totalSalesCosts)} / (جنيه) ",
                                          style: const TextStyle(
                                              fontSize: 20,
                                              color: Colors.redAccent,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: 330,
                                      decoration: BoxDecoration(
                                        color: Colors.grey[200],
                                        border: Border.all(
                                          width: 2,
                                        ),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: SalesCard(
                                        period: 'الوردية الصباحية',
                                        cashAmount: cashMor,
                                        bankakAmount: bankMor,
                                        accountsAmount: accountMor,
                                      ),
                                    ),
                                    const SizedBox(width: 30),
                                    Container(
                                      width: 330,
                                      decoration: BoxDecoration(
                                        color: const Color(0xffefecec),
                                        border: Border.all(
                                          width: 2,
                                        ),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: SalesCard(
                                        period: 'الوردية المسائية',
                                        cashAmount: cashEv,
                                        bankakAmount: bankEv,
                                        accountsAmount: accountEv,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 120),

                            // Section 1: employee transactions
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text('خصم مرتبات الموظفين',
                                    style: TextStyle(
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold)),
                                const SizedBox(width: 10),
                                ElevatedButton.icon(
                                  onPressed: _showAddEmpTrans,
                                  icon: const Icon(
                                    Icons.add_circle,
                                    color: Colors.black,
                                  ),
                                  label: const Text(
                                    'خصم المرتب',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.teal),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                const Text(
                                  ' إجمالي المرتبات : ',
                                  style: TextStyle(fontSize: 20),
                                ),
                                Text(
                                  "${numberFormatter(totalEmpTransValue)} / (جنيه) ",
                                  style: const TextStyle(fontSize: 20),
                                ),
                              ],
                            ),
                            Container(
                              padding: const EdgeInsets.all(30),
                              child: EmployeeTranTable(
                                  transactions: _empTrans,
                                  confirmDelete: (it) async {
                                    // reuse existing delete flow
                                    final res =
                                        await emp_api.APIEmployee.deleteTrans(
                                            {'id': it.id});
                                    if (res.statusCode == 200) {
                                      await _loadEmpTrans();
                                    }
                                  }),
                            ),
                            const Divider(),
                            const SizedBox(
                              height: 80,
                            ),

                            // Section 2: purchases
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text('طلبات الشراء',
                                    style: TextStyle(
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold)),
                                const SizedBox(
                                  width: 10,
                                ),
                                ElevatedButton.icon(
                                  onPressed: _showAddPurchaseDialog,
                                  icon: const Icon(
                                    Icons.add_circle,
                                    color: Colors.black,
                                  ),
                                  label: const Text(
                                    'اضافة طلب',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.teal),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                const Text(
                                  ' إجمالي المشتريات : ',
                                  style: TextStyle(fontSize: 20),
                                ),
                                Text(
                                  "${numberFormatter(totalPurchaseValue)} / (جنيه) ",
                                  style: const TextStyle(fontSize: 20),
                                ),
                              ],
                            ),
                            Container(
                              padding: const EdgeInsets.all(30),
                              child: PurchaseTable(
                                  items: _purchases,
                                  onDelete: (it) async {
                                    // reuse existing delete flow
                                    final res =
                                        await api.APIStore.deletePurchase(
                                            {'id': it.id});
                                    if (res.statusCode == 200) {
                                      await _loadPurchases();
                                    }
                                  }),
                            ),
                            const Divider(),

                            const SizedBox(height: 80),

                            // Section 3: deductions
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text('المنصرفات',
                                    style: TextStyle(
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold)),
                                const SizedBox(
                                  width: 10,
                                ),
                                ElevatedButton.icon(
                                  onPressed: _showDischargesForm,
                                  icon: const Icon(
                                    Icons.add_circle,
                                    color: Colors.black,
                                  ),
                                  label: const Text(
                                    'اضافة منصرف',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.teal),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                const Text(
                                  ' إجمالي المنصرفات : ',
                                  style: TextStyle(fontSize: 20),
                                ),
                                Text(
                                  "${numberFormatter(totalDischargesValue)} / (جنيه) ",
                                  style: const TextStyle(fontSize: 20),
                                ),
                              ],
                            ),
                            Container(
                              padding: const EdgeInsets.all(30),
                              child: DischargeTable(
                                  items: _discharges,
                                  onDelete: (it) async {
                                    // reuse existing delete flow
                                    final res =
                                        await APIDischarges.deleteDischarge(
                                            {'id': it.id});
                                    if (res.statusCode == 200) {
                                      await _loadDischarges();
                                    }
                                  }),
                            ),
                            const Divider(),

                            const SizedBox(height: 40),
                            SizedBox(
                              width: double.infinity,
                              height: 40,
                              child: ElevatedButton(
                                  onPressed: _createDaily,
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.teal),
                                  child: const Text(
                                    "حفظ اليومية",
                                    style: TextStyle(
                                        fontSize: 20, color: Colors.white),
                                  )),
                            ),
                            const SizedBox(height: 40),
                          ],
                        ),
                      ),
          ),
        ),
      );
    });
  }
}
