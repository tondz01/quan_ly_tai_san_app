abstract class AppUtility {
  static String formatDateDdMmYyyy(DateTime date) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String day = twoDigits(date.day);
    String month = twoDigits(date.month);
    String year = date.year.toString();
    return '$day/$month/$year';
  }

  // SEARCH
  static bool fuzzySearch(String text, String searchTerm) {
    if (searchTerm.isEmpty) return true;
    
    List<String> searchWords = searchTerm.split(' ').where((word) => word.isNotEmpty).toList();
    
    for (String word in searchWords) {
      if (!text.contains(word)) {
        return false;
      }
    }
    return true;
  }
}
