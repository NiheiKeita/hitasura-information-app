// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Hitasura Jouhou';

  @override
  String get homeMenuTooltip => 'Menu';

  @override
  String get homeTagline => 'Don\'t think. Just get used to it.';

  @override
  String homeTodayCorrect(int count) {
    return 'Correct today: $count';
  }

  @override
  String homeStreakDays(int count) {
    return '$count-day streak!';
  }

  @override
  String get homeChooseCategory => 'Choose a topic';

  @override
  String get categoryPseudocodeExecution => 'Pseudocode Execution';

  @override
  String get categoryPseudocodeExecutionDesc =>
      'Trace variable values and output';

  @override
  String get categoryControlFlowTrace => 'if / for / while Trace';

  @override
  String get categoryControlFlowTraceDesc => 'Read branches and loops';

  @override
  String get categoryBinaryToDecimal => 'Binary → Decimal';

  @override
  String get categoryBinaryToDecimalDesc => 'Convert binary to decimal';

  @override
  String get categoryDecimalToBinary => 'Decimal → Binary';

  @override
  String get categoryDecimalToBinaryDesc => 'Convert decimal to binary';

  @override
  String get categoryBinaryMixed => 'Binary / Decimal Mix';

  @override
  String get categoryBinaryMixedDesc => 'Conversion direction is randomized';

  @override
  String get modeSelectTitle => 'Select Mode';

  @override
  String get modeSelectSubtitle => 'Choose a mode and difficulty';

  @override
  String get modeSelectModeLabel => 'Mode';

  @override
  String get modePracticeMode10 => 'TA 10';

  @override
  String get modePracticeMode10Desc => 'Tempo focused';

  @override
  String get modePracticeModeInfinite => 'Infinite';

  @override
  String get modePracticeModeInfiniteDesc => 'Solve continuously';

  @override
  String get modeDifficultyLabel => 'Difficulty';

  @override
  String get modeSelectStart => 'Start';

  @override
  String get practiceQuestion => 'Question';

  @override
  String get practiceAnswer => 'Answer';

  @override
  String get practiceInputHint => 'Enter with the keypad below';

  @override
  String practiceProgressInfinite(int correct, int streak) {
    return 'Correct: $correct (streak $streak)';
  }

  @override
  String get practiceInputPlaceholder => 'Input';

  @override
  String get practiceCountdownReady => 'Ready';

  @override
  String get practiceCountdownStart => 'Start!';

  @override
  String get practiceClear => 'Clear';

  @override
  String get practiceSubmit => 'Submit';

  @override
  String get hintAnswerDecimal => 'Answer in decimal';

  @override
  String get hintAnswerBinary => 'Answer in binary';

  @override
  String get resultTitle => 'Result';

  @override
  String get resultMessage => 'Nice work!';

  @override
  String get resultCorrectCount => 'Correct';

  @override
  String get resultMaxStreak => 'Best streak';

  @override
  String get resultElapsedTime => 'Elapsed';

  @override
  String get resultTotalTime => 'Total time';

  @override
  String get resultAverageTime => 'Avg. answer time';

  @override
  String get resultHomeButton => 'Home';

  @override
  String get resultRetryButton => 'Retry';

  @override
  String resultSecondsShort(String seconds) {
    return '${seconds}s';
  }

  @override
  String get resultSelfBestTitle => 'Your bests';

  @override
  String get resultBestToday => 'Today\'s best';

  @override
  String get resultBestThisWeek => 'This week\'s best';

  @override
  String get resultBestAllTime => 'All-time best';

  @override
  String get resultAllTimeBestUpdated => 'All-time best updated!';

  @override
  String get resultTodayBestUpdated => 'Today\'s best updated!';

  @override
  String get resultEncourageAllTimeBest => 'Amazing — your new personal best!';

  @override
  String resultEncourageGapAllTime(String seconds) {
    return '${seconds}s away from your all-time best.';
  }

  @override
  String resultEncourageGapToday(String seconds) {
    return '${seconds}s away from today\'s best.';
  }

  @override
  String get resultEncourageKeepGoing => 'Keep going!';

  @override
  String get calendarTitle => 'Study Calendar';

  @override
  String calendarMonthFormat(int year, int month) {
    return '$year / $month';
  }

  @override
  String get calendarNoStudy => 'No activity on this day yet';

  @override
  String get calendarCorrectCount => 'Correct';

  @override
  String get calendarBreakdown => 'Breakdown';

  @override
  String calendarQuestionCount(int count) {
    return '$count q';
  }

  @override
  String calendarCountQuestions(int count) {
    return '$count q';
  }

  @override
  String get weekdaySun => 'Sun';

  @override
  String get weekdayMon => 'Mon';

  @override
  String get weekdayTue => 'Tue';

  @override
  String get weekdayWed => 'Wed';

  @override
  String get weekdayThu => 'Thu';

  @override
  String get weekdayFri => 'Fri';

  @override
  String get weekdaySat => 'Sat';

  @override
  String get statsTodayTitle => 'Today';

  @override
  String get statsTodayCorrect => 'Correct today';

  @override
  String get statsLast7DaysTitle => 'Last 7 days';

  @override
  String get statsLast7DaysCorrect => 'Correct in 7 days';

  @override
  String get statsTotalTitle => 'Total';

  @override
  String get statsTotalCorrect => 'Total correct';

  @override
  String get statsCalendarTitle => 'Study Calendar';

  @override
  String get statsRecentPace => 'Recent pace';

  @override
  String get statsOpenCalendar => 'Open calendar';

  @override
  String get statsBestRecords => 'Best records';

  @override
  String get statsBestTimeNone => 'Best -';

  @override
  String statsBestTime(String seconds) {
    return 'Best ${seconds}s';
  }

  @override
  String get statsBestScoreNone => 'Correct -';

  @override
  String statsBestScore(int correct, int streak) {
    return 'Correct $correct / streak $streak';
  }

  @override
  String get menuTitle => 'Menu';

  @override
  String get menuGetStarted => 'Get started';

  @override
  String get menuPseudocodeDesc => 'Trace variables and output';

  @override
  String get menuControlFlowDesc => 'Branches and loops';

  @override
  String get menuBinaryToDecimalDesc => 'Binary to decimal';

  @override
  String get menuDecimalToBinaryDesc => 'Decimal to binary';

  @override
  String get menuBinaryMixedDesc => 'Random conversion';

  @override
  String get menuLinks => 'Links';

  @override
  String get menuOfficialWebsite => 'Official website';

  @override
  String get menuOfficialWebsiteDesc => 'Latest updates here';

  @override
  String get menuOtherApps => 'Other apps';

  @override
  String get menuOtherAppsDesc => 'Check the series';

  @override
  String get menuAbout => 'About this app';

  @override
  String get menuLicenses => 'Licenses';

  @override
  String get menuLicensesDesc => 'Libraries used';

  @override
  String get menuOpenLinkError => 'Couldn\'t open the link';

  @override
  String get rankingComingSoon => 'Ranking is coming soon';

  @override
  String get introPointsTitle => 'Key points';

  @override
  String get introSolutionTitle => 'How to solve';

  @override
  String get introPseudocodePoints =>
      'Track how each variable changes step by step.';

  @override
  String get introPseudocodeSolution =>
      'Execute the pseudocode from top to bottom and enter the final output or value.';

  @override
  String get introControlFlowPoints =>
      'Sort out condition truthiness and loop counts.';

  @override
  String get introControlFlowSolution =>
      'Answer the branch result, loop count, or final output as a number.';

  @override
  String get introBinaryToDecimalPoints =>
      'Sum the weight of each digit (1, 2, 4, 8...).';

  @override
  String get introBinaryToDecimalSolution =>
      'Enter the binary number as a decimal.';

  @override
  String get introDecimalToBinaryPoints =>
      'List the remainders of dividing by 2 in reverse.';

  @override
  String get introDecimalToBinarySolution =>
      'Enter the decimal number as binary.';

  @override
  String get introBinaryMixedPoints =>
      'Check the conversion direction in the question.';

  @override
  String get introBinaryMixedSolution =>
      'Enter the answer in the requested format.';

  @override
  String get tabHome => 'Home';

  @override
  String get tabStats => 'Stats';

  @override
  String get tabRanking => 'Ranking';
}
