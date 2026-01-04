import 'package:intl/intl.dart';

String numberFormatter(number) {
  return NumberFormat.decimalPattern('en_US').format(number);
}
