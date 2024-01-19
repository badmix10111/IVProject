import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:newprojectexperiment1/Config/keys.dart';

class GetWeather {
  static String apiKey = Configile.apiKey;

  static Future<Map<String, dynamic>?> getWeatherData(
      double latitude, double longitude) async {
    try {
      String weatherApiUrl =
          "http://api.weatherapi.com/v1/forecast.json?key=$apiKey&q=$latitude,$longitude&days=1&aqi=no&alerts=no"; //endpoint will usually be stored in db but for this purpose its hardcoded
      http.Response response = await http.get(Uri.parse(weatherApiUrl));

      if (response.statusCode == 200 && response.body != "[]") {
        // if response comes back positive
        return json.decode(response.body);
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }
}
