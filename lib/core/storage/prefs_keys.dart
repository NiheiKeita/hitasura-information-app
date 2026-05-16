class PrefsKeys {
  static String dailyStats(String dateKey) => 'daily_stats:$dateKey';
  static String dailyCounts(String dateKey) => 'daily_counts:$dateKey';
  static String dailyCorrect(String dateKey) => 'daily_correct:$dateKey';

  static const String totalsAnswered = 'totals_answered';
  static const String totalsCorrect = 'totals_correct';
  static const String bestStreak = 'stats_best_streak';

  static String best(String category, String mode, String difficulty) {
    return 'best:$category:$mode:$difficulty';
  }
}
