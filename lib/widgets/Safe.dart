import 'dart:convert';
import 'package:ashkerty_food/static/drawer.dart';
import 'package:ashkerty_food/static/formatter.dart';
import 'package:ashkerty_food/static/leadinButton.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ashkerty_food/providers/Auth_provider.dart';
import 'package:ashkerty_food/API/Client.dart' as clientApi;
import 'package:ashkerty_food/API/Safe.dart';
import 'package:ashkerty_food/API/SafeTransfer.dart';
import 'package:ashkerty_food/API/SafeDaily.dart';
import 'package:ashkerty_food/models/SafeTransfer.dart';
import 'package:ashkerty_food/models/SafeDaily.dart';

class SafePage extends StatefulWidget {
  const SafePage({Key? key}) : super(key: key);

  @override
  State<SafePage> createState() => _SafePageState();
}

class _SafePageState extends State<SafePage> {
  // State for SafeTransfer and SafeDaily
  List<SafeTransfer> safeTransfers = [];
  List<SafeDaily> safeDailies = [];
  bool loadingTransfers = false;
  bool loadingDailies = false;
  DateTime startDate = DateTime.now().subtract(const Duration(days: 7));
  DateTime endDate = DateTime.now();

  //safe state
  double bankAmount = 0;
  double cashAmount = 0;
  // double deptAmount = 0;
  double fawryAmount = 0;
  int safeId = 1;
  bool loading = true;
  bool hasSafe = true;

  List clients = [];
  String? selectedClient;
  double transferAmount = 0;
  String from = 'cash_amount';
  String to = 'bank_amount';
  // Search/filter state
  TextEditingController _dailySearchController = TextEditingController();
  TextEditingController _transferSearchController = TextEditingController();
  List<SafeDaily> _filteredDailies = [];
  List<SafeTransfer> _filteredTransfers = [];
  bool _hideDailyAndTransfers = true;

  @override
  void dispose() {
    _dailySearchController.dispose();
    _transferSearchController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _loadSafe();
    _loadClients();
    _loadSafeDaily(startDate, endDate);
    _loadSafeTransfers(startDate, endDate);
    _dailySearchController.addListener(_filterDailies);
    _transferSearchController.addListener(_filterTransfers);
  }

