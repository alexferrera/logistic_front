

String formatElapsedTime(DateTime createdAt) {
  final diff = DateTime.now().difference(createdAt);
  if (diff.inSeconds < 60) {
    return "Hace ${diff.inSeconds} seg";
  } else if (diff.inMinutes < 60) {
    return "Hace ${diff.inMinutes} min";
  } else if (diff.inHours < 24) {
    return "Hace ${diff.inHours} h";
  } else {
    return "Hace ${diff.inDays} d";
  }
}
