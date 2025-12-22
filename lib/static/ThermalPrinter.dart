// import 'package:flutter/material.dart';
// import 'dart:async';
// import 'dart:developer';
// import 'dart:io';
// import 'package:flutter/services.dart';
// import 'package:thermal_printer/esc_pos_utils_platform/esc_pos_utils_platform.dart';
// import 'package:thermal_printer/thermal_printer.dart';
// import 'package:image/image.dart' as img;
//
//
// class InstantPrint extends StatefulWidget {
//   const InstantPrint({super.key});
//
//   @override
//   State<InstantPrint> createState() => _InstantPrintState();
// }
//
// class _InstantPrintState extends State<InstantPrint> {
//   var defaultPrinterType = PrinterType.usb;
//   var devices = <BluetoothPrinter>[];
//   var printerManager = PrinterManager.instance;
//   StreamSubscription<PrinterDevice>? _subscription;
//
//
//   // method to scan devices usb
//   void _scan() {
//     devices.clear();
//     _subscription = printerManager.discovery(type: defaultPrinterType, isBle: false).listen((device) {
//       devices.add(BluetoothPrinter(
//         deviceName: device.name,
//         vendorId: device.vendorId,
//         productId: device.productId,
//         typePrinter: PrinterType.usb,
//       ));
//       setState(() {});
//     });
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//     return const Placeholder();
//   }
// }
