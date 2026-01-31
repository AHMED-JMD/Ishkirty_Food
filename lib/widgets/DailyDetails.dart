import 'dart:convert';
import 'package:ashkerty_food/API/Daily.dart';
import 'package:ashkerty_food/API/Discharges.dart';
import 'package:ashkerty_food/API/Employee.dart' as emp_api;
import 'package:ashkerty_food/API/Store.dart' as api;
import 'package:ashkerty_food/Components/tables/DischargeTable.dart';
import 'package:ashkerty_food/Components/tables/EmployeeTransTable.dart';
import 'package:ashkerty_food/Components/tables/PurchaseTable.dart';
import 'package:ashkerty_food/models/Employee.dart';
import 'package:ashkerty_food/models/StockItem.dart';
import 'package:ashkerty_food/providers/Auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:ashkerty_food/models/Daily.dart';
import 'package:ashkerty_food/models/Discharge.dart';
import 'package:ashkerty_food/models/PurchaseRequest.dart';
import 'package:ashkerty_food/models/EmpTrans.dart';
import 'package:ashkerty_food/static/drawer.dart';
import 'package:ashkerty_food/static/leadinButton.dart';
import 'package:ashkerty_food/static/formatter.dart';
import 'package:provider/provider.dart';
import '../static/SalesCard.dart';
import 'package:ashkerty_food/API/Sales.dart' as sales_api;

class DailyDetailsPage extends StatefulWidget {
  final Daily daily;
  final List<Discharge> discharges;
  final List<PurchaseRequest> purchases;
  final List<EmpTransaction> empTrans;
  const DailyDetailsPage({
    Key? key,
    required this.daily,
    required this.discharges,
    required this.purchases,
    required this.empTrans,
  }) : super(key: key);

  @override
  State<DailyDetailsPage> createState() => _DailyDetailsPageState();
}

class _DailyDetailsPageState extends State<DailyDetailsPage> {
  List<Discharge> _discharges = [];
  List<PurchaseRequest> _purchases = [];
  List<EmpTransaction> _empTrans = [];
  List<Employee> _employees = [];
  List<StockItem> _stores = [];

  bool _loading = true;
  int totalCash = 0;
  int totalBank = 0;
  int totalAccount = 0;
  double totalSalesCosts = 0;
  String period = 'اليوم';

  //total employee Trans value by payment method
  double get totalEmpTransCash => _empTrans
      .where((e) => e.paymentMethod == 'كاش')
      .fold(0.0, (p, e) => p + e.amount);
  double get totalEmpTransBankak => _empTrans
      .where((e) => e.paymentMethod == 'بنكك')
      .fold(0.0, (p, e) => p + e.amount);
  double get totalEmpTransAccount => _empTrans
      .where((e) => e.paymentMethod == 'حساب')
      .fold(0.0, (p, e) => p + e.amount);

  //total purchases value by payment method
  double get totalPurchaseCash => _purchases
      .where((e) => e.paymentMethod == 'كاش')
      .fold(0.0, (p, e) => p + e.buyPrice * e.quantity);
  double get totalPurchaseBankak => _purchases
      .where((e) => e.paymentMethod == 'بنكك')
      .fold(0.0, (p, e) => p + e.buyPrice * e.quantity);
  double get totalPurchaseAccount => _purchases
      .where((e) => e.paymentMethod == 'حساب')
      .fold(0.0, (p, e) => p + e.buyPrice * e.quantity);

  //total Discharges value by payment method
  double get totalDischargesCash => _discharges
      .where((e) => e.paymentMethod == 'كاش')
      .fold(0.0, (p, e) => p + e.price);
  double get totalDischargesBankak => _discharges
      .where((e) => e.paymentMethod == 'بنكك')
      .fold(0.0, (p, e) => p + e.price);
  double get totalDischargesAccount => _discharges
      .where((e) => e.paymentMethod == 'حساب')
      .fold(0.0, (p, e) => p + e.price);

  @override
  void initState() {
    super.initState();
    _loadSales();
    _loadSalesCosts();
    _loadEmpTrans();
    _loadEmployees();
    _loadPurchases();
    _loadStores();
    _loadDischarges();
  }

