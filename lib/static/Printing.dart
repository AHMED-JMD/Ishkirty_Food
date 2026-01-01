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
            'المبلغ',
          ),
          createTableCell(
            'السعر',
          ),
          createTableCell(
            'اضافة',
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
                name.addons.toString(),
              ),
              createTableCell(
                name.spices,
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
PrintingFunc(String Pname, counter, user, data) async {
  // Set the font for Arabic text
  var arabicFont =
      pw.Font.ttf(await rootBundle.load("assets/fonts/HacenTunisia.ttf"));
  //set Theme
  var myTheme = pw.ThemeData.withFont(
    base: arabicFont,
  );
  final doc = pw.Document();

  // load and prepare image
  const imageProvider = AssetImage('assets/images/ef2.jpg');
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
                          pw.Text('Eshkarti',
                              style: const pw.TextStyle(
                                fontSize: 16,
                              )),
                          pw.Container(width: 20, height: 20, child: image),
                          pw.Text('اشكرتي',
                              style: const pw.TextStyle(
                                fontSize: 16,
                              )),
                        ]),
                    pw.Divider(thickness: 2),
                    pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
                        children: [
                          pw.Row(children: [
                            pw.Text('${date} - '),
                            pw.Text('${time} $amPm'),
                          ]),
                          pw.Row(children: [
                            pw.Text('($counter)',
                                style: const pw.TextStyle(
                                  fontSize: 18,
                                )),
                            pw.Text('فاتورة رقم ',
                                style: const pw.TextStyle(
                                  fontSize: 14,
                                )),
                          ]),
                        ]),
                    pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceEvenly,
                        children: [
                          pw.Text(
                            "طريقة الدفع = ${data['paymentMethod']}",
                          ),
                          pw.Text(
                            "المستخدم = ${user['username']}",
                          ),
                        ]),
                    pw.Divider(),
                    createTable(data),
                    pw.Divider(),
                    pw.Padding(
                      padding: const pw.EdgeInsets.only(left: 10),
                      child: pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.start,
                          children: [
                            pw.Text(
                              '${data['amount']}',
                            ),
                            pw.Text(
                              "الجملة  =  ",
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
