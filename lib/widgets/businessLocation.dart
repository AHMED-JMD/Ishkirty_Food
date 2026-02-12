import 'dart:convert';

import 'package:ashkerty_food/API/BusinessLocation.dart';
import 'package:ashkerty_food/API/Daily.dart';
import 'package:ashkerty_food/Components/tables/LocationsDailyTable.dart';
import 'package:ashkerty_food/models/BusinessLocation.dart';
import 'package:ashkerty_food/models/Daily.dart';
import 'package:ashkerty_food/providers/Auth_provider.dart';
import 'package:ashkerty_food/static/drawer.dart';
import 'package:ashkerty_food/static/leadinButton.dart';
import 'package:ashkerty_food/utils/businessLocation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BusinessLocationPage extends StatefulWidget {
  const BusinessLocationPage({Key? key}) : super(key: key);

  @override
  State<BusinessLocationPage> createState() => _BusinessLocationPageState();
}

class _BusinessLocationPageState extends State<BusinessLocationPage> {
  List<BusinessLocation> locations = [];
  List<Daily> allDailies = [];
  final TextEditingController _newController = TextEditingController();
  bool loading = false;
  bool allDailiesLoading = false;
  DateTime? _startDate;
  DateTime? _endDate;

  @override
  void dispose() {
    _newController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _fetchLocations();
    //get todays daily for all locations
    _fetchAllDailies(
        DateTime.now().subtract(const Duration(days: 7)), DateTime.now());
  }