  //GET API'S
  Future _loadSales() async {
    setState(() {
      _loading = true;
    });
    Map datas = {};
    datas['start_date'] = widget.daily.date.toIso8601String();
    datas['end_date'] = widget.daily.date.toIso8601String();

    final response = await sales_api.APISales.TodaySales(datas);
    if (response.statusCode == 200) {
      final res = jsonDecode(response.body);
      print(res);
      setState(() {
        _loading = false;
        totalCash = res["totalCash"].toInt();
        totalBank = res["totalBank"].toInt();
        totalAccount = res["totalAccount"].toInt();
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
    final res = await sales_api.APISales.todayCosts({
      'startDate': widget.daily.date.toIso8601String(),
      'endDate': widget.daily.date.toIso8601String()
    });
    if (res.statusCode == 200) {
      final body = jsonDecode(res.body);
      setState(() {
        totalSalesCosts = body['totalCosts'];
      });
    }
    setState(() => _loading = false);
  }

  Future _loadDischarges() async {
    setState(() => _loading = true);
    // load today's purchases as sample
    final res = await APIDischarges.getByDate({
      'startDate': widget.daily.date.toIso8601String(),
      'endDate': widget.daily.date.toIso8601String()
    });
    if (res.statusCode == 200) {
      final body = jsonDecode(res.body);
      List data = List.from(body);
      _discharges = data.map((e) => Discharge.fromJson(e)).toList();
    }

    setState(() => _loading = false);
  }

  Future _loadPurchases() async {
    setState(() => _loading = true);
    // load today's purchases as sample
    final res = await api.APIStore.getPurchasesByDate({
      'startDate': widget.daily.date.toIso8601String(),
      'endDate': widget.daily.date.toIso8601String()
    });
    if (res.statusCode == 200) {
      final body = jsonDecode(res.body);
      List data = List.from(body);
      _purchases = data.map((e) => PurchaseRequest.fromJson(e)).toList();
    }

    setState(() => _loading = false);
  }

  Future _loadStores() async {
    final res = await api.APIStore.getItems("تصنيع");
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

    final res = await emp_api.APIEmployee.getTransByDate({
      'startDate': widget.daily.date.toIso8601String(),
      'endDate': widget.daily.date.toIso8601String()
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

    double totalCosts = totalSalesCosts;
    double totalCashCosts =
        totalDischargesCash + totalPurchaseCash + totalEmpTransCash;
    double totalBankCosts =
        totalDischargesBankak + totalPurchaseBankak + totalEmpTransBankak;
    double totalAccountCosts =
        totalDischargesAccount + totalPurchaseAccount + totalEmpTransAccount;

    final res = await APIDaily.addDaily({
      'date': widget.daily.date.toIso8601String(),
      'cash_sales': totalCash,
      'bank_sales': totalBank,
      'account_sales': totalAccount,
      'today_costs': totalCosts,
      'cash_costs': totalCashCosts,
      'bank_costs': totalBankCosts,
      'account_costs': totalAccountCosts,
    });
    if (res.statusCode == 200) {
      _showMessage(res.body);
      _loadDischarges();
      _loadPurchases();
      _loadEmpTrans();
    }
    _showMessage(res.body);
    setState(() => _loading = false);
  }

  //modals for editing
  void _showAddPurchaseDialog() async {
    final vendorCtrl = TextEditingController(text: "عام");
    final qtyCtrl = TextEditingController();
    final netqtyCtrl = TextEditingController();
    final storeCtrl = TextEditingController();
    DateTime pickedDate = widget.daily.date;
    final formKey = GlobalKey<FormState>();

    await showDialog(
        context: context,
        builder: (ctx) {
          String paymentMethod = 'كاش';

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
                        initialValue: paymentMethod,
                        items: const [
                          DropdownMenuItem(value: 'كاش', child: Text('كاش')),
                          DropdownMenuItem(value: 'بنكك', child: Text('بنكك')),
                        ],
                        onChanged: (v) =>
                            setState(() => paymentMethod = v ?? 'كاش'),
                        decoration:
                            const InputDecoration(labelText: 'طريقة الدفع'),
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
                      TextFormField(
                        controller: netqtyCtrl,
                        decoration:
                            const InputDecoration(labelText: 'صافي الكمية'),
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
                    'net_quantity': double.parse(netqtyCtrl.text.trim()),
                    'payment_method': paymentMethod,
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
    DateTime pickedDate = widget.daily.date;
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
                        'paymentMethod': paymentMethod,
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

  void _showAddEmpTrans(String adminId) async {
    final amountCtrl = TextEditingController();
    Employee? selected = _employees.isNotEmpty ? _employees.first : null;
    String type = 'خصم';
    DateTime date = widget.daily.date;

    await showDialog(
        context: context,
        builder: (ctx) {
          String paymentMethod = 'كاش';

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
                    DropdownButtonFormField<String>(
                      initialValue: paymentMethod,
                      items: const [
                        DropdownMenuItem(value: 'كاش', child: Text('كاش')),
                        DropdownMenuItem(value: 'بنكك', child: Text('بنكك')),
                      ],
                      onChanged: (v) => paymentMethod = v ?? 'كاش',
                      decoration:
                          const InputDecoration(labelText: 'طريقة الدفع'),
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
                      'date': date.toIso8601String(),
                      'paymentMethod': paymentMethod,
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
    double totalCosts = totalSalesCosts +
        (totalEmpTransCash + totalEmpTransBankak + totalEmpTransAccount) +
        (totalDischargesCash + totalDischargesBankak + totalDischargesAccount) +
        (totalPurchaseCash + totalPurchaseBankak + totalPurchaseAccount);

    double totalSales =
        totalCash.toDouble() + totalBank.toDouble() + totalAccount.toDouble();

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
            title: const Center(child: Text('تفاصيل اليومية')),
            actions: const [LeadingDrawerBtn()],
            toolbarHeight: 45,
          ),
          endDrawer: const MyDrawer(),
          body: Padding(
            padding: const EdgeInsets.all(24.0),
            child: _loading
                ? const Center(child: CircularProgressIndicator())
                : SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Container(
                          color: Colors.grey.shade100,
                          padding: const EdgeInsets.all(10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "  قيمة اليومية :  (${numberFormatter(totalSales - totalCosts)})",
                                style: const TextStyle(
                                    fontSize: 26, fontWeight: FontWeight.bold),
                              ),
                              const Icon(Icons.monetization_on)
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 60,
                        ),
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
                                  "${numberFormatter(totalSales)} / (جنيه) ",
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
                                    period: 'مبيعات الوردية',
                                    cashAmount: totalCash,
                                    bankakAmount: totalBank,
                                    accountsAmount: totalAccount,
                                  ),
                                ),
                                const SizedBox(width: 30),
                                // Container(
                                //   width: 330,
                                //   decoration: BoxDecoration(
                                //     color: const Color(0xffefecec),
                                //     border: Border.all(
                                //       width: 2,
                                //     ),
                                //     borderRadius: BorderRadius.circular(12),
                                //   ),
                                //   child: SalesCard(
                                //     period: 'الوردية المسائية',
                                //     cashAmount: totalCash,
                                //     bankakAmount: totalBank,
                                //     accountsAmount: totalAccount,
                                //   ),
                                // ),
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
                                    fontSize: 25, fontWeight: FontWeight.bold)),
                            const SizedBox(width: 10),
                            ElevatedButton.icon(
                              onPressed: () {
                                _showAddEmpTrans('adminId');
                              },
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
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Row(
                              children: [
                                const Text(
                                  ' المرتبات كاش : ',
                                  style: TextStyle(fontSize: 20),
                                ),
                                Text(
                                  "${numberFormatter(totalEmpTransCash)} / (جنيه) ",
                                  style: const TextStyle(fontSize: 20),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                const Text(
                                  ' المرتبات بنكك : ',
                                  style: TextStyle(
                                      fontSize: 20, color: Colors.redAccent),
                                ),
                                Text(
                                  "${numberFormatter(totalEmpTransBankak)} / (جنيه) ",
                                  style: const TextStyle(fontSize: 20),
                                ),
                              ],
                            ),
                          ],
                        ),

                        Container(
                          padding: const EdgeInsets.all(30),
                          child: EmployeeTranTable(
                              admin: value.user,
                              transactions: _empTrans,
                              confirmDelete: (it, adminId) async {
                                // reuse existing delete flow
                                final res =
                                    await emp_api.APIEmployee.deleteTrans(
                                        {'id': it.id, 'admin_id': adminId});
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
                                    fontSize: 25, fontWeight: FontWeight.bold)),
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
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Row(
                              children: [
                                const Text(
                                  ' المشتريات كاش : ',
                                  style: TextStyle(fontSize: 20),
                                ),
                                Text(
                                  "${numberFormatter(totalPurchaseCash)} / (جنيه) ",
                                  style: const TextStyle(fontSize: 20),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                const Text(
                                  ' المشتريات بنكك : ',
                                  style: TextStyle(
                                      fontSize: 20, color: Colors.redAccent),
                                ),
                                Text(
                                  "${numberFormatter(totalPurchaseBankak)} / (جنيه) ",
                                  style: const TextStyle(fontSize: 20),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.all(30),
                          child: PurchaseTable(
                              items: _purchases,
                              onDelete: (it) async {
                                // reuse existing delete flow
                                final res = await api.APIStore.deletePurchase(
                                    {'id': it.id});
                                if (res.statusCode == 200) {
                                  await _loadPurchases();
                                }
                              }),
                        ),
                        const Divider(),
                        const SizedBox(
                          height: 80,
                        ),

                        // Section 3: deductions
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text('المنصرفات',
                                style: TextStyle(
                                    fontSize: 25, fontWeight: FontWeight.bold)),
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
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Row(
                              children: [
                                const Text(
                                  ' المنصرفات كاش : ',
                                  style: TextStyle(fontSize: 20),
                                ),
                                Text(
                                  "${numberFormatter(totalDischargesCash)} / (جنيه) ",
                                  style: const TextStyle(fontSize: 20),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                const Text(
                                  ' المنصرفات بنكك : ',
                                  style: TextStyle(
                                      fontSize: 20, color: Colors.redAccent),
                                ),
                                Text(
                                  "${numberFormatter(totalDischargesBankak)} / (جنيه) ",
                                  style: const TextStyle(fontSize: 20),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.all(30),
                          child: DischargeTable(
                              admin: value.user,
                              items: _discharges,
                              onDelete: (it, adminId) async {
                                // reuse existing delete flow
                                final res = await APIDischarges.deleteDischarge(
                                    {'id': it.id, 'admin_id': adminId});
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
