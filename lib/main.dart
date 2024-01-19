import 'package:flutter/material.dart';

import 'package:newprojectexperiment1/Views/homePage.dart';
import 'dart:async';

import 'package:newprojectexperiment1/Views/jokesPage.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Entry point of the Flutter application
Future<void> main() async {
  // Ensure Flutter is initialized
  WidgetsFlutterBinding.ensureInitialized();
  // Request location permissions before running the app
  await checkAndRequestLocationPermissions();
  // Run the main application
  runApp(const MyApp());
}

// Function to check and request location permissions
Future<void> checkAndRequestLocationPermissions() async {
  // Check if both fine and coarse location permissions are granted
  if (await Permission.location.isGranted) {
    // Permissions are already granted, proceed with location-related operations
  } else {
    // Request both fine and coarse location permissions
    Map<Permission, PermissionStatus> status = await [
      Permission.location,
      Permission.locationAlways,
      Permission.locationWhenInUse,
    ].request();

    // Check the status of the permissions after the request
    if (status[Permission.location]!.isGranted) {
      // Permissions granted, proceed with location-related operations
    } else {
      // If permissions are denied, recursively call the function to request again
      checkAndRequestLocationPermissions();
    }
  }
}

// Root widget of the application
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Welcome',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: const WelcomeScreen(),
    );
  }
}

// Welcome screen widget
class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0; // Page index
  final List<String> welcomeMessages = [
    'Welcome to My Application',
    'Explore Exciting Features!',
    'Get Ready for an Amazing Experience!',
    'Tap Below to Start!',
  ];

  @override
  void initState() {
    super.initState();
    // Add a listener to update the current page index when the page changes
    _pageController.addListener(() {
      setState(() {
        _currentPage = _pageController.page!.round();
      });
    });

    // Check if the user has opted to skip the welcome screen
    checkSkipWelcomeScreen();
  }

  // Function to check if the user has chosen to skip the welcome screen
  Future<void> checkSkipWelcomeScreen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? skipWelcomeScreen = prefs.getBool('skipWelcomeScreen');

    if (skipWelcomeScreen == true) {
      // Skip the welcome screen and navigate to HomeDashboard
      // ignore: use_build_context_synchronously
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => HomeDashboard(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // PageView to display the welcome messages
          PageView.builder(
            controller: _pageController,
            itemCount: welcomeMessages.length,
            itemBuilder: (context, index) {
              return WelcomePage(
                message: welcomeMessages[index],
                pageIndex: index,
              );
            },
          ),
          // Display page indicators at the bottom
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Indicator(
                count: welcomeMessages.length,
                currentIndex: _currentPage,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Indicator widget to display page indicators
class Indicator extends StatelessWidget {
  final int count;
  final int currentIndex;

  const Indicator({Key? key, required this.count, required this.currentIndex})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(
        count,
        (index) => Container(
          margin: const EdgeInsets.symmetric(horizontal: 4.0),
          width: currentIndex == index ? 16.0 : 8.0,
          height: 8.0,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: currentIndex == index ? Colors.blue : Colors.grey,
          ),
        ),
      ),
    );
  }
}

// WelcomePage widget to display individual welcome pages
class WelcomePage extends StatefulWidget {
  final String message;
  final int pageIndex;

  const WelcomePage({Key? key, required this.message, required this.pageIndex})
      : super(key: key);

  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    // Initialize animation controller and animation for fading in
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(_controller);
    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _animation,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue, Colors.deepPurple],
          ),
        ),
        child: Center(
          child: LayoutBuilder(
            builder: (context, constraints) {
              // Adjust font size based on screen width
              double fontSize = constraints.maxWidth < 600 ? 20.0 : 24.0;
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  // Display welcome message
                  Text(
                    widget.message,
                    style: TextStyle(
                      fontSize: fontSize,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  // Display animated button on the last page
                  if (widget.pageIndex == 3)
                    AnimatedButton(
                      onPressed: () async {
                        // Save boolean value in shared preferences
                        SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        await prefs.setBool('skipWelcomeScreen', true);
                        // Navigate to HomeDashboard after skipping welcome screen
                        // ignore: use_build_context_synchronously
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) => HomeDashboard(),
                          ),
                        );
                      },
                    ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    // Dispose of the animation controller when the widget is disposed
    _controller.dispose();
    super.dispose();
  }
}

// AnimatedButton widget for a button with fade-in animation
class AnimatedButton extends StatefulWidget {
  final VoidCallback onPressed;

  const AnimatedButton({Key? key, required this.onPressed}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _AnimatedButtonState createState() => _AnimatedButtonState();
}

class _AnimatedButtonState extends State<AnimatedButton> {
  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder(
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
      tween: Tween<double>(begin: 0, end: 1),
      builder: (_, double value, __) {
        // Apply opacity animation to the button
        return Opacity(
          opacity: value,
          child: ElevatedButton(
            onPressed: widget.onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.yellow,
            ),
            child: const Text(
              'Tap below to start!',
              style: TextStyle(color: Colors.black),
            ),
          ),
        );
      },
    );
  }
}

// MyHomePage widget for the main content of the application
class MyHomePage extends StatelessWidget {
  final String title;

  const MyHomePage({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Button to navigate to the last page
            ElevatedButton(
              onPressed: () async {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => JokeApp()),
                );
              },
              child: const Text('Go to Last Page'),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => JokeApp()),
          );
        },
        tooltip: 'Tell me a joke',
        child: const Icon(Icons.sentiment_very_satisfied),
      ),
    );
  }
}

// LastPage widget for the last page content
class LastPage extends StatelessWidget {
  const LastPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Last Page'),
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'This is the last page!',
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
