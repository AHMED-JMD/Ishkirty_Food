import 'package:ashkerty_food/static/formatter.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:flutter/foundation.dart';
import 'package:ashkerty_food/models/PurchaseRequest.dart';

pw.Container createTableCell(String text) {
  return pw.Container(
    child: pw.Padding(
        padding: pw.EdgeInsets.only(top: 3, bottom: 3),
        child: pw.Text(text, style: pw.TextStyle())),
    alignment: pw.Alignment.center,
    // verticalAlignment: pw.TableCellVerticalAlignment.middle,
  );
}

pw.Table createTable(data) {
  return pw.Table(
    border: pw.TableBorder.symmetric(inside: pw.BorderSide.none),
    defaultColumnWidth: pw.IntrinsicColumnWidth(),
    children: [
      pw.TableRow(
        children: [
          createTableCell(
            'الجملة',
          ),
          createTableCell(
            'السعر',
          ),
          createTableCell(
            'الصنف',
          ),
          createTableCell(
            'الكمية',
          ),
        ],
      ),
      if (data['trans'].length != 0)
        ...data['trans'].map(
          (name) => pw.TableRow(
            children: [
              createTableCell(
                name.total_price.toString(),
              ),
              createTableCell(
                name.unit_price.toString(),
              ),
              createTableCell(
                "${name.spices} ${name.addons.join(', ')}",
              ),
              createTableCell(
                name.counter.toString(),
              ),
            ],
          ),
        )
    ],
  );
}

// Print employee salaries list and total
printEmployeeSalaries(
    {String? printerName,
    required String admin,
    required List employees,
    required double totalSalaries}) async {
  var arabicFont =
      pw.Font.ttf(await rootBundle.load("assets/fonts/HacenTunisia.ttf"));
  var myTheme = pw.ThemeData.withFont(base: arabicFont);

  final doc = pw.Document();

  // load image
  const imageProvider = AssetImage('assets/images/abdLogo.png');
  final ByteData byteData = await rootBundle.load(imageProvider.assetName);
  final Uint8List bytes = byteData.buffer.asUint8List();
  final image = pw.Image(pw.MemoryImage(bytes));

  DateTime now = DateTime.now();
  String date = '${now.year}/${now.month}/${now.day}';
  String time = '${now.hour}:${now.minute}:${now.second}';

  // compute total

  pw.Table buildTable(List list) {
    return pw.Table(
        border: pw.TableBorder.symmetric(inside: pw.BorderSide.none),
        defaultColumnWidth: pw.IntrinsicColumnWidth(),
        children: [
          pw.TableRow(children: [
            createTableCell('الراتب'),
            createTableCell('الموظف'),
          ]),
          ...list.map((r) {
            final name = r is Map ? (r['name'] ?? '') : (r.name ?? '');
            final sal = r is Map ? (r['salary'] ?? 0) : (r.salary ?? 0);
            return pw.TableRow(children: [
              createTableCell(numberFormatter(sal)),
              createTableCell(name.toString()),
            ]);
          }).toList()
        ]);
  }

  doc.addPage(pw.Page(
      pageFormat: PdfPageFormat.roll80,
      theme: myTheme,
      build: (pw.Context context) {
        return pw.Directionality(
            textDirection: pw.TextDirection.rtl,
            child: pw.ListView(children: [
              pw.Column(children: [
                pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Container(width: 60, height: 60, child: image),
                      pw.Column(children: [
                        pw.Text('مرتبات الموظفين',
                            style: const pw.TextStyle(fontSize: 16)),
                        pw.Text('التاريخ: $date   $time'),
                        pw.Text('المسؤول: $admin'),
                      ])
                    ]),
                pw.Divider(),
                pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text('اجمالي المرتبات:'),
                      pw.Text(numberFormatter(totalSalaries),
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold))
                    ]),
                pw.Divider(),
                buildTable(employees),
                pw.Divider(),
              ])
            ]));
      }));

  if (!kIsWeb && printerName != null) {
    await Printing.directPrintPdf(
        printer: Printer(url: printerName),
        onLayout: (PdfPageFormat format) async => doc.save());
  } else {
    await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => doc.save());
  }
}

