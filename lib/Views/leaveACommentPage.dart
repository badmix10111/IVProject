import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:newprojectexperiment1/Helpers/alertHelper.dart';
import 'package:newprojectexperiment1/Views/savedCommentsPage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CommentsScreen extends StatefulWidget {
  @override
  _CommentsScreenState createState() => _CommentsScreenState();
}

class _CommentsScreenState extends State<CommentsScreen> {
  TextEditingController _commentController = TextEditingController();
  double _starRating = 0.0;
  AlertsClass alertsClass = AlertsClass();
  void _submitComment() async {
    // Validate that both comment and rating are provided
    if (_commentController.text.isNotEmpty && _starRating != 0.0) {
      String comment = _commentController.text;

      // Use try-catch block for error handling
      try {
        SharedPreferences prefs = await SharedPreferences.getInstance();

        List<Map<String, dynamic>> commentsList = [];

        // Retrieve existing comments
        String? existingComments = prefs.getString('comments');
        if (existingComments != null && existingComments.isNotEmpty) {
          commentsList = List<Map<String, dynamic>>.from(
            jsonDecode(existingComments),
          );
        }

        // Add new comment to the list
        Map<String, dynamic> newComment = {
          'comment': comment,
          'rating': _starRating,
        };
        commentsList.add(newComment);

        // Save the updated comments list to shared preferences
        prefs.setString('comments', jsonEncode(commentsList));

        // Reset comment controller and star rating
        _commentController.clear();
        setState(() {
          _starRating = 0.0;
        });

        // Show a success dialog
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return _buildSuccessDialog(context);
          },
        );

        // Close the CommentsScreen after submission
        // Navigator.pop(context);
      } catch (e) {
        // Handle exceptions, e.g., SharedPreferences errors
        print('Error: $e');
        alertsClass.ResponseMessageHandler(
          context,
          'An error occurred while submitting the comment.',
        );
      }
    } else {
      // Show an error message if fields are empty
      alertsClass.ResponseMessageHandler(
        context,
        'Fields cannot be left empty',
      );
    }
  }

  Widget _buildSuccessDialog(BuildContext context) {
    return Dialog(
      child: Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.check_circle,
              color: Colors.green,
              size: 50,
            ),
            SizedBox(height: 16.0),
            Text(
              'Comment submitted successfully!',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: Text('OK'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Comments Screen'),
        centerTitle: true,
        backgroundColor: Color.fromARGB(255, 221, 244, 255),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.lightBlue[200]!.withOpacity(0.7),
              Colors.lightBlue[400]!,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: _commentController,
                decoration: InputDecoration(
                  labelText: 'Enter your comment',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16.0),
              Row(
                children: [
                  Text('Rate:'),
                  SizedBox(width: 8.0),
                  RatingBar(
                    onRatingChanged: (rating) {
                      setState(() {
                        _starRating = rating;
                      });
                    },
                    filledIcon: Icons.star,
                    emptyIcon: Icons.star_border,
                    initialRating: _starRating,
                    filledColor: Colors.amber,
                  ),
                ],
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _submitComment,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.lightBlue,
                ),
                child: Text('Submit Comment'),
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ViewCommentsPage(),
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 103, 225, 207),
                ),
                child: Text('Previous Comments'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showComments(BuildContext context) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? existingComments = prefs.getString('comments');

      if (existingComments != null && existingComments.isNotEmpty) {
        List<Map<String, dynamic>> commentsList =
            List<Map<String, dynamic>>.from(jsonDecode(existingComments));

        print('All Comments:');
        for (var comment in commentsList) {
          print('Comment: ${comment['comment']}, Rating: ${comment['rating']}');
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No comments available')),
        );
      }
    } catch (e) {
      // Handle exceptions, e.g., SharedPreferences errors
      print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred while fetching comments')),
      );
    }
  }
}

class RatingBar extends StatelessWidget {
  final IconData filledIcon;
  final IconData emptyIcon;
  final double initialRating;
  final ValueChanged<double> onRatingChanged;
  final Color filledColor;

  RatingBar({
    required this.filledIcon,
    required this.emptyIcon,
    required this.initialRating,
    required this.onRatingChanged,
    required this.filledColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(
        5,
        (index) {
          return IconButton(
            onPressed: () => onRatingChanged(index + 1.0),
            icon: Icon(
              index < initialRating ? filledIcon : emptyIcon,
              color: index < initialRating ? filledColor : Colors.grey,
            ),
          );
        },
      ),
    );
  }
}
