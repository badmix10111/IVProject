import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:newprojectexperiment1/Models/jokesModel.dart';

class JokesClass {
  Future<Joke?> fetchJoke() async {
    try {
      final response = await http.get(Uri.parse(
          "https://v2.jokeapi.dev/joke/Any")); //endpoint would be stored in db but for this purpose its hardcoded

      if (response.statusCode == 200 && response.body != "[]") {
        // if response comes back positive
        return Joke.fromJson(jsonDecode(response.body));
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }
}
