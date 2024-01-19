import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:newprojectexperiment1/Controllers/getJokesController.dart';
import 'package:newprojectexperiment1/Models/jokesModel.dart';

class JokeApp extends StatefulWidget {
  @override
  _JokeAppState createState() => _JokeAppState();
}

class _JokeAppState extends State<JokeApp> {
  // Declare a Future variable to hold the fetched joke
  late Future<Joke?> joke;

  // Variable to track whether a refresh is needed
  bool _shouldRefresh = false;

  // Instance of the controller class to fetch jokes
  JokesClass jokesClass = JokesClass();

  @override
  void initState() {
    super.initState();
    // Fetch the joke when the app initializes
    joke = jokesClass.fetchJoke();
  }

  // Function to handle manual refresh
  Future<void> _refresh() async {
    setState(() {
      joke = jokesClass.fetchJoke();
      _shouldRefresh = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'WANNA HEAR A JOKE ?',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.lightBlue,
      ),
      body: Container(
        color: Colors.blueGrey,
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder<Joke?>(
          future: joke,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              // Display loading indicator while waiting for the joke to load
              return const Center(
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              );
            } else if (snapshot.connectionState == ConnectionState.done &&
                snapshot.data == null) {
              // Display loading indicator if the joke data is null after loading
              return const Center(
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              );
            } else if (snapshot.hasError) {
              // Display an error message if there's an error fetching the joke
              return Center(
                child: Text('An error occurred, please try again.'),
              );
            } else {
              // Extract the joke data from the snapshot
              final jokeData = snapshot.data;

              if (jokeData!.setup == "" && !_shouldRefresh) {
                // Schedule a refresh after the build is complete
                WidgetsBinding.instance?.addPostFrameCallback((_) {
                  setState(() {
                    _shouldRefresh = true;
                  });
                  _refresh();
                });
                // Display loading indicator during the refresh
                return const Center(
                  child: CircularProgressIndicator(
                    color: Colors.white,
                  ),
                );
              } else {
                // Display the joke setup and punchline using animations
                return Center(
                  child: AnimationConfiguration.synchronized(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        // Bubble with joke setup
                        Card(
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Hero(
                              tag: 'jokeTag',
                              child: FadeInAnimation(
                                child: Text(
                                  jokeData?.setup ?? 'an error occurred',
                                  style: const TextStyle(
                                    fontSize: 20,
                                    color: Colors.black87,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Bubble with joke punchline
                        Hero(
                          tag: 'punchlineTag',
                          child: Card(
                            elevation: 5,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: SlideAnimation(
                                verticalOffset: 50.0,
                                child: FadeInAnimation(
                                  child: Text(
                                    jokeData?.delivery ?? 'An error occurred',
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blue,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }
            }
          },
        ),
      ),
      // FloatingActionButton for manual refresh
      floatingActionButton: FloatingActionButton(
        onPressed: _refresh,
        tooltip: 'Refresh',
        child: const Icon(
          Icons.refresh,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
