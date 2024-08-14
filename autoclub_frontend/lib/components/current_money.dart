import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MoneyDisplay extends StatelessWidget {
  final int money;

  MoneyDisplay({required this.money});

  @override
  Widget build(BuildContext context) {
    final moneyFormat = NumberFormat.currency(symbol: '\$', decimalDigits: 0);

    return Container(
      padding: const EdgeInsets.fromLTRB(50, 10, 50, 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 8.0,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.wallet,
            color: Colors.black,
          ),
          SizedBox(width: 20),
          Text(
            moneyFormat.format(money),
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
          )
        ],
      ),
    );
  }
}
