class Review {
    String model;
    int pk;
    Fields fields;

    Review({
        required this.model,
        required this.pk,
        required this.fields,
    });

}

class Fields {
    int user;
    String username;
    int book;
    String review;
    int rating;
    DateTime dateAdded;

    Fields({
        required this.user,
        required this.username,
        required this.book,
        required this.review,
        required this.rating,
        required this.dateAdded,
    });

}
