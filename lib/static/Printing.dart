import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

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

//print future function
PrintingFunc(String Pname, counter, user, data,
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
                              pw.Text('A $counter',
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
printTwoCopies(String Pname, counter, user, data,
    {String? cashierLabel}) async {
  // cashier copy with label
  await PrintingFunc(Pname, counter, user, data,
      includeLabel: true, labelText: cashierLabel);
  // small delay can help the printer process first job before sending second
  await Future.delayed(const Duration(milliseconds: 200));
  // client copy without label
  await PrintingFunc(Pname, counter, user, data, includeLabel: false);
}
