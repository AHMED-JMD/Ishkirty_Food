import 'package:intl/intl.dart';

String numberFormatter(dynamic number, {int? fractionDigits}) {
  if (number == null) return '';
  try {
    if (fractionDigits != null) {
      var fn = NumberFormat.decimalPattern('en_US')
        ..minimumFractionDigits = fractionDigits
        ..maximumFractionDigits = fractionDigits;
      return fn.format(number);
    } else {
      return NumberFormat.decimalPattern('en_US').format(number);
    }
  } catch (e) {
    return number.toString();
  }
}
