import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import 'package:newprojectexperiment1/Config/keys.dart';
import 'package:newprojectexperiment1/Controllers/weatherController.dart';
import 'package:newprojectexperiment1/Helpers/alertHelper.dart';

import 'package:newprojectexperiment1/Views/jokesPage.dart';
import 'package:newprojectexperiment1/Views/leaveACommentPage.dart';
import 'package:newprojectexperiment1/Views/savedCommentsPage.dart';

// Define a WeatherService class to handle weather-related data.
class WeatherService {
  final String apiKey;

  WeatherService(this.apiKey);
}

// HomeDashboard class, responsible for creating the main application widget.
class HomeDashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

// HomePage class, represents the main page of the application.
class HomePage extends StatelessWidget {
  // Create an instance of WeatherService with the API key.
  final WeatherService weatherService = WeatherService(Configile.apiKey);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Dashboard',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.lightBlue,
      ),
      body: FutureBuilder(
        future: _getLocationAndWeatherData(context),
        builder: (context, snapshot) {
          // Handle different states of the Future (loading, error, data).
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            // Build the UI based on weather data.
            return _buildWeatherUI(snapshot.data, context);
          }
        },
      ),
    );
  }

  // Fetches location and weather data asynchronously.
  Future<Future<Map<String, dynamic>?>?> _getLocationAndWeatherData(
      context) async {
    Position? currentPosition;
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      await Geolocator.requestPermission();
    }

    currentPosition = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.best,
    );

    if (currentPosition != null && currentPosition != "") {
      // Get weather data based on current location.
      return GetWeather.getWeatherData(
        currentPosition.latitude,
        currentPosition.longitude,
      );
    } else {
      // Handle the case when the location is not available.
      AlertsClass alertsClass = AlertsClass();
      alertsClass.ResponseMessageHandler(
          context, "An error occurred. Please try again later");
      return null;
    }
  }

  // Builds the UI based on the retrieved weather data.
  Widget _buildWeatherUI(weatherDataFuture, context) {
    return FutureBuilder<Map<String, dynamic>?>(
        future: weatherDataFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            // Extract weather information from the data.
            Map<String, dynamic>? weatherData = snapshot.data;
            String weatherConditionIcon = "";
            String cityName = "";
            var cityTemp;

            if (weatherData != null) {
              if (weatherData.containsKey('location') &&
                  weatherData['location'].containsKey('name')) {
                cityName = weatherData['location']['name'];
              }
              if (weatherData.containsKey('current') &&
                  weatherData['current'].containsKey('temp_c')) {
                cityTemp = weatherData['current']['temp_c'];
              }

              weatherConditionIcon =
                  "http:${weatherData['current']['condition']['icon']}";
            }

            // Build the main UI layout.
            return Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.blue, Colors.white],
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    // Display weather information.
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        const Center(
                          child: Text(
                            "The current weather at your location ",
                            style: TextStyle(fontSize: 20, color: Colors.white),
                          ),
                        ),
                        const SizedBox(
                          height: 50,
                        ),
                        // Display weather condition icon.
                        if (weatherConditionIcon.isNotEmpty)
                          CachedNetworkImage(
                            imageUrl: weatherConditionIcon,
                            placeholder: (context, url) =>
                                const CircularProgressIndicator(),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
                          ),
                        const SizedBox(height: 20),
                        // Display city name.
                        if (cityName.isNotEmpty)
                          Text(
                            'City: $cityName',
                            style: const TextStyle(
                                fontSize: 18, color: Colors.white),
                          ),
                        const SizedBox(height: 20),
                        // Display temperature.
                        if (cityTemp != null)
                          Text(
                            'Temperature: $cityTemp °C',
                            style: const TextStyle(
                                fontSize: 18, color: Colors.white),
                          ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    const Divider(color: Colors.white),
                    const SizedBox(height: 50),
                    // Additional options and button to explore jokes.
                    const Center(
                      child: Text(
                        "More options ? ",
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ),
                    ),
                    const SizedBox(height: 50),
                    ElevatedButton(
                      onPressed: () {
                        // Navigate to the JokeApp page.
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => JokeApp()),
                        );
                      },
                      child: const Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Text(
                          'Explore jokes',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        // Navigate to the JokeApp page.
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CommentsScreen()),
                        );
                      },
                      child: const Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Text(
                          'Leave a comment',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        // Navigate to the JokeApp page.
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ViewCommentsPage(),
                          ),
                        );
                      },
                      child: const Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Text(
                          'View previous comments',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
        });
  }
}
