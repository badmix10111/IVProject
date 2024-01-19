import 'package:flutter/material.dart';
import 'package:restart_app/restart_app.dart';

class SomethingWentWrongScreen extends StatelessWidget {
  const SomethingWentWrongScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            "assets/errorimage.png", // Display an error image
            fit: BoxFit.cover,
          ),
          Positioned(
            bottom: MediaQuery.of(context).size.height * 0.15,
            left: MediaQuery.of(context).size.width * 0.3,
            right: MediaQuery.of(context).size.width * 0.3,
            child: TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
                padding: const EdgeInsets.all(16.0),
                textStyle: const TextStyle(fontSize: 20),
                backgroundColor: Colors.green,
              ),
              onPressed: () {
                Restart
                    .restartApp(); // Restart the app when the button is pressed
              },
              child:
                  const Text('Refresh'), // Display "Refresh" text on the button
            ),
          )
        ],
      ),
    );
  }
}
