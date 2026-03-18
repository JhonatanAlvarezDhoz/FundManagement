extension StringFormatter on String {
  String formatReadable() {
    final words = replaceAll('_', ' ').toLowerCase().split(' ');

    return words
        .map((word) {
          if (word.isEmpty) return '';
          return word[0].toUpperCase() + word.substring(1);
        })
        .join(' ');
  }
}
