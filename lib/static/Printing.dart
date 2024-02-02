import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

pw.Container createTableCell(String text) {
  return pw.Container(
        child: pw.Padding(
            padding: pw.EdgeInsets.only(top: 3,bottom: 3),
            child: pw.Text(
                text,
                style: pw.TextStyle(
                ))
        ),
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
              createTableCell('المبلغ',),
              createTableCell('السعر',),
              createTableCell('الكمية',),
              createTableCell('الصنف',),
            ],
          ),
          if (data['trans'].length != 0)
            ...data['trans'].map(
                  (name) => pw.TableRow(
                children: [
                  createTableCell(name.total_price.toString(),),
                  createTableCell(name.unit_price.toString(),),
                  createTableCell(name.counter.toString(),),
                  createTableCell(name.spices,),
                ],
              ),
            )
        ],
      );
}

//print future function
PrintingFunc(counter, user, data) async {
  // Set the font for Arabic text
  var arabicFont = pw.Font.ttf(await rootBundle.load("assets/fonts/HacenTunisia.ttf"));
  //set Theme
  var myTheme = pw.ThemeData.withFont(
    base: arabicFont,
  );
  final doc = pw.Document();

  // load and prepare image
  final imageProvider = AssetImage('assets/images/ef2.jpg');
  final ByteData byteData = await rootBundle.load(imageProvider.assetName);
  final Uint8List bytes = byteData.buffer.asUint8List();

  // Create a pw.Image instance with the imageBytes
  final image = pw.Image(pw.MemoryImage(bytes));

  //create pdf
  doc.addPage(
      pw.Page(
          pageFormat: PdfPageFormat.roll57,
          theme: myTheme,
          build: (pw.Context context) {
            return pw.Directionality(
                textDirection: pw.TextDirection.rtl,
                child: pw.ListView(
                    children: [
                      pw.Column(
                          mainAxisAlignment: pw.MainAxisAlignment.center,
                          children: [
                            pw.Row(
                              mainAxisAlignment: pw.MainAxisAlignment.spaceEvenly,
                                children: [
                                  pw.Text('Eshkarti', style: pw.TextStyle(fontSize: 19 ,)),
                                  pw.Container(
                                      width: 30,
                                      height: 30,
                                      child: image
                                  ),
                                  pw.Text('اشكرتي', style: pw.TextStyle(fontSize: 19,)),
                                ]
                            ),
                            pw.Divider(thickness: 3),
                            pw.Row(
                              mainAxisAlignment: pw.MainAxisAlignment.center,
                              children: [
                                pw.Text('$counter',
                                    style: pw.TextStyle(
                                      fontSize: 25,
                                    )
                                ),
                                pw.Text('فاتورة مبيعات رقم ',
                                    style: pw.TextStyle(
                                      fontSize: 17,
                                    )
                                ),
                              ]
                            ),
                            pw.Text("المستخدم ${user['username']}",),
                            pw.Row(
                                mainAxisAlignment: pw.MainAxisAlignment.spaceEvenly,
                                children: [
                                  pw.Text("طريقة الدفع = ${data['paymentMethod']}",),
                                  pw.Text('${DateTime.now().toIso8601String()}'),
                                ]
                            ),
                            pw.Divider(),
                            createTable(data),
                            pw.Divider(),
                            pw.Padding(
                              padding: pw.EdgeInsets.only(left: 40),
                              child: pw.Row(
                                  mainAxisAlignment: pw.MainAxisAlignment.start,
                                  children: [
                                    pw.Text('${data['amount']}', style: pw.TextStyle()
                                    ),
                                    pw.Text("الجملة =  ",
                                        style: pw.TextStyle(
                                        )
                                    ),
                                  ]
                              ),
                            ),
                            pw.Divider(),
                          ]
                      )
                    ])
            );
          }));

  //print page as pdf
  await Printing.directPrintPdf(
      printer: Printer(url: 'Microsoft print to PDF'),
      onLayout: (PdfPageFormat format) async => doc.save()
  );
}
//EPSON TM-T20II Receipt