// Print sales report: totals and spieces table
printSalesReport(
    {required String admin,
    required List spieces,
    required int cashTotal,
    required int bankTotal,
    required int fawryTotal,
    // required int accountTotal,
    String? period}) async {
  var arabicFont =
      pw.Font.ttf(await rootBundle.load("assets/fonts/HacenTunisia.ttf"));
  var myTheme = pw.ThemeData.withFont(base: arabicFont);

  final doc = pw.Document();

  // load image
  const imageProvider = AssetImage('assets/images/abdLogo.png');
  final ByteData byteData = await rootBundle.load(imageProvider.assetName);
  final Uint8List bytes = byteData.buffer.asUint8List();
  final image = pw.Image(pw.MemoryImage(bytes));

  DateTime now = DateTime.now();
  String date = '${now.year}/${now.month}/${now.day}';
  String time = '${now.hour}:${now.minute}:${now.second}';

  doc.addPage(pw.Page(
      pageFormat: PdfPageFormat.roll80,
      theme: myTheme,
      build: (pw.Context context) {
        return pw.Directionality(
            textDirection: pw.TextDirection.rtl,
            child: pw.ListView(children: [
              pw.Column(children: [
                pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Container(width: 60, height: 60, child: image),
                      pw.Column(children: [
                        pw.Text('تقرير المبيعات',
                            style: const pw.TextStyle(
                              fontSize: 16,
                            )),
                        if (period != null) pw.Text('الفترة: $period'),
                        pw.Text('التاريخ: $date   $time'),
                        pw.Text('المستخدم: $admin'),
                      ])
                    ]),
              ]),
              pw.Divider(),
              pw.Padding(
                  padding:
                      const pw.EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  child: pw.Column(children: [
                    pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: [
                          pw.Text('نقدي:'),
                          pw.Text(numberFormatter(cashTotal)),
                        ]),
                    pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: [
                          pw.Text('بنك:'),
                          pw.Text(numberFormatter(bankTotal)),
                        ]),
                    pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: [
                          pw.Text('فوري:'),
                          pw.Text(numberFormatter(fawryTotal)),
                        ]),
                    pw.Divider(),
                    pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: [
                          pw.Text('اجمالي:'),
                          pw.Text(numberFormatter(cashTotal +
                              bankTotal +
                              fawryTotal)), //+accountTotal
                        ]),
                  ])),
              pw.Divider(),
              pw.Table(
                  border: pw.TableBorder.symmetric(inside: pw.BorderSide.none),
                  defaultColumnWidth: pw.IntrinsicColumnWidth(),
                  children: [
                    pw.TableRow(children: [
                      createTableCell('المبلغ'),
                      // createTableCell('السعر'),
                      createTableCell('مبيعات'),
                      createTableCell('الصنف'),
                    ]),
                    ...spieces.map((e) {
                      final name = e is Map ? (e['name'] ?? '') : e.name ?? '';
                      final saleSum =
                          e is Map ? (e['saleSum'] ?? 0) : e.saleSum ?? 0;
                      // final price = e is Map ? (e['price'] ?? 0) : e.price ?? 0;
                      final totSales =
                          e is Map ? (e['totSales'] ?? 0) : e.totSales ?? 0;
                      // final profit = (saleSum is num ? saleSum : 0) -
                      //     (totSales is num ? totSales : 0);
                      return pw.TableRow(children: [
                        createTableCell("(${numberFormatter(totSales)})"),
                        // createTableCell(numberFormatter(price)),
                        createTableCell('(${numberFormatter(saleSum)})'),
                        createTableCell(name.toString()),
                      ]);
                    }).toList()
                  ])
            ]));
      }));

  await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => doc.save());
}

