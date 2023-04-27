import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../services/coin_data.dart';
import '../services/conversion.dart';
import '../components/conversion_card.dart';

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  ConversionModel conversion = ConversionModel();

  String currency = 'CAD';
  Map<String, double> lastValues = {};

  @override
  void initState() {
    super.initState();
    // Load conversion data as soon as StatefulWidget gets created
    updateUI();
  }

  void updateUI() async {
    for (String c in cryptoList) {
      try {
        var conversionData = await conversion.getConversion(c, currency);
        setState(() {
          lastValues[c] = conversionData['last'];
        });
      } catch (e) {
        print(e);
      }
    }
  }

  List<Widget> getCryptoCards() {
    List<Widget> cryptoCards = [];
    for (String c in cryptoList) {
      var newCard = ConversionCard(
        crypto: c,
        currency: currency,
        lastValue: lastValues[c] ?? 0,
      );
      cryptoCards.add(newCard);
    }
    return cryptoCards;
  }

  DropdownButton<String> androidDropdown() {
    List<DropdownMenuItem<String>> dropdownItems = [];
    for (String c in currenciesList) {
      var newItem = DropdownMenuItem(
        child: Text(c),
        value: c,
      );
      dropdownItems.add(newItem);
    }
    return DropdownButton<String>(
      value: currency,
      items: dropdownItems,
      onChanged: (value) {
        setState(() {
          currency = value;
          updateUI();
        });
      },
    );
  }

  // DropdownButton is a very Android-style Widget; Apple uses Picker.
  NotificationListener iosPicker() {
    List<Widget> pickerItems = [];
    for (String c in currenciesList) {
      pickerItems.add(Text(c));
    }

    // Calling a NotificationListener otherwise there'll be an API call every
    // time the Selected Item is changed on CupertinoPicker
    return NotificationListener<ScrollNotification>(
      onNotification: (scrollNotification) {
        if (scrollNotification is ScrollEndNotification &&
            scrollNotification.metrics is FixedExtentMetrics) {
          final selectedIndex =
              (scrollNotification.metrics as FixedExtentMetrics)
                  .itemIndex; // Index of the list
          currency = currenciesList[selectedIndex];
          updateUI();
          return true;
        } else {
          return false;
        }
      },
      child: CupertinoPicker(
        itemExtent: 32.0,
        scrollController: FixedExtentScrollController(initialItem: 2),
        onSelectedItemChanged:
            null, // updateUI() is called on NotificationListener
        children: pickerItems,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('🤑 Coin Ticker'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: getCryptoCards(),
            ),
          ),
          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: EdgeInsets.only(bottom: 30.0),
            color: Colors.lightBlue,
            child: Platform.isIOS ? iosPicker() : androidDropdown(),
          ),
        ],
      ),
    );
  }
}
