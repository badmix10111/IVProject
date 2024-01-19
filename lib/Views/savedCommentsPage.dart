import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class ViewCommentsPage extends StatefulWidget {
  @override
  _ViewCommentsPageState createState() => _ViewCommentsPageState();
}

class _ViewCommentsPageState extends State<ViewCommentsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Comments'),
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
          child: _buildCommentsList(),
        ),
      ),
    );
  }

  Widget _buildCommentsList() {
    return FutureBuilder(
      future: _getComments(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No comments available'));
        } else {
          List<Map<String, dynamic>>? comments = snapshot.data;
          return ListView.builder(
            itemCount: comments!.length,
            itemBuilder: (context, index) {
              return _buildCommentBubble(comments[index], index);
            },
          );
        }
      },
    );
  }

  Widget _buildCommentBubble(Map<String, dynamic> comment, int index) {
    double rating = comment['rating'] ?? 0.0;

    return Card(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        title: Text('Comment: ${comment['comment']}'),
        subtitle: RatingBar.builder(
          initialRating: rating,
          minRating: 1,
          direction: Axis.horizontal,
          allowHalfRating: false,
          itemCount: 5,
          itemPadding: EdgeInsets.symmetric(horizontal: 2.0),
          itemBuilder: (context, _) => Icon(
            Icons.star,
            color: Colors.amber,
          ),
          onRatingUpdate: (newRating) {
            // Do something with the newRating if needed
          },
        ),
        trailing: IconButton(
          icon: Icon(Icons.delete),
          onPressed: () {
            _showDeleteConfirmationDialog(index);
          },
        ),
      ),
    );
  }

  Future<List<Map<String, dynamic>>> _getComments() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? existingComments = prefs.getString('comments');

      if (existingComments != null && existingComments.isNotEmpty) {
        List<Map<String, dynamic>> commentsList =
            List<Map<String, dynamic>>.from(
          jsonDecode(existingComments),
        );

        return commentsList;
      } else {
        return [];
      }
    } catch (e) {
      print('Error fetching comments: $e');
      return [];
    }
  }

  Future<void> _removeComment(int index) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      List<Map<String, dynamic>> commentsList = await _getComments();

      commentsList.removeAt(index);

      await prefs.setString('comments', jsonEncode(commentsList));

      setState(() {});
    } catch (e) {
      print('Error removing comment: $e');
    }
  }

  Future<void> _showDeleteConfirmationDialog(int index) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Comment'),
          content: Text('Are you sure you want to delete this comment?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _removeComment(index);
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}