// Print purchases table
printPurchaseTable(
    {String? printerName,
    required String admin,
    required String type,
    required List items,
    String? period}) async {
  var arabicFont =
      pw.Font.ttf(await rootBundle.load("assets/fonts/HacenTunisia.ttf"));
  var myTheme = pw.ThemeData.withFont(base: arabicFont);

  final doc = pw.Document();

  // load image
  const imageProvider = AssetImage('assets/images/abdLogo.png');
  final ByteData byteData = await rootBundle.load(imageProvider.assetName);
  final Uint8List bytes = byteData.buffer.asUint8List();
  final image = pw.Image(pw.MemoryImage(bytes));

  DateTime now = DateTime.now();
  String date = '${now.year}/${now.month}/${now.day}';
  String time = '${now.hour}:${now.minute}:${now.second}';

  String _storeName(dynamic it) {
    if (it is PurchaseRequest) return it.store.name.toString();
    if (it is Map) {
      return (it['Store']?['name'] ?? it['store']?['name'] ?? '').toString();
    }
    return '';
  }

  bool _isKilo(dynamic it) {
    if (it is PurchaseRequest) return it.store.isKilo;
    if (it is Map) {
      return (it['Store']?['is_kilo'] ?? it['store']?['isKilo'] ?? false) ==
          true;
    }
    return false;
  }

  // DateTime _date(dynamic it) {
  //   if (it is PurchaseRequest) return it.date;
  //   if (it is Map) {
  //     return DateTime.tryParse(it['date']?.toString() ?? '') ?? DateTime.now();
  //   }
  //   return DateTime.now();
  // }

  String _typeLabel(dynamic it) {
    final value =
        it is PurchaseRequest ? it.type : (it is Map ? it['type'] : null);
    return value == 'خصم' ? 'تالف' : 'استلام';
  }

  String _paymentMethod(dynamic it) {
    final value = it is PurchaseRequest
        ? it.paymentMethod
        : (it is Map ? (it['payment_method'] ?? it['paymentMethod']) : '');
    return value?.toString() ?? '';
  }

  String _quantityText(dynamic it, {required bool net}) {
    final qty = it is PurchaseRequest
        ? (net ? it.netQuantity : it.quantity)
        : (it is Map
            ? (net ? it['net_quantity'] ?? it['netQuantity'] : it['quantity'])
            : 0);
    final unit = _isKilo(it) ? 'كجم' : '';
    return '${qty ?? 0}  $unit';
  }

  String _buyPrice(dynamic it) {
    final val = it is PurchaseRequest
        ? it.buyPrice
        : (it is Map ? it['buy_price'] ?? it['buyPrice'] : 0);
    return '${numberFormatter(val ?? 0)} (جنيه)';
  }

  String _admin(dynamic it) {
    final value =
        it is PurchaseRequest ? it.admin : (it is Map ? it['admin'] : '');
    return value?.toString() ?? '';
  }

  pw.Table buildTable(List list) {
    return pw.Table(
      border: pw.TableBorder.symmetric(inside: pw.BorderSide.none),
      defaultColumnWidth: pw.IntrinsicColumnWidth(),
      children: [
        pw.TableRow(children: [
          if (type == 'تصنيع') createTableCell('طريقة الدفع'),
          if (type == 'تصنيع') createTableCell('سعر الشراء'),
          createTableCell('المستخدم'),
          createTableCell('الكمية'),
          if (type == 'بيع') createTableCell('النوع'),
          createTableCell('الصنف'),
        ]),
        ...list.map((it) {
          // final d = _date(it).toIso8601String().split('T').first;
          return pw.TableRow(children: [
            if (type == 'تصنيع') createTableCell(_paymentMethod(it)),
            if (type == 'تصنيع') createTableCell(_buyPrice(it)),
            createTableCell(_admin(it)),
            createTableCell(_quantityText(it, net: true)),
            if (type == 'بيع') createTableCell(_typeLabel(it)),
            createTableCell(_storeName(it)),
          ]);
        }).toList()
      ],
    );
  }

  doc.addPage(pw.Page(
      pageFormat: PdfPageFormat.roll80,
      theme: myTheme,
      build: (pw.Context context) {
        return pw.Directionality(
            textDirection: pw.TextDirection.rtl,
            child: pw.ListView(children: [
              pw.Column(children: [
                pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Container(width: 60, height: 60, child: image),
                      pw.Column(children: [
                        pw.Text('استلامات المطبخ',
                            style: const pw.TextStyle(fontSize: 16)),
                        // if (period != null) pw.Text('الفترة: $period'),
                        pw.Text('التاريخ: $date   $time'),
                        pw.Text('المستخدم: $admin'),
                      ])
                    ]),
                pw.Divider(),
                buildTable(items),
                pw.Divider(),
              ])
            ]));
      }));

  if (!kIsWeb && printerName != null) {
    await Printing.directPrintPdf(
        printer: Printer(url: printerName),
        onLayout: (PdfPageFormat format) async => doc.save());
  } else {
    await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => doc.save());
  }
}

