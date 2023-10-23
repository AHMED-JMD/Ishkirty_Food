import 'package:flutter/material.dart';
import 'package:ashkerty_food/models/Bill.dart';
import 'my_icon_icons.dart';
class PaymentMethodSelector extends StatefulWidget {
  const PaymentMethodSelector({super.key});
  @override
  State<PaymentMethodSelector> createState() => _PaymentMethodSelectorState();
}
class _PaymentMethodSelectorState extends State<PaymentMethodSelector> {
@override
Widget build(BuildContext context) {
  return  Row(mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisSize: MainAxisSize.max,
children: <Widget>[
  IconButton.outlined(onPressed: () {},
    icon: const Icon(Icons.attach_money_rounded,size: 60,color: Color(0xff1b3b0b),),),
  const SizedBox(width: 70,),
  IconButton(onPressed: () {},
    icon: const Icon(MyIcon.bankak,size: 60,color: Color(0xffc90000),),),
  const SizedBox(width: 70,),
  IconButton(onPressed: () {},
    icon: const Icon(Icons.person_pin,size: 60,color: Color(0xff0c283f),),),
]
    );

}
  }



