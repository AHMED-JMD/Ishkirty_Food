import 'package:ashkerty_food/static/formatter.dart';
import 'package:flutter/material.dart';
import 'my_icon_icons.dart';
// import 'package:money_formatter/money_formatter.dart';

class SalesCard extends StatelessWidget {
  final String period;
  final int cashAmount;
  final int bankakAmount;
  final int accountsAmount;

  SalesCard({
    super.key,
    required this.period,
    required this.cashAmount,
    required this.bankakAmount,
    required this.accountsAmount,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const SizedBox(
          height: 5,
        ),
        Center(
            child: Text(
          period,
          style: const TextStyle(fontSize: 20),
        )),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(children: [
              const SizedBox(
                height: 15,
              ),
              const Icon(
                Icons.attach_money_rounded,
                color: Color(0xff1b3b0b),
                size: 50,
              ),
              Text(
                numberFormatter(cashAmount),
                style: const TextStyle(fontSize: 20),
              ),
            ]),
            Column(children: [
              const SizedBox(
                height: 15,
              ),
              const Icon(
                MyIcon.bankak,
                color: Color(0xffc90000),
                size: 50,
              ),
              Text(
                numberFormatter(bankakAmount),
                style: const TextStyle(fontSize: 20),
              ),
            ]),
            Column(children: [
              const SizedBox(
                height: 15,
              ),
              const Icon(
                Icons.person_pin,
                size: 50,
                color: Color(0xff0c283f),
              ),
              Text(
                numberFormatter(accountsAmount),
                style: const TextStyle(fontSize: 20),
              ),
            ]),
          ],
        ),
        const SizedBox(
          height: 20,
        ),
        // const Divider(
        //   color: Colors.black,
        // ),
        // Center(
        //   child: Text(
        //     'مبيعات $period',
        //     style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        //   ),
        // )
      ],
    );
  }
}