//print future function
PrintingFunc(String Pname, counter, type, user, data,
    {bool includeLabel = true, String? labelText}) async {
  // Set the font for Arabic text
  var arabicFont =
      pw.Font.ttf(await rootBundle.load("assets/fonts/HacenTunisia.ttf"));
  //set Theme
  var myTheme = pw.ThemeData.withFont(
    base: arabicFont,
  );
  final doc = pw.Document();

  // load and prepare image
  const imageProvider = AssetImage('assets/images/abdLogo.png');
  final ByteData byteData = await rootBundle.load(imageProvider.assetName);
  final Uint8List bytes = byteData.buffer.asUint8List();

  // Create a pw.Image instance with the imageBytes
  final image = pw.Image(pw.MemoryImage(bytes));

  //setting date and time
  DateTime now = DateTime.now();
  String date = '${now.year}/${now.month}/${now.day}';
  String time = '${now.hour}:${now.minute}:${now.second}';
  String amPm = now.hour < 12 ? 'AM' : 'PM';

  //create pdf
  doc.addPage(pw.Page(
      pageFormat: PdfPageFormat.roll80,
      theme: myTheme,
      build: (pw.Context context) {
        return pw.Directionality(
            textDirection: pw.TextDirection.rtl,
            child: pw.ListView(children: [
              pw.Column(
                  mainAxisAlignment: pw.MainAxisAlignment.center,
                  children: [
                    pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceEvenly,
                        children: [
                          pw.Container(width: 60, height: 60, child: image),
                          pw.Column(
                            children: [
                              if (includeLabel)
                                pw.Container(
                                  padding: const pw.EdgeInsets.all(2),
                                  color: PdfColors.black,
                                  child: pw.Text(labelText ?? '',
                                      style: pw.TextStyle(
                                        font: arabicFont,
                                        fontSize: 15,
                                        color: PdfColors.white,
                                      )),
                                ),
                              pw.Text('سفري',
                                  style: const pw.TextStyle(
                                    fontSize: 12,
                                  )),
                              pw.Text(counter,
                                  style: pw.TextStyle(
                                      fontSize: 16,
                                      fontWeight: pw.FontWeight.bold)),
                            ],
                          )
                        ]),
                    pw.Divider(thickness: 2),
                    pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: [
                          pw.Column(children: [
                            pw.Text(
                              "الدفع : ${data['paymentMethod']}",
                            ),
                            pw.Text(
                              "التوصيل : ${data['delivery_cost']}",
                            ),
                            pw.Text(
                              "العنوان  : ${data['delivery_address']}",
                            ),
                          ]),
                          pw.Column(children: [
                            pw.Text('التاريخ : ${date}'),
                            pw.Text('الوقت : ${time} $amPm'),
                            pw.Text(
                              "الويتر : ${user['username']}",
                            ),
                          ]),
                        ]),
                    pw.Divider(),
                    createTable(data),
                    pw.Divider(),
                    pw.Padding(
                      padding: const pw.EdgeInsets.only(left: 10),
                      child: pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.end,
                          children: [
                            pw.Text(
                              "الجملة  =  ",
                            ),
                            pw.Text(
                              '${data['amount']}',
                            ),
                          ]),
                    ),
                    pw.Divider(),
                  ])
            ]));
      }));

  //print page as pdf
  await Printing.directPrintPdf(
      printer: Printer(url: Pname),
      onLayout: (PdfPageFormat format) async => doc.save());
}
//EPSON TM-T20II Receipt

