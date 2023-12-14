import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'my_icon_icons.dart';

class PaymentMethodSelector extends StatefulWidget {
  const PaymentMethodSelector({super.key});
  @override
  State<PaymentMethodSelector> createState() => _PaymentMethodSelectorState();
}

class _PaymentMethodSelectorState extends State<PaymentMethodSelector> {
  //list of payment methods
  List PaymentMethod = ['Bankk', 'Cash', 'Account'];
  int? CurrentPaymentMethod = 1;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FormBuilderRadioGroup(
          name: 'payment_method',
          decoration: InputDecoration(
              labelText: 'طرق الدفع', contentPadding: EdgeInsets.all(10.0)),
          options: [
            FormBuilderFieldOption(value: 'كاش'),
            FormBuilderFieldOption(value: 'بنكك'),
            FormBuilderFieldOption(value: 'حساب'),
          ],
        ),

      ],
    );

}
  }



