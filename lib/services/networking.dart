import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class NetworkHelper {
  final String crypto;
  final String currency;

  NetworkHelper({this.crypto, this.currency});

  Future getData() async {
    // Getting API Authorization Key from flutter_dotenv Environment Variables
    String apiAuth = dotenv.env['API_AUTH'];

    var url = Uri.https(
      'apiv2.bitcoinaverage.com',
      '/indices/global/ticker/$crypto$currency',
    );

    // Checking the full URL
    print(url);

    http.Response response = await http.get(
      url,
      headers: {
        'x-ba-key': apiAuth,
      },
    );

    if (response.statusCode == 200) {
      String data = response.body;
      return jsonDecode(data);
    } else {
      print('ERROR: ' + (response.statusCode).toString());
    }
  }
}
