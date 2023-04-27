import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

final oCcy = new NumberFormat("#,##0.00", "en_US");

class ConversionCard extends StatelessWidget {
  final String crypto;
  final String currency;
  final double lastValue;

  ConversionCard({this.crypto, this.currency, this.lastValue});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.lightBlueAccent,
      elevation: 5.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
        child: Text(
          '1 $crypto = $currency ${oCcy.format(lastValue)}',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 20.0,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
