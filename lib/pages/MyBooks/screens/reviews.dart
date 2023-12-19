import 'package:bookbuffet/main.dart';
import 'package:bookbuffet/pages/MyBooks/models/bookReview.dart';
import 'package:bookbuffet/pages/catalog/models/book.dart';
import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:get/get_connect/http/src/request/request.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:bookbuffet/pages/MyBooks/utils/review_card.dart';
import 'package:bookbuffet/pages/MyBooks/models/bookReview.dart';

import 'package:bookbuffet/pages/MyBooks/models/Mybook.dart';
import 'package:bookbuffet/pages/MyBooks/models/Review.dart';

class ReviewPage extends StatefulWidget {
  final BookReview book;
  const ReviewPage({super.key, required this.book});

  @override
  ReviewState createState() => ReviewState();
}

class ReviewState extends State<ReviewPage> {
  late BookReview book;
  late String username;
  final _reviewController = TextEditingController();
  int? _rating;
  @override
  void initState() {
    super.initState();
    book = widget.book;
  }

  Future<void> _addReview() async {
    final request = Provider.of<CookieRequest>(context, listen: false);

    // print(request.jsonData['username']);
    // print("tes");
    // username = request['username'];

    var response = await request.postJson(
        'https://bookbuffet.onrender.com/MyBooks/add-review-flutter/${book.pk}/',
        jsonEncode(<String, String>{
          'review': _reviewController.text,
          'rating': _rating.toString(),
        }));

    if (response['status'] == 'success') {
      // Handle successful response
      // Optionally, clear the text field and update the state
      _reviewController.clear();
      setState(() {});
    } else {
      // Handle error
    }
  }

  void _showAddReviewSheet() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Add Your Review"),
              TextField(
                controller: _reviewController,
                decoration: InputDecoration(
                  labelText: "Review",
                ),
              ),
              // Add a widget here to capture the rating
              // e.g., a row of icons that the user can tap
              DropdownButton<int>(
                value: _rating,
                hint: Text("Select Rating"),
                onChanged: (newValue) {
                  setState(() {
                    _rating = newValue!;
                  });
                },
                items: List.generate(
                        6, (index) => index) // Generate ratings from 0 to 5
                    .map<DropdownMenuItem<int>>((int value) {
                  return DropdownMenuItem<int>(
                    value: value,
                    child: Text(value.toString() + " ⭐"),
                  );
                }).toList(),
              ),
              ElevatedButton(
                onPressed: () {
                  _addReview();
                  Navigator.pop(context); // Close the bottom sheet
                },
                child: Text("Submit Review"),
              ),
            ],
          ),
        );
      },
    );
  }

  void _delete() async {
    final request = Provider.of<CookieRequest>(context, listen: false);
    final response = await request.postJson(
      'https://bookbuffet.onrender.com/MyBooks/show-review/delete-review-flutter/${book.pk}/',
      jsonEncode({
        "book_id": book.pk,
      }),
    );
  }

  // Future<Review> getUserReview() async {
  //   final request = Provider.of<CookieRequest>(context, listen: false);
  //   var response = await request.get(
  //       'http://127.0.0.1:8000/MyBooks/show-review/get-reviews-flutter/${book.pk}');
  //   var data = jsonEncode(response);
  //   if (response != null) {
  //     final review = Review.fromJson(data as Map<String, dynamic>);
  //     return review;
  //   } else {
  //     throw Exception('Failed');
  //   }
  // }

  Future<List<Review>> getReviews() async {
    var url = Uri.parse(
        'https://bookbuffet.onrender.com/MyBooks/show-review/get-reviews-flutter/${book.pk}');
    var response = await http.get(
      url,
      headers: {"Content-Type": "application/json"},
    );
    var data = jsonDecode(utf8.decode(response.bodyBytes));

    // ignore: non_constant_identifier_names
    List<Review> list_review = [];
    for (var d in data) {
      if (d != null) {
        list_review.add(Review.fromJson(d));
      }
    }
    return list_review;
  }

  @override
  Widget build(BuildContext context) {
    final request = Provider.of<CookieRequest>(context, listen: false);
    String username = request.jsonData['username'];

    return Scaffold(
      body: FutureBuilder<List<Review>>(
        future: getReviews(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }
          //  else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          //   return Center(child: Text("No reviews available"));
          // }

          List<Review> reviews = snapshot.data!;
          double totalRating =
              reviews.fold(0, (sum, item) => sum + item.fields.rating);
          double average = totalRating / reviews.length;
          Review? userReview;
          bool hasReview = false;

          for (Review review in reviews) {
            if (review.fields.username == username) {
              hasReview = true;
              userReview = review;
            }
            ;
          }
          Widget imageWidget = Padding(
            padding: const EdgeInsets.all(10.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image.network(
                "https://bookbuffet.onrender.com/media/" + book.fields.cover,
                fit: BoxFit.cover,
                errorBuilder: (BuildContext context, Object exception,
                    StackTrace? stackTrace) {
                  return Text('Image not available');
                },
              ),
            ),
          );

          Widget reviewWidget = ListView.builder(
            physics: AlwaysScrollableScrollPhysics(),
            itemCount: reviews.length,
            itemBuilder: (_, index) {
              final review = reviews[index];
              // if (review.fields.username == username) {
              //   print("MASUKKK");
              //   hasReview = true;
              // }
              return Container(
                margin:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                padding: const EdgeInsets.all(20.0),
                child: ReviewCard(review),
              );
            },
          );
          // print(hasReview);
          ButtonStyle buttonStyle = ElevatedButton.styleFrom(
            primary: const Color.fromRGBO(255, 220, 0, 1),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            shadowColor: Colors.black,
          );

          TextStyle textStyle = const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          );

          List<Widget> bookUtilsWidgets = [];
          if (!hasReview) {
            bookUtilsWidgets.add(ElevatedButton(
              style: buttonStyle,
              onPressed: () => _showAddReviewSheet(),
              child: Text('Add a Review', style: textStyle),
            ));
          } else {
            // bookUtilsWidgets.add(ReviewCard(userReview!));
            bookUtilsWidgets.add(ElevatedButton(
              style: buttonStyle,
              onPressed: _delete,
              child: Text('Delete', style: textStyle),
            ));
            bookUtilsWidgets.add(const SizedBox(width: 10, height: 50));
          }

          return Center(
            child: Column(
              children: [
                Expanded(child: imageWidget),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Text(
                    book.fields.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Text(
                    book.fields.publishedDate.toString(),
                    style: const TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: 20,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Text(book.fields.description),
                ),
                Padding(
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        const Icon(Icons.star, color: Colors.orange),
                        Text('$average / 5.0 (${reviews.length})'),
                      ],
                    )),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: bookUtilsWidgets,
                ),
                Expanded(child: reviewWidget),
              ],
            ),
          );
        },
      ),
    );
  }
}
