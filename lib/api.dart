
import 'dart:async';
import 'dart:convert' show utf8,json;
import 'dart:io';
import 'unit.dart';

/// The REST API retrieves unit conversions for [Categories] that change.
///
/// For example, the currency exchange rate, stock prices, the height of the
/// tides change often.
/// We have set up an API that retrieves a list of currencies and their current
/// exchange rate (mock data).
///   GET /currency: get a list of currencies
///   GET /currency/convert: get conversion from one currency amount to another
class Api {

  static final httpClient = HttpClient();
  static final url = 'flutter.udacity.com';

  static Future<double> convert(String category, String amount, String fromUnit,
      String toUnit) async {
    final uri = Uri.https(url, '$category/convert',
        {'amount': amount, 'from': fromUnit, 'to': toUnit});

    try {
      final httpRequest = await httpClient.getUrl(uri);
      try {
        final httpResponse = httpRequest.close();
        final respons = await httpResponse;
        final responseBody = await respons.transform(utf8.decoder).join();
        final jsonResponse = json.decode(responseBody);
        return jsonResponse['conversion'].toDouble();
      } catch (e) {
        print(e);
        return null;
      }
    }
      catch (e) {
      print(e);
      return null;
    }


  }


  static Future<List<Unit>> getUnits(String category) async {
    final uri = Uri.https(url, '$category');

    final httpRequest = await httpClient.getUrl(uri);
    final httpResponse = httpRequest.close();
    final respons = await httpResponse;
    final responseBody = await respons.transform(utf8.decoder).join();
    final jsonResponse = json.decode(responseBody);

    final elements = jsonResponse['units'];
    var units = <Unit>[];
    for (var e in elements) {
      String co=e['conversion'].toString();
      if (co.indexOf('.')<0) co+='.0';
      var conv=double.parse(co);
      units.add(Unit(name: e['name'], conversion: conv));
    }

    return units;
  }

}

