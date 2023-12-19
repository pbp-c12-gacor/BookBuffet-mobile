import 'package:flutter/material.dart';
import 'package:bookbuffet/pages/MyBooks/models/review.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

class ReviewCard extends StatelessWidget {
  final Review review;

  const ReviewCard(this.review, {super.key});

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    List<Widget> ratings = [];
    for (int i = 0; i < review.fields.rating; i++) {
      ratings.add(
          const Icon(Icons.star_rate_sharp, size: 15, color: Colors.orange));
    }
    while (ratings.length != 5) {
      ratings.add(const Icon(Icons.star_border, size: 15));
    }

    return Center(
        child: Card(
            child: Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        ListTile(
          leading: const Icon(Icons.account_circle_rounded),
          title: Row(
            children: <Widget>[
              Expanded(
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    review.fields.username,
                  ),
                ),
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Row(
                    children: ratings,
                  ),
                ),
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    review.fields.dateAdded.toString(),
                  ),
                ),
              ),
            ],
          ),
          subtitle: Text(review.fields.review),
        ),
      ],
    )));
  }
}
