import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ja.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ja'),
  ];

  /// App display title
  ///
  /// In en, this message translates to:
  /// **'Hitasura Jouhou'**
  String get appTitle;

  /// No description provided for @homeMenuTooltip.
  ///
  /// In en, this message translates to:
  /// **'Menu'**
  String get homeMenuTooltip;

  /// No description provided for @homeTagline.
  ///
  /// In en, this message translates to:
  /// **'Don\'t think. Just get used to it.'**
  String get homeTagline;

  /// No description provided for @homeTodayCorrect.
  ///
  /// In en, this message translates to:
  /// **'Correct today: {count}'**
  String homeTodayCorrect(int count);

  /// No description provided for @homeStreakDays.
  ///
  /// In en, this message translates to:
  /// **'{count}-day streak!'**
  String homeStreakDays(int count);

  /// No description provided for @homeChooseCategory.
  ///
  /// In en, this message translates to:
  /// **'Choose a topic'**
  String get homeChooseCategory;

  /// No description provided for @categoryPseudocodeExecution.
  ///
  /// In en, this message translates to:
  /// **'Pseudocode Execution'**
  String get categoryPseudocodeExecution;

  /// No description provided for @categoryPseudocodeExecutionDesc.
  ///
  /// In en, this message translates to:
  /// **'Trace variable values and output'**
  String get categoryPseudocodeExecutionDesc;

  /// No description provided for @categoryControlFlowTrace.
  ///
  /// In en, this message translates to:
  /// **'if / for / while Trace'**
  String get categoryControlFlowTrace;

  /// No description provided for @categoryControlFlowTraceDesc.
  ///
  /// In en, this message translates to:
  /// **'Read branches and loops'**
  String get categoryControlFlowTraceDesc;

  /// No description provided for @categoryBinaryToDecimal.
  ///
  /// In en, this message translates to:
  /// **'Binary → Decimal'**
  String get categoryBinaryToDecimal;

  /// No description provided for @categoryBinaryToDecimalDesc.
  ///
  /// In en, this message translates to:
  /// **'Convert binary to decimal'**
  String get categoryBinaryToDecimalDesc;

  /// No description provided for @categoryDecimalToBinary.
  ///
  /// In en, this message translates to:
  /// **'Decimal → Binary'**
  String get categoryDecimalToBinary;

  /// No description provided for @categoryDecimalToBinaryDesc.
  ///
  /// In en, this message translates to:
  /// **'Convert decimal to binary'**
  String get categoryDecimalToBinaryDesc;

  /// No description provided for @categoryBinaryMixed.
  ///
  /// In en, this message translates to:
  /// **'Binary / Decimal Mix'**
  String get categoryBinaryMixed;

  /// No description provided for @categoryBinaryMixedDesc.
  ///
  /// In en, this message translates to:
  /// **'Conversion direction is randomized'**
  String get categoryBinaryMixedDesc;

  /// No description provided for @modeSelectTitle.
  ///
  /// In en, this message translates to:
  /// **'Select Mode'**
  String get modeSelectTitle;

  /// No description provided for @modeSelectSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Choose a mode and difficulty'**
  String get modeSelectSubtitle;

  /// No description provided for @modeSelectModeLabel.
  ///
  /// In en, this message translates to:
  /// **'Mode'**
  String get modeSelectModeLabel;

  /// No description provided for @modePracticeMode10.
  ///
  /// In en, this message translates to:
  /// **'TA 10'**
  String get modePracticeMode10;

  /// No description provided for @modePracticeMode10Desc.
  ///
  /// In en, this message translates to:
  /// **'Tempo focused'**
  String get modePracticeMode10Desc;

  /// No description provided for @modePracticeModeInfinite.
  ///
  /// In en, this message translates to:
  /// **'Infinite'**
  String get modePracticeModeInfinite;

  /// No description provided for @modePracticeModeInfiniteDesc.
  ///
  /// In en, this message translates to:
  /// **'Solve continuously'**
  String get modePracticeModeInfiniteDesc;

  /// No description provided for @modeDifficultyLabel.
  ///
  /// In en, this message translates to:
  /// **'Difficulty'**
  String get modeDifficultyLabel;

  /// No description provided for @modeSelectStart.
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get modeSelectStart;

  /// No description provided for @practiceQuestion.
  ///
  /// In en, this message translates to:
  /// **'Question'**
  String get practiceQuestion;

  /// No description provided for @practiceAnswer.
  ///
  /// In en, this message translates to:
  /// **'Answer'**
  String get practiceAnswer;

  /// No description provided for @practiceInputHint.
  ///
  /// In en, this message translates to:
  /// **'Enter with the keypad below'**
  String get practiceInputHint;

  /// No description provided for @practiceProgressInfinite.
  ///
  /// In en, this message translates to:
  /// **'Correct: {correct} (streak {streak})'**
  String practiceProgressInfinite(int correct, int streak);

  /// No description provided for @practiceInputPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Input'**
  String get practiceInputPlaceholder;

  /// No description provided for @practiceCountdownReady.
  ///
  /// In en, this message translates to:
  /// **'Ready'**
  String get practiceCountdownReady;

  /// No description provided for @practiceCountdownStart.
  ///
  /// In en, this message translates to:
  /// **'Start!'**
  String get practiceCountdownStart;

  /// No description provided for @practiceClear.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get practiceClear;

  /// No description provided for @practiceSubmit.
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get practiceSubmit;

  /// No description provided for @hintAnswerDecimal.
  ///
  /// In en, this message translates to:
  /// **'Answer in decimal'**
  String get hintAnswerDecimal;

  /// No description provided for @hintAnswerBinary.
  ///
  /// In en, this message translates to:
  /// **'Answer in binary'**
  String get hintAnswerBinary;

  /// No description provided for @resultTitle.
  ///
  /// In en, this message translates to:
  /// **'Result'**
  String get resultTitle;

  /// No description provided for @resultMessage.
  ///
  /// In en, this message translates to:
  /// **'Nice work!'**
  String get resultMessage;

  /// No description provided for @resultCorrectCount.
  ///
  /// In en, this message translates to:
  /// **'Correct'**
  String get resultCorrectCount;

  /// No description provided for @resultMaxStreak.
  ///
  /// In en, this message translates to:
  /// **'Best streak'**
  String get resultMaxStreak;

  /// No description provided for @resultElapsedTime.
  ///
  /// In en, this message translates to:
  /// **'Elapsed'**
  String get resultElapsedTime;

  /// No description provided for @resultTotalTime.
  ///
  /// In en, this message translates to:
  /// **'Total time'**
  String get resultTotalTime;

  /// No description provided for @resultAverageTime.
  ///
  /// In en, this message translates to:
  /// **'Avg. answer time'**
  String get resultAverageTime;

  /// No description provided for @resultHomeButton.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get resultHomeButton;

  /// No description provided for @resultRetryButton.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get resultRetryButton;

  /// No description provided for @resultSecondsShort.
  ///
  /// In en, this message translates to:
  /// **'{seconds}s'**
  String resultSecondsShort(String seconds);

  /// No description provided for @resultSelfBestTitle.
  ///
  /// In en, this message translates to:
  /// **'Your bests'**
  String get resultSelfBestTitle;

  /// No description provided for @resultBestToday.
  ///
  /// In en, this message translates to:
  /// **'Today\'s best'**
  String get resultBestToday;

  /// No description provided for @resultBestThisWeek.
  ///
  /// In en, this message translates to:
  /// **'This week\'s best'**
  String get resultBestThisWeek;

  /// No description provided for @resultBestAllTime.
  ///
  /// In en, this message translates to:
  /// **'All-time best'**
  String get resultBestAllTime;

  /// No description provided for @resultAllTimeBestUpdated.
  ///
  /// In en, this message translates to:
  /// **'All-time best updated!'**
  String get resultAllTimeBestUpdated;

  /// No description provided for @resultTodayBestUpdated.
  ///
  /// In en, this message translates to:
  /// **'Today\'s best updated!'**
  String get resultTodayBestUpdated;

  /// No description provided for @resultEncourageAllTimeBest.
  ///
  /// In en, this message translates to:
  /// **'Amazing — your new personal best!'**
  String get resultEncourageAllTimeBest;

  /// No description provided for @resultEncourageGapAllTime.
  ///
  /// In en, this message translates to:
  /// **'{seconds}s away from your all-time best.'**
  String resultEncourageGapAllTime(String seconds);

  /// No description provided for @resultEncourageGapToday.
  ///
  /// In en, this message translates to:
  /// **'{seconds}s away from today\'s best.'**
  String resultEncourageGapToday(String seconds);

  /// No description provided for @resultEncourageKeepGoing.
  ///
  /// In en, this message translates to:
  /// **'Keep going!'**
  String get resultEncourageKeepGoing;

  /// No description provided for @calendarTitle.
  ///
  /// In en, this message translates to:
  /// **'Study Calendar'**
  String get calendarTitle;

  /// No description provided for @calendarMonthFormat.
  ///
  /// In en, this message translates to:
  /// **'{year} / {month}'**
  String calendarMonthFormat(int year, int month);

  /// No description provided for @calendarNoStudy.
  ///
  /// In en, this message translates to:
  /// **'No activity on this day yet'**
  String get calendarNoStudy;

  /// No description provided for @calendarCorrectCount.
  ///
  /// In en, this message translates to:
  /// **'Correct'**
  String get calendarCorrectCount;

  /// No description provided for @calendarBreakdown.
  ///
  /// In en, this message translates to:
  /// **'Breakdown'**
  String get calendarBreakdown;

  /// No description provided for @calendarQuestionCount.
  ///
  /// In en, this message translates to:
  /// **'{count} q'**
  String calendarQuestionCount(int count);

  /// No description provided for @calendarCountQuestions.
  ///
  /// In en, this message translates to:
  /// **'{count} q'**
  String calendarCountQuestions(int count);

  /// No description provided for @weekdaySun.
  ///
  /// In en, this message translates to:
  /// **'Sun'**
  String get weekdaySun;

  /// No description provided for @weekdayMon.
  ///
  /// In en, this message translates to:
  /// **'Mon'**
  String get weekdayMon;

  /// No description provided for @weekdayTue.
  ///
  /// In en, this message translates to:
  /// **'Tue'**
  String get weekdayTue;

  /// No description provided for @weekdayWed.
  ///
  /// In en, this message translates to:
  /// **'Wed'**
  String get weekdayWed;

  /// No description provided for @weekdayThu.
  ///
  /// In en, this message translates to:
  /// **'Thu'**
  String get weekdayThu;

  /// No description provided for @weekdayFri.
  ///
  /// In en, this message translates to:
  /// **'Fri'**
  String get weekdayFri;

  /// No description provided for @weekdaySat.
  ///
  /// In en, this message translates to:
  /// **'Sat'**
  String get weekdaySat;

  /// No description provided for @statsTodayTitle.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get statsTodayTitle;

  /// No description provided for @statsTodayCorrect.
  ///
  /// In en, this message translates to:
  /// **'Correct today'**
  String get statsTodayCorrect;

  /// No description provided for @statsLast7DaysTitle.
  ///
  /// In en, this message translates to:
  /// **'Last 7 days'**
  String get statsLast7DaysTitle;

  /// No description provided for @statsLast7DaysCorrect.
  ///
  /// In en, this message translates to:
  /// **'Correct in 7 days'**
  String get statsLast7DaysCorrect;

  /// No description provided for @statsTotalTitle.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get statsTotalTitle;

  /// No description provided for @statsTotalCorrect.
  ///
  /// In en, this message translates to:
  /// **'Total correct'**
  String get statsTotalCorrect;

  /// No description provided for @statsCalendarTitle.
  ///
  /// In en, this message translates to:
  /// **'Study Calendar'**
  String get statsCalendarTitle;

  /// No description provided for @statsRecentPace.
  ///
  /// In en, this message translates to:
  /// **'Recent pace'**
  String get statsRecentPace;

  /// No description provided for @statsOpenCalendar.
  ///
  /// In en, this message translates to:
  /// **'Open calendar'**
  String get statsOpenCalendar;

  /// No description provided for @statsBestRecords.
  ///
  /// In en, this message translates to:
  /// **'Best records'**
  String get statsBestRecords;

  /// No description provided for @statsBestTimeNone.
  ///
  /// In en, this message translates to:
  /// **'Best -'**
  String get statsBestTimeNone;

  /// No description provided for @statsBestTime.
  ///
  /// In en, this message translates to:
  /// **'Best {seconds}s'**
  String statsBestTime(String seconds);

  /// No description provided for @statsBestScoreNone.
  ///
  /// In en, this message translates to:
  /// **'Correct -'**
  String get statsBestScoreNone;

  /// No description provided for @statsBestScore.
  ///
  /// In en, this message translates to:
  /// **'Correct {correct} / streak {streak}'**
  String statsBestScore(int correct, int streak);

  /// No description provided for @menuTitle.
  ///
  /// In en, this message translates to:
  /// **'Menu'**
  String get menuTitle;

  /// No description provided for @menuGetStarted.
  ///
  /// In en, this message translates to:
  /// **'Get started'**
  String get menuGetStarted;

  /// No description provided for @menuPseudocodeDesc.
  ///
  /// In en, this message translates to:
  /// **'Trace variables and output'**
  String get menuPseudocodeDesc;

  /// No description provided for @menuControlFlowDesc.
  ///
  /// In en, this message translates to:
  /// **'Branches and loops'**
  String get menuControlFlowDesc;

  /// No description provided for @menuBinaryToDecimalDesc.
  ///
  /// In en, this message translates to:
  /// **'Binary to decimal'**
  String get menuBinaryToDecimalDesc;

  /// No description provided for @menuDecimalToBinaryDesc.
  ///
  /// In en, this message translates to:
  /// **'Decimal to binary'**
  String get menuDecimalToBinaryDesc;

  /// No description provided for @menuBinaryMixedDesc.
  ///
  /// In en, this message translates to:
  /// **'Random conversion'**
  String get menuBinaryMixedDesc;

  /// No description provided for @menuLinks.
  ///
  /// In en, this message translates to:
  /// **'Links'**
  String get menuLinks;

  /// No description provided for @menuOfficialWebsite.
  ///
  /// In en, this message translates to:
  /// **'Official website'**
  String get menuOfficialWebsite;

  /// No description provided for @menuOfficialWebsiteDesc.
  ///
  /// In en, this message translates to:
  /// **'Latest updates here'**
  String get menuOfficialWebsiteDesc;

  /// No description provided for @menuOtherApps.
  ///
  /// In en, this message translates to:
  /// **'Other apps'**
  String get menuOtherApps;

  /// No description provided for @menuOtherAppsDesc.
  ///
  /// In en, this message translates to:
  /// **'Check the series'**
  String get menuOtherAppsDesc;

  /// No description provided for @menuAbout.
  ///
  /// In en, this message translates to:
  /// **'About this app'**
  String get menuAbout;

  /// No description provided for @menuLicenses.
  ///
  /// In en, this message translates to:
  /// **'Licenses'**
  String get menuLicenses;

  /// No description provided for @menuLicensesDesc.
  ///
  /// In en, this message translates to:
  /// **'Libraries used'**
  String get menuLicensesDesc;

  /// No description provided for @menuOpenLinkError.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t open the link'**
  String get menuOpenLinkError;

  /// No description provided for @rankingSelfTitle.
  ///
  /// In en, this message translates to:
  /// **'Your Ranking'**
  String get rankingSelfTitle;

  /// No description provided for @rankingWorldButton.
  ///
  /// In en, this message translates to:
  /// **'World Ranking'**
  String get rankingWorldButton;

  /// No description provided for @rankingRangeToday.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get rankingRangeToday;

  /// No description provided for @rankingRangeThisWeek.
  ///
  /// In en, this message translates to:
  /// **'This week'**
  String get rankingRangeThisWeek;

  /// No description provided for @rankingRangeAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get rankingRangeAll;

  /// No description provided for @rankingNoRecords.
  ///
  /// In en, this message translates to:
  /// **'No records yet'**
  String get rankingNoRecords;

  /// No description provided for @rankingRank.
  ///
  /// In en, this message translates to:
  /// **'#{rank}'**
  String rankingRank(int rank);

  /// No description provided for @rankingComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Ranking is coming soon'**
  String get rankingComingSoon;

  /// No description provided for @introPointsTitle.
  ///
  /// In en, this message translates to:
  /// **'Key points'**
  String get introPointsTitle;

  /// No description provided for @introSolutionTitle.
  ///
  /// In en, this message translates to:
  /// **'How to solve'**
  String get introSolutionTitle;

  /// No description provided for @introPseudocodePoints.
  ///
  /// In en, this message translates to:
  /// **'Track how each variable changes step by step.'**
  String get introPseudocodePoints;

  /// No description provided for @introPseudocodeSolution.
  ///
  /// In en, this message translates to:
  /// **'Execute the pseudocode from top to bottom and enter the final output or value.'**
  String get introPseudocodeSolution;

  /// No description provided for @introControlFlowPoints.
  ///
  /// In en, this message translates to:
  /// **'Sort out condition truthiness and loop counts.'**
  String get introControlFlowPoints;

  /// No description provided for @introControlFlowSolution.
  ///
  /// In en, this message translates to:
  /// **'Answer the branch result, loop count, or final output as a number.'**
  String get introControlFlowSolution;

  /// No description provided for @introBinaryToDecimalPoints.
  ///
  /// In en, this message translates to:
  /// **'Sum the weight of each digit (1, 2, 4, 8...).'**
  String get introBinaryToDecimalPoints;

  /// No description provided for @introBinaryToDecimalSolution.
  ///
  /// In en, this message translates to:
  /// **'Enter the binary number as a decimal.'**
  String get introBinaryToDecimalSolution;

  /// No description provided for @introDecimalToBinaryPoints.
  ///
  /// In en, this message translates to:
  /// **'List the remainders of dividing by 2 in reverse.'**
  String get introDecimalToBinaryPoints;

  /// No description provided for @introDecimalToBinarySolution.
  ///
  /// In en, this message translates to:
  /// **'Enter the decimal number as binary.'**
  String get introDecimalToBinarySolution;

  /// No description provided for @introBinaryMixedPoints.
  ///
  /// In en, this message translates to:
  /// **'Check the conversion direction in the question.'**
  String get introBinaryMixedPoints;

  /// No description provided for @introBinaryMixedSolution.
  ///
  /// In en, this message translates to:
  /// **'Enter the answer in the requested format.'**
  String get introBinaryMixedSolution;

  /// No description provided for @tabHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get tabHome;

  /// No description provided for @tabStats.
  ///
  /// In en, this message translates to:
  /// **'Stats'**
  String get tabStats;

  /// No description provided for @tabRanking.
  ///
  /// In en, this message translates to:
  /// **'Ranking'**
  String get tabRanking;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'ja'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'ja':
      return AppLocalizationsJa();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
