import 'dart:async';
import 'package:flutter/foundation.dart';

class CommentProvider with ChangeNotifier {
  final _refreshController = StreamController<void>();

  StreamController<void> get refreshController => _refreshController;

  void refreshComments() {
    _refreshController.add(null);
    notifyListeners();
  }

  @override
  void dispose() {
    _refreshController.close();
    super.dispose();
  }
}
