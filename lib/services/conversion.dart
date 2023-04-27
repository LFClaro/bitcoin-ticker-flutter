import 'networking.dart';

class ConversionModel {
  Future<dynamic> getConversion(String crypto, String currency) async {
    NetworkHelper networkHelper =
        NetworkHelper(crypto: crypto, currency: currency);

    var conversionData = await networkHelper.getData();
    return conversionData;
  }
}