  Future<void> _pickStartDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _startDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() => _startDate = picked);
    }
  }

  Future<void> _pickEndDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _endDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() => _endDate = picked);
    }
  }

  //server get locations and update state
  Future<void> _fetchLocations() async {
    setState(() => loading = true);
    try {
      final res = await APIBusinessLocation.getAll();
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        setState(() {
          locations =
              List.from(data).map((e) => BusinessLocation.fromJson(e)).toList();
        });
      }
    } catch (e) {
      _showMessage('خطأ', e.toString());
    } finally {
      setState(() => loading = false);
    }
  }

  Future<List<Daily>> _loadDailiesFor(String location,
      {DateTime? start, DateTime? end}) async {
    final prev = AuthContext.businessLocation;
    AuthContext.businessLocation = location;
    try {
      final body = <String, dynamic>{};
      if (start != null && end != null) {
        body['startDate'] = start.toIso8601String();
        body['endDate'] = end.toIso8601String();
      }

      final res = await APIDaily.getByDate(body);
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        final list = List.from(data).map((e) => Daily.fromJson(e)).toList();
        return list;
      }
    } catch (e) {
    } finally {
      AuthContext.businessLocation = prev;
    }
    return [];
  }

  Future<void> _fetchAllDailies(DateTime startDate, DateTime endDate) async {
    setState(() => allDailiesLoading = true);
    try {
      final res = await APIDaily.getLocsDailies({
        "startDate": startDate.toIso8601String(),
        "endDate": endDate.toIso8601String(),
      });
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        setState(() {
          allDailies = List.from(data).map((e) => Daily.fromJson(e)).toList();
        });
      }
    } catch (e) {
      _showMessage('خطأ', e.toString());
    } finally {
      setState(() => allDailiesLoading = false);
    }
  }

  Future<void> _addLocation(name, description) async {
    setState(() {
      loading = true;
    });

    //call server
    try {
      final res = await APIBusinessLocation.addLocation({
        'name': name,
        'description': description,
      });
      if (res.statusCode == 200) {
        _newController.clear();
        _fetchLocations();
      }
    } catch (e) {
    } finally {
      setState(() {
        loading = false;
      });
    }
  }

  void _openAddLocationModal() {
    final nameController = TextEditingController();
    final descController = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Center(child: Text('إضافة موقع جديد')),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'اسم الموقع',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: descController,
              decoration: const InputDecoration(
                labelText: 'الوصف',
                border: OutlineInputBorder(),
              ),
              maxLines: 2,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              final name = nameController.text.trim();
              final desc = descController.text.trim();
              if (name.isEmpty) {
                _showMessage('خطأ', 'اسم الموقع مطلوب');
                return;
              }
              Navigator.of(ctx).pop();
              _addLocation(name, desc);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
            child: const Text(
              'إضافة',
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  void _deleteLocation(String locName) {
    setState(() {
      loading = true;
    });

    //call server
    try {
      APIBusinessLocation.deleteLocation({'name': locName}).then((res) {
        if (res.statusCode == 200) {
          _fetchLocations();
        }
      });
    } catch (e) {
      _showMessage('خطأ', e.toString());
    } finally {
      setState(() {
        loading = false;
      });
    }
  }

  void _confirmDeleteLocation(String locName) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        titlePadding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
        actionsPadding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
        title: const Text('تأكيد الحذف'),
        content: Text('هل تريد حذف موقع "$locName"؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              _deleteLocation(locName);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('حذف', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showMessage(String title, String msg) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Center(child: Text(title)),
        content: Text(
          msg,
          style: const TextStyle(
            fontSize: 16,
          ),
          textDirection: TextDirection.rtl,
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context), child: const Text('OK'))
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(builder: (context, auth, child) {
      final role = auth.user != null && auth.user['role'] != null
          ? auth.user['role'].toString().toLowerCase()
          : '';
      final isSuper = role.contains('super');

      return Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          appBar: AppBar(
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
            title: const Center(child: Text('إدارة المواقع')),
            backgroundColor: Colors.teal,
            actions: const [LeadingDrawerBtn()],
          ),
          endDrawer: isSuper ? const MyDrawer() : null,
          body: Padding(
            padding: const EdgeInsets.all(20.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  if (isSuper) ...[
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.teal.shade50,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.teal.shade100),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.location_on, color: Colors.teal),
                          const SizedBox(width: 8),
                          const Text(
                            'تغيير الموقع الحالي',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              initialValue: AuthContext.businessLocation,
                              decoration: InputDecoration(
                                isDense: true,
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 10),
                                filled: true,
                                fillColor: Colors.white,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              items: locations
                                  .map((l) => DropdownMenuItem(
                                        value: l.name,
                                        child: Text(l.name),
                                      ))
                                  .toList(),
                              onChanged: (v) {
                                if (v == null) return;
                                AuthContext.businessLocation = v;
                                _showMessage('تغيير الموقع',
                                    'تم تغيير الموقع بنجاح \n  الموقع الحالي: $v');
                                setState(() {});
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton.icon(
                        onPressed: _openAddLocationModal,
                        icon: const Icon(Icons.add, color: Colors.white),
                        label: const Text('إضافة موقع جديد',
                            style:
                                TextStyle(fontSize: 16, color: Colors.white)),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.teal),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    height: 200,
                    child: loading
                        ? const Center(child: CircularProgressIndicator())
                        : ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: locations.length,
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            itemBuilder: (ctx, i) {
                              final loc = locations[i];
                              final isCurrent =
                                  AuthContext.businessLocation == loc.name;
                              return Container(
                                width: 320,
                                height: 400,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 6),
                                child: Card(
                                  elevation: 4,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12)),
                                  child: Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                loc.name,
                                                style: const TextStyle(
                                                    fontSize: 18,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              const SizedBox(height: 6),
                                              Text(
                                                loc.description.isEmpty
                                                    ? 'لا وصف'
                                                    : loc.description,
                                                maxLines: 3,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              const SizedBox(height: 8),
                                              if (isCurrent)
                                                Container(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 8,
                                                      vertical: 4),
                                                  decoration: BoxDecoration(
                                                      color:
                                                          Colors.green.shade100,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8)),
                                                  child: const Text(
                                                      'الموقع الحالي',
                                                      style: TextStyle(
                                                          color: Colors.green)),
                                                )
                                            ],
                                          ),
                                        ),
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            IconButton(
                                              icon: const Icon(Icons.visibility,
                                                  color: Colors.teal),
                                              onPressed: () async {
                                                DateTime? start;
                                                DateTime? end;
                                                showModalBottomSheet(
                                                    context: context,
                                                    isScrollControlled: true,
                                                    builder: (ctx) {
                                                      List<Daily> viewData = [];
                                                      bool vloading = false;
                                                      return StatefulBuilder(
                                                          builder:
                                                              (ctx2, setSt) {
                                                        return Padding(
                                                          padding:
                                                              MediaQuery.of(
                                                                      ctx2)
                                                                  .viewInsets,
                                                          child: SizedBox(
                                                            height: MediaQuery
                                                                        .of(ctx2)
                                                                    .size
                                                                    .height *
                                                                0.8,
                                                            child: Column(
                                                              children: [
                                                                Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .all(
                                                                          12.0),
                                                                  child: Row(
                                                                    children: [
                                                                      Expanded(
                                                                        child:
                                                                            InkWell(
                                                                          onTap:
                                                                              () async {
                                                                            final picked = await showDatePicker(
                                                                                context: ctx2,
                                                                                initialDate: DateTime.now(),
                                                                                firstDate: DateTime(2000),
                                                                                lastDate: DateTime(2100));
                                                                            if (picked !=
                                                                                null) {
                                                                              setSt(() => start = picked);
                                                                            }
                                                                          },
                                                                          child:
                                                                              InputDecorator(
                                                                            decoration:
                                                                                const InputDecoration(border: OutlineInputBorder(), labelText: 'من تاريخ'),
                                                                            child: Text(start == null
                                                                                ? 'اختر'
                                                                                : start!.toIso8601String().split('T').first),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      const SizedBox(
                                                                          width:
                                                                              8),
                                                                      Expanded(
                                                                        child:
                                                                            InkWell(
                                                                          onTap:
                                                                              () async {
                                                                            final picked = await showDatePicker(
                                                                                context: ctx2,
                                                                                initialDate: DateTime.now(),
                                                                                firstDate: DateTime(2000),
                                                                                lastDate: DateTime(2100));
                                                                            if (picked !=
                                                                                null) {
                                                                              setSt(() => end = picked);
                                                                            }
                                                                          },
                                                                          child:
                                                                              InputDecorator(
                                                                            decoration:
                                                                                const InputDecoration(border: OutlineInputBorder(), labelText: 'الى تاريخ'),
                                                                            child: Text(end == null
                                                                                ? 'اختر'
                                                                                : end!.toIso8601String().split('T').first),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      const SizedBox(
                                                                          width:
                                                                              8),
                                                                      ElevatedButton(
                                                                        onPressed:
                                                                            () async {
                                                                          setSt(() =>
                                                                              vloading = true);
                                                                          final list = await _loadDailiesFor(
                                                                              loc.name,
                                                                              start: start,
                                                                              end: end);
                                                                          setSt(
                                                                              () {
                                                                            viewData =
                                                                                list;
                                                                            vloading =
                                                                                false;
                                                                          });
                                                                        },
                                                                        style: ElevatedButton.styleFrom(
                                                                            backgroundColor:
                                                                                Colors.teal),
                                                                        child: const Text(
                                                                            'عرض'),
                                                                      )
                                                                    ],
                                                                  ),
                                                                ),
                                                                const Divider(),
                                                                Expanded(
                                                                  child: vloading
                                                                      ? const Center(child: CircularProgressIndicator())
                                                                      : viewData.isEmpty
                                                                          ? const Center(child: Text('لا توجد سجلات'))
                                                                          : SingleChildScrollView(
                                                                              child: DataTable(
                                                                                columns: const [
                                                                                  DataColumn(label: Text('التاريخ')),
                                                                                  DataColumn(label: Text('مجموع المبيعات')),
                                                                                  DataColumn(label: Text('الموقع')),
                                                                                ],
                                                                                rows: viewData
                                                                                    .map((d) => DataRow(cells: [
                                                                                          DataCell(Text(d.date.toIso8601String().split('T').first)),
                                                                                          DataCell(Text((d.cashSales + d.bankSales + d.fawrySales + d.accountSales).toString())),
                                                                                          DataCell(Text(d.businessLocation)),
                                                                                        ]))
                                                                                    .toList(),
                                                                              ),
                                                                            ),
                                                                )
                                                              ],
                                                            ),
                                                          ),
                                                        );
                                                      });
                                                    });
                                              },
                                            ),
                                            IconButton(
                                              icon: const Icon(Icons.delete,
                                                  color: Colors.red),
                                              onPressed: () =>
                                                  _confirmDeleteLocation(
                                                      loc.name),
                                            ),
                                            Tooltip(
                                              message: isCurrent
                                                  ? 'الموقع الحالي'
                                                  : 'تعيين كموقع حالي',
                                              child: IconButton(
                                                icon: Icon(
                                                  Icons.location_on,
                                                  color: isCurrent
                                                      ? Colors.green
                                                      : Colors.teal,
                                                ),
                                                onPressed: isCurrent
                                                    ? null
                                                    : () {
                                                        AuthContext
                                                                .businessLocation =
                                                            loc.name;
                                                        _showMessage(
                                                            'تغيير الموقع',
                                                            'تم تغيير الموقع بنجاح \n  الموقع الحالي: ${loc.name}');
                                                        setState(() {});
                                                      },
                                              ),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                  const SizedBox(height: 50),
                  Center(
                    child: Text(
                      'اليوميات لكل المواقع',
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Colors.teal.shade800,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: _pickStartDate,
                          child: InputDecorator(
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'من تاريخ',
                              isDense: true,
                            ),
                            child: Text(
                              _startDate == null
                                  ? 'اختر'
                                  : _startDate!
                                      .toIso8601String()
                                      .split('T')
                                      .first,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: InkWell(
                          onTap: _pickEndDate,
                          child: InputDecorator(
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'الى تاريخ',
                              isDense: true,
                            ),
                            child: Text(
                              _endDate == null
                                  ? 'اختر'
                                  : _endDate!
                                      .toIso8601String()
                                      .split('T')
                                      .first,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: () => _fetchAllDailies(
                            _startDate ?? DateTime.now(),
                            _endDate ?? DateTime.now()),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.teal),
                        child: const Text('بحث'),
                      ),
                    ],
                  ),
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: SizedBox(
                        height: 360,
                        child: allDailiesLoading
                            ? const Center(
                                child: CircularProgressIndicator(),
                              )
                            : allDailies.isEmpty
                                ? const Center(child: Text('لا توجد سجلات'))
                                : LocationsDailyTable(
                                    dailies: allDailies,
                                  ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
