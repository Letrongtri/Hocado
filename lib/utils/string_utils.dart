class StringUtils {
  static double stringSimilarity(String a, String b) {
    a = a.trim().toLowerCase();
    b = b.trim().toLowerCase();
    if (a.isEmpty || b.isEmpty) return 0;

    final distance = levenshtein(a, b);
    final maxLen = a.length > b.length ? a.length : b.length;
    return 1 - (distance / maxLen);
  }

  static int levenshtein(String s, String t) {
    final m = List.generate(
      s.length + 1,
      (_) => List<int>.filled(t.length + 1, 0),
    );

    for (var i = 0; i <= s.length; i++) {
      m[i][0] = i;
    }
    for (var j = 0; j <= t.length; j++) {
      m[0][j] = j;
    }

    for (var i = 1; i <= s.length; i++) {
      for (var j = 1; j <= t.length; j++) {
        final cost = s[i - 1] == t[j - 1] ? 0 : 1;
        m[i][j] = [
          m[i - 1][j] + 1,
          m[i][j - 1] + 1,
          m[i - 1][j - 1] + cost,
        ].reduce((a, b) => a < b ? a : b);
      }
    }
    return m[s.length][t.length];
  }

  static List<String> generateKeywords(String text) {
    String temp = text.toLowerCase().trim();
    List<String> words = temp.split(' ');
    return words;
  }
}
