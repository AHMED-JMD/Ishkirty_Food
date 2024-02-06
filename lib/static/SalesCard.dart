import 'package:flutter/material.dart';
import 'my_icon_icons.dart';
import 'package:money_formatter/money_formatter.dart';

class SalesCard extends StatelessWidget {
  final String Period;
  final int CashAmount;
  final int BankakAmount;
  final int AccountsAmount;
  final String period;

  SalesCard({
    super.key,
    required this.Period,
    required this.CashAmount,
    required this.BankakAmount,
    required this.AccountsAmount,
    required this.period
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
          '$Period',
          style: TextStyle(fontSize: 35),
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
                size: 80,
              ),
              Text(
                '${MoneyFormatter(amount: CashAmount.toDouble()).output.withoutFractionDigits}',
                style: TextStyle(fontSize: 30),
              ),
            ]),
            Column(children: [
              const SizedBox(
                height: 15,
              ),
              const Icon(
                MyIcon.bankak,
                color: Color(0xffc90000),
                size: 80,
              ),
              Text(
                '${MoneyFormatter(amount: BankakAmount.toDouble()).output.withoutFractionDigits}',
                style: TextStyle(fontSize: 30),
              ),
            ]),
            Column(children: [
              const SizedBox(
                height: 15,
              ),
              const Icon(
                Icons.person_pin,
                size: 80,
                color: Color(0xff0c283f),
              ),
              Text(
                '${MoneyFormatter(amount: AccountsAmount.toDouble()).output.withoutFractionDigits}',
                style: TextStyle(fontSize: 30),
              ),
            ]),
          ],
        ),
        Divider(
          color: Colors.black,
        ),
        Center(
          child: Text('مبيعات $period', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),),
        )
      ],
    );
  }
}