// Print two copies: first for cashier (includes label), second for client (no label)
printCopies(String Pname, counter, type, user, data,
    {String? cashierLabel}) async {
  // On web: build a single PDF that contains two pages (cashier + client)
  // so the browser print dialog prints both copies in one job.
  if (kIsWeb) {
    // Set the font for Arabic text
    var arabicFont =
        pw.Font.ttf(await rootBundle.load("assets/fonts/HacenTunisia.ttf"));
    //set Theme
    var myTheme = pw.ThemeData.withFont(
      base: arabicFont,
    );

    // load and prepare image
    const imageProvider = AssetImage('assets/images/abdLogo.png');
    final ByteData byteData = await rootBundle.load(imageProvider.assetName);
    final Uint8List bytes = byteData.buffer.asUint8List();

    // Create a pw.Image instance with the imageBytes
    final image = pw.Image(pw.MemoryImage(bytes));

    //setting date and time
    DateTime now = DateTime.now();
    String date = '${now.year}/${now.month}/${now.day}';
    String time = '${now.hour}:${now.minute}:${now.second}';
    String amPm = now.hour < 12 ? 'AM' : 'PM';

    final doc = pw.Document();

    // Prepare item groups from data['trans'] (Cart model or Map)
    final List items = data['trans'] is List ? List.from(data['trans']) : [];
    List juicesItems = items.where((item) {
      final cat =
          item is Map ? (item['category'] ?? '') : (item.category ?? '');
      return cat == 'عصائر';
    }).toList();
    List shawarmaItems = items.where((item) {
      final cat =
          item is Map ? (item['category'] ?? '') : (item.category ?? '');
      return cat == 'شاورما';
    }).toList();
    List otherItems = items.where((item) {
      final cat =
          item is Map ? (item['category'] ?? '') : (item.category ?? '');
      return cat != 'عصائر' && cat != 'شاورما';
    }).toList();

    num sumList(List list) {
      num s = 0;
      for (var it in list) {
        try {
          final v = it is Map
              ? (it['total_price'] ?? it['total_price'] ?? 0)
              : (it.total_price ?? 0);
          s += (v is num ? v : num.parse(v.toString()));
        } catch (e) {}
      }
      return s;
    }

    void addPairFor(List list, {String? label}) {
      final local = Map<String, dynamic>.from(data);
      local['trans'] = list;
      local['amount'] = sumList(list);

      // client copy
      doc.addPage(pw.Page(
          pageFormat: PdfPageFormat.roll80,
          theme: myTheme,
          build: (pw.Context context) {
            return pw.Directionality(
                textDirection: pw.TextDirection.rtl,
                child: pw.ListView(children: [
                  pw.Column(
                      mainAxisAlignment: pw.MainAxisAlignment.center,
                      children: [
                        pw.Row(
                            mainAxisAlignment: pw.MainAxisAlignment.spaceEvenly,
                            children: [
                              pw.Container(width: 60, height: 60, child: image),
                              pw.Column(children: [
                                label != null
                                    ? pw.Container(
                                        padding: const pw.EdgeInsets.all(1),
                                        color: PdfColors.black,
                                        child: pw.Text(label,
                                            style: pw.TextStyle(
                                                font: arabicFont,
                                                fontSize: 14,
                                                color: PdfColors.white)))
                                    : pw.Container(),
                                pw.Text(type,
                                    style: const pw.TextStyle(fontSize: 12)),
                                pw.Text(counter,
                                    style: pw.TextStyle(
                                        fontSize: 16,
                                        fontWeight: pw.FontWeight.bold)),
                              ])
                            ]),
                        pw.Divider(thickness: 2),
                        pw.Row(
                            mainAxisAlignment:
                                pw.MainAxisAlignment.spaceBetween,
                            children: [
                              pw.Column(children: [
                                pw.Text("الدفع : ${local['paymentMethod']}"),
                                pw.Text("التوصيل : ${local['delivery_cost']}"),
                                pw.Text(
                                    "العنوان  : ${local['delivery_address']}"),
                              ]),
                              pw.Column(children: [
                                pw.Text('التاريخ : ${date}'),
                                pw.Text('الوقت : ${time} $amPm'),
                                pw.Text("الكاشير : ${user['username']}")
                              ]),
                            ]),
                        pw.Divider(),
                        createTable(local),
                        pw.Divider(),
                        pw.Padding(
                            padding: const pw.EdgeInsets.only(left: 10),
                            child: pw.Row(
                                mainAxisAlignment: pw.MainAxisAlignment.end,
                                children: [
                                  pw.Text("الجملة  =  "),
                                  pw.Text(numberFormatter(local['amount']))
                                ])),
                        pw.Divider(),
                      ])
                ]));
          }));

      // cashier copy (no label)
      doc.addPage(pw.Page(
          pageFormat: PdfPageFormat.roll80,
          theme: myTheme,
          build: (pw.Context context) {
            return pw.Directionality(
                textDirection: pw.TextDirection.rtl,
                child: pw.ListView(children: [
                  pw.Column(
                      mainAxisAlignment: pw.MainAxisAlignment.center,
                      children: [
                        pw.Row(
                            mainAxisAlignment: pw.MainAxisAlignment.spaceEvenly,
                            children: [
                              pw.Container(width: 60, height: 60, child: image),
                              pw.Column(children: [
                                pw.Text(type,
                                    style: const pw.TextStyle(fontSize: 12)),
                                pw.Text(counter,
                                    style: pw.TextStyle(
                                        fontSize: 16,
                                        fontWeight: pw.FontWeight.bold))
                              ])
                            ]),
                        pw.Divider(thickness: 2),
                        pw.Row(
                            mainAxisAlignment:
                                pw.MainAxisAlignment.spaceBetween,
                            children: [
                              pw.Column(children: [
                                pw.Text("الدفع : ${local['paymentMethod']}"),
                                pw.Text("التوصيل : ${local['delivery_cost']}"),
                                pw.Text(
                                    "العنوان  : ${local['delivery_address']}")
                              ]),
                              pw.Column(children: [
                                pw.Text('التاريخ : ${date}'),
                                pw.Text('الوقت : ${time} $amPm'),
                                pw.Text("الكاشير : ${user['username']}")
                              ]),
                            ]),
                        pw.Divider(),
                        createTable(local),
                        pw.Divider(),
                        pw.Padding(
                            padding: const pw.EdgeInsets.only(left: 10),
                            child: pw.Row(
                                mainAxisAlignment: pw.MainAxisAlignment.end,
                                children: [
                                  pw.Text("الجملة  =  "),
                                  pw.Text('${local['amount']}')
                                ])),
                        pw.Divider(),
                      ])
                ]));
          }));
    }

    // decide which groups to print
    final groups = [juicesItems, shawarmaItems, otherItems];
    final nonEmpty = groups.where((g) => g.isNotEmpty).length;

    if (nonEmpty >= 2) {
      // print two copies for each non-empty group
      if (juicesItems.isNotEmpty) addPairFor(juicesItems, label: cashierLabel);
      if (shawarmaItems.isNotEmpty) {
        addPairFor(shawarmaItems, label: cashierLabel);
      }
      if (otherItems.isNotEmpty) {
        addPairFor(otherItems, label: cashierLabel);
      }
    } else if (nonEmpty == 1) {
      // if only one group present and it's juices or shawarma -> print two pairs (4 copies)
      if (juicesItems.isNotEmpty) {
        addPairFor(juicesItems, label: cashierLabel);
      } else if (shawarmaItems.isNotEmpty) {
        addPairFor(shawarmaItems, label: cashierLabel);
      } else if (otherItems.isNotEmpty) {
        addPairFor(otherItems, label: cashierLabel);
      }
    }

    await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => doc.save());
    return;
  }

  // Non-web: send two separate print jobs to the printer (cashier then client)
  // // cashier copy with label
}

