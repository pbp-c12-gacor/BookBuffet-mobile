import 'package:flutter/material.dart';
import 'package:bookbuffet/pages/catalog/models/rating.dart';

class RatingCard extends StatelessWidget {
  final Rating rating;
  const RatingCard({Key? key, required this.rating}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: () {},
        onLongPress: () {},
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Add a username
            Text(
              rating.username,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            // Add a review
            Text(
              rating.review,
            ),
            // Add a rating
            Text(
              "${rating.rating} / 5",
            ),
            // Add a date added
            Text(
              rating.dateAdded.toString(),
            ),
          ],
        ),
      ),
    );
  }
}
