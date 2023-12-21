import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'my_icon_icons.dart';

class SalesCard extends StatelessWidget {
  @override
  NumberFormat myFormat = NumberFormat.decimalPattern('en_us');
  final String Period;
  final int CashAmount;
  final int BankakAmount;
  final int AccountsAmount;
  SalesCard({super.key, required this.Period, required this.CashAmount, required this.BankakAmount, required this.AccountsAmount,});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
            const SizedBox(height: 5,),
            Center(
                child: Text('$Period', style: TextStyle(fontSize: 35),)),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
                children: [
                  const SizedBox(height: 15,),
                  const Icon(
                    Icons.attach_money_rounded,
                    color: Color(0xff1b3b0b),
                    size: 80,
                  ),
                Text(myFormat.format(CashAmount),style: TextStyle(fontSize: 30),),
                ]
            ),
          Column(
            children: [
              const SizedBox(height: 15,),
              const Icon(
                MyIcon.bankak,
                color: Color(0xffc90000),
                size: 80,
              ),
              Text(myFormat.format(BankakAmount),style: TextStyle(fontSize: 30),),
            ]
        ),
          Column(
            children: [
              const SizedBox(height: 15,),
              const Icon(
                Icons.person_pin,
                size: 80,
                color: Color(0xff0c283f),
              ),
              Text(myFormat.format(AccountsAmount),style: TextStyle(fontSize: 30),),
            ]
        ),
          ],
        ),
        Divider(color: Colors.black,),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
              SizedBox(width: 10,),
            Text("التحويلات = ",style: TextStyle(fontSize: 30),),
            SizedBox(width: 20,),
            Text('5,000',style: TextStyle(fontSize: 30),),
          ],
        ),
      ],
    );
  }
}



