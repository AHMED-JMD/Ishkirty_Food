import 'dart:convert';

import 'package:ashkerty_food/API/BusinessLocation.dart';
import 'package:ashkerty_food/API/Daily.dart' as api;
import 'package:ashkerty_food/models/BusinessLocation.dart';
import 'package:ashkerty_food/models/Daily.dart';
import 'package:ashkerty_food/providers/Auth_provider.dart';
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
  final TextEditingController _newController = TextEditingController();
  bool loading = false;

  @override
  void dispose() {
    _newController.dispose();
    super.dispose();
  }

//get all locations on init
  @override
  void initState() {
    super.initState();
    _fetchLocations();
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

      final res = await api.APIDaily.getByDate(body);
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

  void _showMessage(String title, String msg) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Center(child: Text(title)),
        content: Center(child: Text(msg)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('حسناً'),
          ),
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
            title: const Center(child: Text('إدارة المواقع')),
            backgroundColor: Colors.teal,
          ),
          body: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                if (isSuper) ...[
                  Row(
                    children: [
                      const Text('اختر الموقع الحالي: '),
                      const SizedBox(width: 12),
                      DropdownButton(
                        value: AuthContext.businessLocation,
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
                              'تم تغيير الموقع ينجاح \n  الموقع الحالي: $v');
                          setState(() {});
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                ],
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _newController,
                        decoration: const InputDecoration(
                          labelText: 'إضافة موقع جديد',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () => _addLocation(_newController.text, ''),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal),
                      child: const Text('إضافة'),
                    )
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
                                                  fontWeight: FontWeight.bold),
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
                                                padding:
                                                    const EdgeInsets.symmetric(
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
                                                        builder: (ctx2, setSt) {
                                                      return Padding(
                                                        padding:
                                                            MediaQuery.of(ctx2)
                                                                .viewInsets,
                                                        child: SizedBox(
                                                          height: MediaQuery.of(
                                                                      ctx2)
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
                                                                              null)
                                                                            setSt(() =>
                                                                                start = picked);
                                                                        },
                                                                        child:
                                                                            InputDecorator(
                                                                          decoration: const InputDecoration(
                                                                              border: OutlineInputBorder(),
                                                                              labelText: 'من تاريخ'),
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
                                                                              null)
                                                                            setSt(() =>
                                                                                end = picked);
                                                                        },
                                                                        child:
                                                                            InputDecorator(
                                                                          decoration: const InputDecoration(
                                                                              border: OutlineInputBorder(),
                                                                              labelText: 'الى تاريخ'),
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
                                                                            vloading =
                                                                                true);
                                                                        final list = await _loadDailiesFor(
                                                                            loc
                                                                                .name,
                                                                            start:
                                                                                start,
                                                                            end:
                                                                                end);
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
                                                                    ? const Center(
                                                                        child:
                                                                            CircularProgressIndicator())
                                                                    : viewData
                                                                            .isEmpty
                                                                        ? const Center(
                                                                            child:
                                                                                Text('لا توجد سجلات'))
                                                                        : SingleChildScrollView(
                                                                            child:
                                                                                DataTable(
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
                                                _deleteLocation(loc.name),
                                          ),
                                          IconButton(
                                            icon: const Icon(Icons.store,
                                                color: Colors.grey),
                                            onPressed: () {
                                              AuthContext.businessLocation =
                                                  loc.name;
                                              _showMessage('تغيير الموقع',
                                                  'تم تغيير الموقع بنجاح \n  الموقع الحالي: ${loc.name}');
                                              setState(() {});
                                            },
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
              ],
            ),
          ),
        ),
      );
    });
  }
}