  Future<void> _loadSafe() async {
    setState(() => loading = true);

    final res = await APISafe.getSafe();
    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);
      if (data is List && data.isNotEmpty) {
        setState(() {
          bankAmount = data[0]['bank_amount'] ?? 0;
          cashAmount = data[0]['cash_amount'] ?? 0;
          // deptAmount = data[0]['dept_amount'] ?? 0;
          fawryAmount = data[0]['fawry_amount'] ?? 0;
          safeId = data[0]['id'] ?? 1;
          hasSafe = true;
          loading = false;
        });
      } else {
        setState(() {
          bankAmount = 0;
          cashAmount = 0;
          fawryAmount = 0;
          safeId = 0;
          hasSafe = false;
          loading = false;
        });
      }
    } else {
      setState(() {
        loading = false;
        hasSafe = false;
      });
    }
  }

  void _showCreateSafeModal(String adminId) {
    final cashCtrl = TextEditingController(text: '0');
    final bankCtrl = TextEditingController(text: '0');
    final fawryCtrl = TextEditingController(text: '0');
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (_) => Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          title: const Center(child: Text('إنشاء خزنة')),
          content: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: cashCtrl,
                  decoration: const InputDecoration(labelText: 'الرصيد النقدي'),
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  validator: (v) => double.tryParse(v ?? '') == null
                      ? 'الرجاء إدخال رقم صحيح'
                      : null,
                ),
                TextFormField(
                  controller: bankCtrl,
                  decoration: const InputDecoration(labelText: 'رصيد بنكك'),
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  validator: (v) => double.tryParse(v ?? '') == null
                      ? 'الرجاء إدخال رقم صحيح'
                      : null,
                ),
                TextFormField(
                  controller: fawryCtrl,
                  decoration: const InputDecoration(labelText: 'رصيد فوري'),
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  validator: (v) => double.tryParse(v ?? '') == null
                      ? 'الرجاء إدخال رقم صحيح'
                      : null,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('إلغاء', style: TextStyle(color: Colors.black)),
            ),
            ElevatedButton(
              onPressed: () async {
                if (!formKey.currentState!.validate()) return;
                final data = {
                  'cash_amount': double.tryParse(cashCtrl.text.trim()) ?? 0,
                  'bank_amount': double.tryParse(bankCtrl.text.trim()) ?? 0,
                  'fawry_amount': double.tryParse(fawryCtrl.text.trim()) ?? 0,
                  'admin_id': adminId,
                };
                final res = await APISafe.createSafe(data);
                if (res.statusCode == 200) {
                  Navigator.pop(context);
                  _loadSafe();
                  _showMessage('تم إنشاء الخزنة بنجاح');
                } else {
                  _showMessage('فشل إنشاء الخزنة: ${res.body}');
                }
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
              child: const Text('إنشاء', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _loadSafeTransfers(DateTime startdate, DateTime enddate) async {
    setState(() => loadingTransfers = true);

    final res = await APISafeTransfer.getByDate({
      'startDate': startdate.toIso8601String(),
      'endDate': enddate.toIso8601String(),
    });

    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);

      setState(() {
        safeTransfers =
            List.from(data).map((e) => SafeTransfer.fromJson(e)).toList();
        _filterTransfers();
        loadingTransfers = false;
      });
    } else {
      setState(() => loadingTransfers = false);
    }
  }

  Future<void> _loadSafeDaily(DateTime startdate, DateTime enddate) async {
    setState(() => loadingDailies = true);

    final res = await APISafeDaily.getByDate({
      'startDate': startdate.toIso8601String(),
      'endDate': enddate.toIso8601String(),
    });

    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);

      setState(() {
        safeDailies =
            List.from(data).map((e) => SafeDaily.fromJson(e)).toList();
        _filterDailies();
        loadingDailies = false;
      });
    } else {
      setState(() => loadingDailies = false);
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

  Future _deleteSafeDaily(SafeDaily safeDaily) async {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Center(child: Text('حذف يومية الخزنة')),
        content: Text(
          "سيتم حذف يومية الخزنة بتاريخ ${safeDaily.date.toIso8601String().split('T').first}",
          style: const TextStyle(fontSize: 18),
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
              final res = await APISafeDaily.delete({'id': safeDaily.DailyId});
              if (res.statusCode == 200) {
                _showMessage('تم حذف اليومية بنجاح');
                _loadSafeDaily(startDate, endDate);
                _loadSafe();
              } else {
                _showMessage('فشل حذف اليومية: ${res.body}');
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('حذف', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteSafeTransfer(SafeTransfer safeTransfer) async {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Center(child: Text('حذف يومية الخزنة')),
        content: Text(
          "سيتم حذف التحويلة بتاريخ ${safeTransfer.date.toIso8601String().split('T').first}",
          style: const TextStyle(fontSize: 18),
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
              final res = await APISafeTransfer.delete({'id': safeTransfer.id});
              if (res.statusCode == 200) {
                _showMessage('تم حذف التحويل بنجاح');
                _loadSafeTransfers(startDate, endDate);
                _loadSafe();
              } else {
                _showMessage('فشل حذف التحويل: ${res.body}');
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('حذف', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _filterDailies() {
    final query = _dailySearchController.text.trim();
    setState(() {
      if (query.isEmpty) {
        _filteredDailies = List.from(safeDailies);
      } else {
        _filteredDailies = safeDailies.where((d) {
          return d.date.toIso8601String().contains(query) ||
              d.totalCash.toString().contains(query) ||
              d.totalBank.toString().contains(query) ||
              d.totalDept.toString().contains(query);
        }).toList();
      }
    });
  }

  void _filterTransfers() {
    final query = _transferSearchController.text.trim();
    setState(() {
      if (query.isEmpty) {
        _filteredTransfers = List.from(safeTransfers);
      } else {
        _filteredTransfers = safeTransfers.where((t) {
          return t.from.contains(query) ||
              t.to.contains(query) ||
              t.amount.toString().contains(query) ||
              t.date.toIso8601String().contains(query);
        }).toList();
      }
    });
  }

  void _showTransferModal(String adminId) {
    showDialog(
      context: context,
      builder: (_) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: AlertDialog(
            title: const Center(child: Text('تحويل مبلغ')),
            content: StatefulBuilder(
              builder: (context, setModalState) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    DropdownButtonFormField<String>(
                      initialValue: from,
                      items: const [
                        DropdownMenuItem(
                            value: 'cash_amount', child: Text(' كاش')),
                        DropdownMenuItem(
                            value: 'bank_amount', child: Text('بنكك')),
                        DropdownMenuItem(
                            value: 'fawry_amount', child: Text('فوري')),
                        // DropdownMenuItem(
                        //     value: 'dept_amount', child: Text('رصيد الدين')),
                      ],
                      onChanged: (v) => setModalState(() => from = v!),
                      decoration: const InputDecoration(labelText: 'من'),
                    ),
                    const SizedBox(height: 10),
                    DropdownButtonFormField<String>(
                      initialValue: to,
                      items: const [
                        DropdownMenuItem(
                            value: 'cash_amount', child: Text(' كاش')),
                        DropdownMenuItem(
                            value: 'bank_amount', child: Text('بنكك')),
                        DropdownMenuItem(
                            value: 'fawry_amount', child: Text('فوري')),
                        // DropdownMenuItem(
                        //     value: 'dept_amount', child: Text('رصيد الدين')),
                      ],
                      onChanged: (v) => setModalState(() => to = v!),
                      decoration: const InputDecoration(labelText: 'إلى'),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      decoration: const InputDecoration(
                        labelText: 'المبلغ',
                      ),
                      keyboardType: TextInputType.number,
                      onChanged: (v) => setModalState(
                          () => transferAmount = double.tryParse(v) ?? 0),
                    ),
                    const SizedBox(height: 10),
                    if (from == 'dept_amount' || to == 'dept_amount')
                      DropdownButtonFormField<String>(
                        initialValue: selectedClient,
                        items: clients
                            .map<DropdownMenuItem<String>>(
                                (c) => DropdownMenuItem(
                                      value: c['id'].toString(),
                                      child: Text(c['name']),
                                    ))
                            .toList(),
                        onChanged: (v) =>
                            setModalState(() => selectedClient = v),
                        decoration: const InputDecoration(
                          labelText: 'اختر العميل',
                        ),
                      ),
                    const SizedBox(
                      height: 20,
                    ),
                  ],
                );
              },
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  'إلغاء',
                  style: TextStyle(color: Colors.black),
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  Map<String, dynamic> data = {
                    'id': safeId,
                    'from': from,
                    'to': to,
                    'amount': transferAmount,
                    'client_id': selectedClient,
                    'admin_id': adminId,
                  };
                  //call server
                  final res = await APISafe.transfer(data);
                  if (res.statusCode == 200) {
                    Navigator.pop(context);
                    _loadSafe();
                    _loadSafeTransfers(startDate, endDate);
                    _showMessage('تم تحويل $transferAmount بنجاح');
                  } else {
                    _showMessage('فشل التحويل: ${res.body}');
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('خطأ: ${res.body}')),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                ),
                child: const Text(
                  'تحويل',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showMessage(String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Center(child: Text(' تم ')),
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

  Map transferTranslate = {
    'cash_amount': 'كاش',
    'bank_amount': 'بنكك',
    'fawry_amount': 'فوري',
    'account_amount': 'حساب',
    // 'dept_amount': 'رصيد الدين',
  };

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(builder: (context, value, child) {
      bool isAdmin = value.user['role'] != null &&
          value.user['role'].toString().toLowerCase().contains('admin');
      value.user != null && value.user!['role'] == 'admin';

      if (!isAdmin) {
        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/home');
              },
            ),
            title: const Center(child: Text('الخزنة')),
            backgroundColor: Colors.teal,
          ),
          body: const Center(
            child: Text('انت غير مخول للوصول الى هذه الصفحة',
                style: TextStyle(fontSize: 30, color: Colors.red)),
          ),
        );
      }
      return Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.white,
                size: 30,
              ),
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/home');
              },
            ),
            title: const Center(
                child: Text(
              'الخزنة',
              style: TextStyle(fontSize: 25),
            )),
            backgroundColor: Colors.teal,
            actions: const [LeadingDrawerBtn()],
          ),
          endDrawer: const MyDrawer(),
          body: loading
              ? const Center(child: CircularProgressIndicator())
              : !hasSafe
                  ? Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            'لا توجد خزنة حالياً',
                            style: TextStyle(fontSize: 22),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton.icon(
                            onPressed: () => _showCreateSafeModal(
                                value.user!['id'].toString()),
                            icon: const Icon(Icons.add, color: Colors.white),
                            label: const Text('إنشاء خزنة',
                                style: TextStyle(color: Colors.white)),
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.teal),
                          ),
                        ],
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                _buildCard('الرصيد النقدي', cashAmount,
                                    Colors.green.shade900),
                                _buildCard('رصيد بنكك', bankAmount,
                                    Colors.red.shade800),
                                _buildCard('رصيد فوري', fawryAmount,
                                    Colors.deepPurple.shade800),
                                // _buildCard(
                                //     'رصيد الدين', deptAmount, Colors.blue.shade800),
                              ],
                            ),
                            const SizedBox(height: 40),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Checkbox(
                                  value: _hideDailyAndTransfers,
                                  onChanged: (value) {
                                    setState(() {
                                      _hideDailyAndTransfers = value ?? false;
                                    });
                                  },
                                  activeColor: Colors.teal,
                                ),
                                const Text(
                                  'اخفاء البيانات ',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            // Row with two scrollable ListViews
                            if (!_hideDailyAndTransfers)
                              Column(
                                children: [
                                  ElevatedButton.icon(
                                    onPressed: () => _showTransferModal(
                                        value.user!['id'].toString()),
                                    icon: const Icon(
                                      Icons.compare_arrows,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                    label: const Text(
                                      'تحويل بين الأرصدة',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.teal),
                                  ),
                                  const SizedBox(height: 25),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      // SafeDaily List
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.45,
                                        height: 600,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.grey
                                                    .withOpacity(0.2),
                                                spreadRadius: 1,
                                                blurRadius: 8,
                                                offset: const Offset(0, 2),
                                              ),
                                            ],
                                          ),
                                          child: Column(
                                            children: [
                                              const Padding(
                                                padding: EdgeInsets.all(8.0),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text('اليوميات',
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 22)),
                                                    SizedBox(width: 10),
                                                    Icon(Icons.badge,
                                                        color: Colors.teal,
                                                        size: 28)
                                                  ],
                                                ),
                                              ),
                                              Row(
                                                children: [
                                                  Expanded(
                                                    child: Padding(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 12.0,
                                                          vertical: 4.0),
                                                      child: TextField(
                                                        controller:
                                                            _dailySearchController,
                                                        decoration:
                                                            InputDecoration(
                                                          hintText:
                                                              'بحث في اليوميات...',
                                                          prefixIcon:
                                                              const Icon(
                                                                  Icons.search),
                                                          border: OutlineInputBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          8)),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 100,
                                                    child: PopupMenuButton(
                                                      icon: const Icon(
                                                        Icons
                                                            .date_range_rounded,
                                                        size: 36,
                                                        color: Colors.teal,
                                                      ),
                                                      tooltip: "تصفية",
                                                      onSelected: (value) {},
                                                      itemBuilder: (BuildContext
                                                          context) {
                                                        startDate =
                                                            DateTime.now();

                                                        return [
                                                          PopupMenuItem(
                                                            value: 'week',
                                                            onTap: () {
                                                              // Get the date of a week before the current date
                                                              DateTime
                                                                  weekBeforeDate =
                                                                  startDate.subtract(
                                                                      const Duration(
                                                                          days:
                                                                              7));

                                                              //call server
                                                              _loadSafeDaily(
                                                                  weekBeforeDate,
                                                                  startDate);
                                                            },
                                                            child: const Text(
                                                              'الإسبوع',
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .black),
                                                            ),
                                                          ),
                                                          PopupMenuItem(
                                                              value: 'month',
                                                              onTap: () {
                                                                // Get the date of a week before the current date
                                                                DateTime
                                                                    monthBeforeDate =
                                                                    startDate.subtract(
                                                                        const Duration(
                                                                            days:
                                                                                30));
                                                                //call server
                                                                _loadSafeDaily(
                                                                    monthBeforeDate,
                                                                    startDate);
                                                              },
                                                              child: const Text(
                                                                'الشهر',
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .black),
                                                              )),
                                                          PopupMenuItem(
                                                              value: 'day',
                                                              onTap: () =>
                                                                  _loadSafeDaily(
                                                                      startDate,
                                                                      startDate),
                                                              child: const Text(
                                                                'اليوم',
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .black),
                                                              )),
                                                          PopupMenuItem(
                                                            value: 'search_day',
                                                            child: Form(
                                                                child: Row(
                                                              children: [
                                                                ElevatedButton(
                                                                  onPressed:
                                                                      () async {
                                                                    final d = await showDatePicker(
                                                                        context:
                                                                            context,
                                                                        initialDate:
                                                                            DateTime
                                                                                .now(),
                                                                        firstDate:
                                                                            DateTime(
                                                                                2000),
                                                                        lastDate:
                                                                            DateTime(2100));
                                                                    if (d !=
                                                                        null) {
                                                                      //call server
                                                                      _loadSafeDaily(
                                                                          d, d);
                                                                    }
                                                                    Navigator.pop(
                                                                        context);
                                                                  },
                                                                  child:
                                                                      const Text(
                                                                    'تحديد يوم',
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .black),
                                                                  ),
                                                                ),
                                                              ],
                                                            )),
                                                          ),
                                                        ];
                                                      },
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 8),
                                              Expanded(
                                                child: loadingDailies
                                                    ? const Center(
                                                        child:
                                                            CircularProgressIndicator())
                                                    : _filteredDailies
                                                            .isNotEmpty
                                                        ? ListView.separated(
                                                            itemCount:
                                                                _filteredDailies
                                                                    .length,
                                                            separatorBuilder: (ctx,
                                                                    i) =>
                                                                const SizedBox(
                                                                    height: 15),
                                                            itemBuilder:
                                                                (ctx, i) {
                                                              final d =
                                                                  _filteredDailies[
                                                                      i];
                                                              return Card(
                                                                elevation: 2,
                                                                shape: RoundedRectangleBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            10)),
                                                                margin: const EdgeInsets
                                                                    .symmetric(
                                                                    horizontal:
                                                                        8,
                                                                    vertical:
                                                                        2),
                                                                child: Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .all(
                                                                          12.0),
                                                                  child:
                                                                      ListTile(
                                                                    contentPadding:
                                                                        EdgeInsets
                                                                            .zero,
                                                                    title: Text(
                                                                        'تاريخ: ${d.date.toIso8601String().split('T').first}',
                                                                        style: const TextStyle(
                                                                            fontWeight:
                                                                                FontWeight.bold,
                                                                            fontSize: 18)),
                                                                    subtitle:
                                                                        Padding(
                                                                      padding: const EdgeInsets
                                                                          .all(
                                                                          8.0),
                                                                      child:
                                                                          Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.spaceEvenly,
                                                                        children: [
                                                                          Text(
                                                                            '(كاش: ${numberFormatter(d.totalCash)})',
                                                                            style:
                                                                                const TextStyle(
                                                                              fontSize: 17,
                                                                              fontWeight: FontWeight.bold,
                                                                            ),
                                                                          ),
                                                                          Text(
                                                                            '(بنكك: ${numberFormatter(d.totalBank)})',
                                                                            style:
                                                                                const TextStyle(
                                                                              fontSize: 17,
                                                                              fontWeight: FontWeight.bold,
                                                                            ),
                                                                          ),
                                                                          Text(
                                                                            '(فوري: ${numberFormatter(d.totalFawry)})',
                                                                            style: const TextStyle(
                                                                                fontSize: 17,
                                                                                fontWeight: FontWeight.bold,
                                                                                color: Colors.black),
                                                                          ),
                                                                          // Text(
                                                                          //   '(دين: ${numberFormatter(d.totalDept)})',
                                                                          //   style: const TextStyle(
                                                                          //       fontSize:
                                                                          //           17,
                                                                          //       fontWeight:
                                                                          //           FontWeight
                                                                          //               .bold,
                                                                          //       color: Colors
                                                                          //           .black),
                                                                          // ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                    trailing: isAdmin
                                                                        ? IconButton(
                                                                            icon:
                                                                                const Icon(Icons.delete, color: Colors.red),
                                                                            onPressed: () => isAdmin
                                                                                ? _deleteSafeDaily(d)
                                                                                : null,
                                                                          )
                                                                        : null,
                                                                  ),
                                                                ),
                                                              );
                                                            },
                                                          )
                                                        : const Center(
                                                            child: Text(
                                                              'لا توجد خزنة يوميات ',
                                                              style: TextStyle(
                                                                  fontSize: 18,
                                                                  color: Colors
                                                                      .grey),
                                                            ),
                                                          ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      // SafeTransfer List
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.45,
                                        height: 600,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.grey
                                                    .withOpacity(0.2),
                                                spreadRadius: 1,
                                                blurRadius: 8,
                                                offset: const Offset(0, 2),
                                              ),
                                            ],
                                          ),
                                          child: Column(
                                            children: [
                                              const Padding(
                                                padding: EdgeInsets.all(8.0),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text('التحويلات',
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 22)),
                                                    SizedBox(width: 10),
                                                    Icon(
                                                        Icons
                                                            .compare_arrows_rounded,
                                                        color: Colors.teal,
                                                        size: 28)
                                                  ],
                                                ),
                                              ),
                                              Row(
                                                children: [
                                                  Expanded(
                                                    child: Padding(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 12.0,
                                                          vertical: 4.0),
                                                      child: TextField(
                                                        controller:
                                                            _transferSearchController,
                                                        decoration:
                                                            InputDecoration(
                                                          hintText:
                                                              'بحث في التحويلات باليوم...',
                                                          prefixIcon: Icon(
                                                              Icons.search),
                                                          border: OutlineInputBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          8)),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 100,
                                                    child: PopupMenuButton(
                                                      icon: const Icon(
                                                        Icons
                                                            .date_range_rounded,
                                                        size: 36,
                                                        color: Colors.teal,
                                                      ),
                                                      tooltip: "تصفية",
                                                      onSelected: (value) {},
                                                      itemBuilder: (BuildContext
                                                          context) {
                                                        startDate =
                                                            DateTime.now();

                                                        return [
                                                          PopupMenuItem(
                                                            value: 'week',
                                                            onTap: () {
                                                              // Get the date of a week before the current date
                                                              DateTime
                                                                  weekBeforeDate =
                                                                  startDate.subtract(
                                                                      const Duration(
                                                                          days:
                                                                              7));

                                                              //call server
                                                              _loadSafeTransfers(
                                                                  weekBeforeDate,
                                                                  startDate);
                                                            },
                                                            child: const Text(
                                                              'الإسبوع',
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .black),
                                                            ),
                                                          ),
                                                          PopupMenuItem(
                                                              value: 'month',
                                                              onTap: () {
                                                                // Get the date of a week before the current date
                                                                DateTime
                                                                    monthBeforeDate =
                                                                    startDate.subtract(
                                                                        const Duration(
                                                                            days:
                                                                                30));
                                                                //call server
                                                                _loadSafeTransfers(
                                                                    monthBeforeDate,
                                                                    startDate);
                                                              },
                                                              child: const Text(
                                                                'الشهر',
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .black),
                                                              )),
                                                          PopupMenuItem(
                                                              value: 'day',
                                                              onTap: () =>
                                                                  _loadSafeTransfers(
                                                                      startDate,
                                                                      startDate),
                                                              child: const Text(
                                                                'اليوم',
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .black),
                                                              )),
                                                          PopupMenuItem(
                                                            value: 'search_day',
                                                            child: Form(
                                                                child: Row(
                                                              children: [
                                                                ElevatedButton(
                                                                  onPressed:
                                                                      () async {
                                                                    final d = await showDatePicker(
                                                                        context:
                                                                            context,
                                                                        initialDate:
                                                                            DateTime
                                                                                .now(),
                                                                        firstDate:
                                                                            DateTime(
                                                                                2000),
                                                                        lastDate:
                                                                            DateTime(2100));
                                                                    if (d !=
                                                                        null) {
                                                                      //call server
                                                                      _loadSafeTransfers(
                                                                          d, d);
                                                                    }
                                                                    Navigator.pop(
                                                                        context);
                                                                  },
                                                                  child:
                                                                      const Text(
                                                                    'تحديد يوم',
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .black),
                                                                  ),
                                                                ),
                                                              ],
                                                            )),
                                                          ),
                                                        ];
                                                      },
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 8),
                                              Expanded(
                                                child: loadingTransfers
                                                    ? const Center(
                                                        child:
                                                            CircularProgressIndicator())
                                                    : _filteredTransfers
                                                            .isNotEmpty
                                                        ? ListView.separated(
                                                            itemCount:
                                                                _filteredTransfers
                                                                    .length,
                                                            separatorBuilder: (ctx,
                                                                    i) =>
                                                                const SizedBox(
                                                                    height: 15),
                                                            itemBuilder:
                                                                (ctx, i) {
                                                              final t =
                                                                  _filteredTransfers[
                                                                      i];
                                                              return Card(
                                                                elevation: 2,
                                                                shape: RoundedRectangleBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            10)),
                                                                margin: const EdgeInsets
                                                                    .symmetric(
                                                                    horizontal:
                                                                        8,
                                                                    vertical:
                                                                        2),
                                                                child: Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .all(
                                                                          12.0),
                                                                  child:
                                                                      ListTile(
                                                                    contentPadding:
                                                                        EdgeInsets
                                                                            .zero,
                                                                    title:
                                                                        Padding(
                                                                      padding: const EdgeInsets
                                                                          .all(
                                                                          8.0),
                                                                      child:
                                                                          Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.spaceBetween,
                                                                        children: [
                                                                          Text(
                                                                            'التاريخ: ${t.date.toIso8601String().split('T').first}',
                                                                            style:
                                                                                const TextStyle(fontSize: 18),
                                                                          ),
                                                                          Text(
                                                                            'المبلغ: ${numberFormatter(t.amount)}',
                                                                            style:
                                                                                const TextStyle(fontSize: 18),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                    subtitle:
                                                                        Center(
                                                                      child: Text(
                                                                          'من: ${transferTranslate[t.from]}  إلى: ${transferTranslate[t.to]}',
                                                                          style: const TextStyle(
                                                                              fontSize: 17,
                                                                              fontWeight: FontWeight.bold)),
                                                                    ),
                                                                    trailing:
                                                                        IconButton(
                                                                      icon: const Icon(
                                                                          Icons
                                                                              .delete,
                                                                          color:
                                                                              Colors.red),
                                                                      onPressed:
                                                                          () =>
                                                                              _deleteSafeTransfer(t),
                                                                    ),
                                                                  ),
                                                                ),
                                                              );
                                                            },
                                                          )
                                                        : const Center(
                                                            child: Text(
                                                              'لا توجد تحويلات ',
                                                              style: TextStyle(
                                                                  fontSize: 18,
                                                                  color: Colors
                                                                      .grey),
                                                            ),
                                                          ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
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

  Widget _buildCard(String title, double amount, Color color) {
    return Card(
      elevation: 2,
      color: color.withOpacity(0.1),
      child: Container(
        width: 300,
        height: 150,
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(title,
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Text(numberFormatter(amount),
                style: TextStyle(fontSize: 28, color: color)),
          ],
        ),
      ),
    );
  }
}
