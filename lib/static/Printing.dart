import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class PrintPage extends StatefulWidget {
  final Map data;
  PrintPage({super.key, required this.data});

  @override
  State<PrintPage> createState() => _PrintPageState();
}

class _PrintPageState extends State<PrintPage> {
  Uint8List? logobytes;
  PdfImage? _logoImage;
  ByteData? image;
  ByteData? myFont;
  final doc = pw.Document();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetch();
  }

  fetch() async {
    ByteData _bytes = await rootBundle.load('assets/images/ef1.jpg');
    ByteData font = await rootBundle.load("assets/fonts/Cairo-Bold.ttf");

    logobytes = _bytes.buffer.asUint8List();

    setState(() {
      try {
        _logoImage = PdfImage.file(
          doc.document,
          bytes: logobytes!,
        );
        myFont = font;
        image = _bytes;
      } catch (e) {
        print("catch--  $e");
        logobytes = null;
        _logoImage = null;
      }
    });
  }

  pw.Directionality createTableCell(String text) {
    return pw.Directionality(
        textDirection: pw.TextDirection.rtl,
        child: pw.Container(
          child: pw.Text(text,
              style: pw.TextStyle(
                font: pw.Font.ttf(myFont!),
              )),
          alignment: pw.Alignment.center,
          // verticalAlignment: pw.TableCellVerticalAlignment.middle,
        ));
  }

  pw.Directionality createTable() {
    return pw.Directionality(
        textDirection: pw.TextDirection.rtl,
        child: pw.Table(
          border: pw.TableBorder.all(),
          defaultColumnWidth: pw.IntrinsicColumnWidth(),
          children: [
            pw.TableRow(
              children: [
                createTableCell('الصنف'),
                createTableCell('الكمية'),
                createTableCell('السعر'),
                createTableCell('اجمالي'),
              ],
            ),
            if (widget.data['trans'].length != 0)
              ...widget.data['trans'].map(
                (name) => pw.TableRow(
                  children: [
                    createTableCell(name.spices),
                    createTableCell(name.counter.toString()),
                    createTableCell(name.unit_price.toString()),
                    createTableCell(name.total_price.toString()),
                  ],
                ),
              )
          ],
        ));
  }

  //print future function
  Future<void> Print() async {
    //create pdf
    doc.addPage(pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Directionality(
              textDirection: pw.TextDirection.rtl,
              child: pw.ListView(children: [
                pw.Column(
                    mainAxisAlignment: pw.MainAxisAlignment.center,
                    children: [
                      pw.Text('${DateTime.now().toIso8601String()}'),
                      pw.SizedBox(height: 10),
                      pw.Text('number 12',
                          style: pw.TextStyle(
                              fontSize: 20, fontWeight: pw.FontWeight.bold)),
                      pw.PdfLogo(),
                      pw.SizedBox(height: 20),
                      pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.spaceEvenly,
                          children: [
                            pw.Text(
                                "طريقة الدفع = ${widget.data['paymentMethod']}",
                                style: pw.TextStyle(
                                  font: pw.Font.ttf(myFont!),
                                )),
                            pw.Text("الوردية = ${widget.data['shiftTime']}",
                                style: pw.TextStyle(
                                  font: pw.Font.ttf(myFont!),
                                )),
                          ]),
                      pw.SizedBox(height: 20),
                      createTable(),
                      pw.SizedBox(height: 10),
                      pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.end,
                          children: [
                            pw.Text("قيمة الفاتورة = ${widget.data['amount']} ",
                                style: pw.TextStyle(
                                  font: pw.Font.ttf(myFont!),
                                ))
                          ]),
                    ])
              ]));
        }));

    //print page as pdf
    await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => doc.save());
  }

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: () {
        Print();
      },
      icon: Icon(Icons.print),
      label: Text('طباعة'),
      style: TextButton.styleFrom(
          backgroundColor: Colors.grey[400], primary: Colors.black),
    );
  }
}