// Print a daily summary with totals and three tables: empTrans, purchases, discharges
printDailyComponents({
  String? printerName,
  required String admin,
  required num totalSales,
  required num totalCosts,
  required num totalSpiceCosts,
  required num totalEmployeeTran,
  required num totalPurchase,
  required num totalDischarges,
  required List empTrans,
  required List purchases,
  required List discharges,
  String? period,
}) async {
  var arabicFont =
      pw.Font.ttf(await rootBundle.load("assets/fonts/HacenTunisia.ttf"));
  var myTheme = pw.ThemeData.withFont(base: arabicFont);

  final doc = pw.Document();

  // load image
  const imageProvider = AssetImage('assets/images/abdLogo.png');
  final ByteData byteData = await rootBundle.load(imageProvider.assetName);
  final Uint8List bytes = byteData.buffer.asUint8List();
  final image = pw.Image(pw.MemoryImage(bytes));

  DateTime now = DateTime.now();
  String date = '${now.year}/${now.month}/${now.day}';
  String time = '${now.hour}:${now.minute}:${now.second}';

  pw.Table buildGenericTable(
      List list, List<String> headers, List<Function> accessors) {
    return pw.Table(
        border: pw.TableBorder.symmetric(inside: pw.BorderSide.none),
        defaultColumnWidth: pw.IntrinsicColumnWidth(),
        children: [
          pw.TableRow(
              children: headers.map((h) => createTableCell(h)).toList()),
          ...list.map((row) {
            return pw.TableRow(
                children: accessors.map((acc) {
              try {
                final v = acc(row) ?? '';
                return createTableCell(v.toString());
              } catch (e) {
                return createTableCell('');
              }
            }).toList());
          }).toList()
        ]);
  }

  doc.addPage(pw.Page(
      pageFormat: PdfPageFormat.roll80,
      theme: myTheme,
      build: (pw.Context context) {
        return pw.Directionality(
            textDirection: pw.TextDirection.rtl,
            child: pw.ListView(children: [
              pw.Column(children: [
                pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Container(width: 60, height: 60, child: image),
                      pw.Column(children: [
                        pw.Text('تقرير اليومية',
                            style: const pw.TextStyle(fontSize: 16)),
                        if (period != null) pw.Text('الفترة: $period'),
                        pw.Text('التاريخ: $date   $time'),
                        pw.Text('المستخدم: $admin'),
                      ])
                    ])
              ]),
              pw.Divider(),
              pw.Padding(
                  padding:
                      const pw.EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  child: pw.Column(children: [
                    pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: [
                          pw.Text('اجمالي المبيعات:'),
                          pw.Text(
                            numberFormatter(totalSales),
                            style: pw.TextStyle(
                                fontWeight: pw.FontWeight.bold, fontSize: 13),
                          )
                        ]),
                    pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: [
                          pw.Text('اجمالي التكاليف:'),
                          pw.Text(
                            numberFormatter(totalCosts),
                            style: pw.TextStyle(
                                fontWeight: pw.FontWeight.bold, fontSize: 13),
                          )
                        ]),
                    pw.Divider(),
                    pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: [
                          pw.Text('صافي الربح:'),
                          pw.Text(
                            numberFormatter(totalSales - totalCosts),
                            style: pw.TextStyle(
                                fontWeight: pw.FontWeight.bold, fontSize: 13),
                          )
                        ]),
                  ])),
              pw.Divider(),
              pw.Row(mainAxisAlignment: pw.MainAxisAlignment.center, children: [
                pw.Text(' تكاليف الاصناف : '),
                pw.Text(numberFormatter(totalSpiceCosts))
              ]),
              pw.Divider(),
              pw.Row(mainAxisAlignment: pw.MainAxisAlignment.center, children: [
                pw.Text('مرتبات الموظفين',
                    style: const pw.TextStyle(fontSize: 12)),
                pw.SizedBox(width: 4),
                pw.Text(' ${numberFormatter(totalEmployeeTran)} : ',
                    style: const pw.TextStyle(fontSize: 12)),
              ]),
              pw.SizedBox(height: 4),
              buildGenericTable(empTrans, [
                'المبلغ',
                'الموظف',
              ], [
                (r) => r is Map ? (r['amount'] ?? '') : (r.amount ?? ''),
                (r) =>
                    r is Map ? (r['employee'] ?? '') : (r.employeeName ?? ''),
              ]),
              pw.Divider(),
              pw.Row(mainAxisAlignment: pw.MainAxisAlignment.center, children: [
                pw.Text('المشتريات', style: const pw.TextStyle(fontSize: 12)),
                pw.SizedBox(width: 4),
                pw.Text(' ${numberFormatter(totalPurchase)} : ',
                    style: const pw.TextStyle(fontSize: 12)),
              ]),
              pw.SizedBox(height: 4),
              buildGenericTable(purchases, [
                'المبلغ',
                'الكمية',
                'الصنف'
              ], [
                (r) => r is Map
                    ? (r['buyPrice'] ?? r['unit_price'] ?? '')
                    : (r.buyPrice * r.quantity ?? ''),
                (r) => r is Map ? (r['quantity'] ?? '') : (r.quantity ?? ''),
                (r) => r is Map ? (r['name'] ?? '') : (r.store.name ?? ''),
              ]),
              pw.Divider(),
              pw.Row(mainAxisAlignment: pw.MainAxisAlignment.center, children: [
                pw.Text('المصروفات', style: const pw.TextStyle(fontSize: 12)),
                pw.SizedBox(width: 4),
                pw.Text(' ${numberFormatter(totalDischarges)} : ',
                    style: const pw.TextStyle(fontSize: 12)),
              ]),
              pw.SizedBox(height: 4),
              buildGenericTable(discharges, [
                'السعر',
                'الاسم'
              ], [
                (r) => r is Map ? (r['price'] ?? '') : (r.price ?? ''),
                (r) => r is Map ? (r['name'] ?? '') : (r.name ?? ''),
              ]),
              pw.SizedBox(height: 8),
            ]));
      }));

  // Send to printer: prefer direct print if a printerName is provided and not web
  if (!kIsWeb && printerName != null) {
    await Printing.directPrintPdf(
        printer: Printer(url: printerName),
        onLayout: (PdfPageFormat format) async => doc.save());
  } else {
    await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => doc.save());
  }
}
