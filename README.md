
Flutter App Readme
MyAwesomeApp
Welcome to MyAwesomeApp, a Flutter application designed to provide you with weather information and some extra fun features!
Table of Contents
* 		Introduction
* 		Features
* 		Getting Started
* 		Dependencies
* 		Usage
* 		APIs Used
* 		Permissions
* 		Data Storage
* 		Contributing
* 		License
Introduction
MyAwesomeApp is a Flutter application that combines weather information with a touch of humor. Upon the first use, you are welcomed by a splash screen, guiding you through the app's functionalities. Afterward, you land on a homepage displaying weather details for your location.
Features
* 		Splash Screen:
    * A welcoming splash screen is displayed only on the first use to guide users through the app.
* 		Weather Information:
    * Real-time weather information is fetched using the WeatherAPI.
    * The app uses latitude and longitude to provide accurate weather details for your location.
* 		Extra Options:
        * Random Joke:
        * Fetch a random joke from the JokeAPI.
        * Comments for Dev:
        * Add comments for the developer.
        * Delete previously added comments.
Getting Started
* 		Clone the repository:bashCopy codegit clone https://github.com/your-username/MyAwesomeApp.git
* 		
* 		Navigate to the project folder:bashCopy codecd MyAwesomeApp
* 		
* 		Install dependencies:bashCopy codeflutter pub get
* 		
* 		Run the app:bashCopy codeflutter run
* 		
Dependencies
* Flutter
* Dart
Usage
Follow the on-screen instructions during the first use to get acquainted with the app. After the splash screen, you'll land on the homepage displaying weather information. Use the extra options to enjoy random jokes or leave comments for the developer.
APIs Used
* 		WeatherAPI:
    * WeatherAPI Documentation
* 		JokeAPI:
    * JokeAPI Documentation
Permissions
    * Location Permission:
    * The app requires location permission to fetch accurate weather details based on latitude and longitude.
Data Storage
    * Shared Preferences:
    * The app stores necessary data using shared preferences, ensuring a seamless experience across sessions.
