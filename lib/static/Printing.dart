import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class PrintPage extends StatefulWidget {
  const PrintPage({super.key});

  @override
  State<PrintPage> createState() => _PrintPageState();
}

class _PrintPageState extends State<PrintPage> {
  Uint8List? logobytes;
  PdfImage? _logoImage;
  final doc = pw.Document();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    fetch();
  }
  fetch() async {
    ByteData _bytes = await rootBundle.load('assets/avatar.png');
    logobytes = _bytes.buffer.asUint8List();
    setState(() {
      try {
        _logoImage = PdfImage.file(
          doc.document,
          bytes: logobytes!,
        );
      } catch (e) {
        print("catch--  $e");
        logobytes = null;
        _logoImage = null;
      }
    });
  }

  pw.Container createTableCell(String text) {
    return pw.Container(
      child: pw.Text(text),
      alignment: pw.Alignment.center,
      // verticalAlignment: pw.TableCellVerticalAlignment.middle,
    );
  }

  pw.Table createTable() {
    return pw.Table(
      border: pw.TableBorder.all(),
      defaultColumnWidth: pw.IntrinsicColumnWidth(),
      children: [
        pw.TableRow(
          children: [
            createTableCell('Name'),
            createTableCell('Age'),
            createTableCell('City'),
          ],
        ),
        pw.TableRow(
          children: [
            createTableCell('John Doe'),
            createTableCell('30'),
            createTableCell('New York'),
          ],
        ),
        pw.TableRow(
          children: [
            createTableCell('Jane Smith'),
            createTableCell('25'),
            createTableCell('London'),
          ],
        ),
      ],
    );
  }

  //print future function
  Future<void> Print() async {
    //create pdf
    doc.addPage(
        pw.Page(
            pageFormat: PdfPageFormat.a4,
            build: (pw.Context context) {
              return pw.Directionality(
                textDirection: pw.TextDirection.rtl,
                child: createTable()
              );
            }));

    //print page as pdf
    await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => doc.save());
  }

  @override
  Widget build(BuildContext context) {
    return  TextButton.icon(
      onPressed: (){
        Print();
      },
      icon: Icon(Icons.print),
      label: Text('طباعة'),
      style: TextButton.styleFrom(
          backgroundColor: Colors.grey[400],
          primary: Colors.black
      ),
    );
  }
}


