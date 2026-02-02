import 'package:ashkerty_food/static/formatter.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:flutter/foundation.dart';

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

// Print sales report: totals and spieces table
printSalesReport(
    {required List spieces,
    required int cashTotal,
    required int bankTotal,
    required int accountTotal,
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
                        pw.Text('التاريخ: $date   $time')
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
                          pw.Text('حساب:'),
                          pw.Text(numberFormatter(accountTotal)),
                        ]),
                    pw.Divider(),
                    pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: [
                          pw.Text('اجمالي:'),
                          pw.Text(numberFormatter(
                              cashTotal + bankTotal + accountTotal)),
                        ]),
                  ])),
              pw.Divider(),
              pw.Table(
                  border: pw.TableBorder.symmetric(inside: pw.BorderSide.none),
                  defaultColumnWidth: pw.IntrinsicColumnWidth(),
                  children: [
                    pw.TableRow(children: [
                      createTableCell('الربح'),
                      createTableCell('مبيعات'),
                      createTableCell('الصنف'),
                    ]),
                    ...spieces.map((e) {
                      final name = e is Map ? (e['name'] ?? '') : e.name ?? '';
                      final totSales =
                          e is Map ? (e['tot_sales'] ?? 0) : e.totSales ?? 0;
                      final totCosts =
                          e is Map ? (e['tot_costs'] ?? 0) : e.totCosts ?? 0;
                      final profit = (totSales is num ? totSales : 0) -
                          (totCosts is num ? totCosts : 0);
                      return pw.TableRow(children: [
                        createTableCell(profit.toString()),
                        createTableCell(totSales.toString()),
                        createTableCell(name.toString()),
                      ]);
                    }).toList()
                  ])
            ]));
      }));

  await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => doc.save());
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
printTwoCopies(String Pname, counter, type, user, data,
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

    // Add cashier copy (with label)
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
                                cashierLabel != null
                                    ? pw.Container(
                                        padding: const pw.EdgeInsets.all(1),
                                        color: PdfColors.black,
                                        child: pw.Text(cashierLabel,
                                            style: pw.TextStyle(
                                              font: arabicFont,
                                              fontSize: 14,
                                              color: PdfColors.white,
                                            )),
                                      )
                                    : pw.Container(),
                                pw.Text(type,
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
                                numberFormatter(data['amount']),
                              ),
                            ]),
                      ),
                      pw.Divider(),
                    ])
              ]));
        }));

    // small gap between copies
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
                                pw.Text(type,
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
