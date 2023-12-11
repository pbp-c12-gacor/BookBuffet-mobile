import 'package:flutter/material.dart';
import 'package:bookbuffet/pages/catalog/models/rating.dart';
import 'package:bookbuffet/pages/catalog/widgets/rating_card.dart';

class Ratings extends StatelessWidget {
  final Future<List<Rating>> ratings;
  const Ratings({Key? key, required this.ratings}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Rating>>(
      future: ratings,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<Rating> ratings = snapshot.data!;
          return ListView.builder(
            itemCount: ratings.length,
            itemBuilder: (context, index) {
              return RatingCard(rating: ratings[index]);
            },
          );
        } else if (snapshot.hasError) {
          return const Center(
            child: Text('Something went wrong!'),
          );
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
