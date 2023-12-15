DateTime now = DateTime.now();

String formatTimeDifference(DateTime dateAdded) {
  Duration diff = now.difference(dateAdded);

  if (diff.inSeconds < 60) {
    return '${diff.inSeconds} s';
  } else if (diff.inMinutes < 60) {
    return '${diff.inMinutes} m';
  } else if (diff.inHours < 24) {
    return '${diff.inHours} h';
  } else {
    return '${diff.inDays} d';
  }
}
