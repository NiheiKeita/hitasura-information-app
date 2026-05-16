// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get appTitle => 'ひたすら情報';

  @override
  String get homeMenuTooltip => 'メニュー';

  @override
  String get homeTagline => '考えずに、慣れろ。';

  @override
  String homeTodayCorrect(int count) {
    return '今日の正解: $count';
  }

  @override
  String homeStreakDays(int count) {
    return '$count日連続！';
  }

  @override
  String get homeChooseCategory => '単元をえらぶ';

  @override
  String get categoryPseudocodeExecution => '疑似コードの実行結果';

  @override
  String get categoryPseudocodeExecutionDesc => '変数の最終値・出力を追う';

  @override
  String get categoryControlFlowTrace => 'if / for / while の処理追跡';

  @override
  String get categoryControlFlowTraceDesc => '分岐とループを読み解く';

  @override
  String get categoryBinaryToDecimal => '2進数→10進数';

  @override
  String get categoryBinaryToDecimalDesc => '2進数を10進数に変換';

  @override
  String get categoryDecimalToBinary => '10進数→2進数';

  @override
  String get categoryDecimalToBinaryDesc => '10進数を2進数に変換';

  @override
  String get categoryBinaryMixed => '2進数/10進数ミックス';

  @override
  String get categoryBinaryMixedDesc => '変換がランダムに出題';

  @override
  String get modeSelectTitle => 'モード選択';

  @override
  String get modeSelectSubtitle => 'モードと難易度を選ぶ';

  @override
  String get modeSelectModeLabel => 'モード';

  @override
  String get modePracticeMode10 => '10問TA';

  @override
  String get modePracticeMode10Desc => 'テンポ重視';

  @override
  String get modePracticeModeInfinite => '無限';

  @override
  String get modePracticeModeInfiniteDesc => 'ずっと解く';

  @override
  String get modeDifficultyLabel => '難易度';

  @override
  String get modeSelectStart => 'スタート';

  @override
  String get practiceQuestion => '問題';

  @override
  String get practiceAnswer => '答え';

  @override
  String get practiceInputHint => '下のキーパッドで入力';

  @override
  String practiceProgressInfinite(int correct, int streak) {
    return '正解 $correct (連続 $streak)';
  }

  @override
  String get practiceInputPlaceholder => '入力';

  @override
  String get practiceCountdownReady => 'よーい';

  @override
  String get practiceCountdownStart => 'スタート！';

  @override
  String get practiceClear => 'クリア';

  @override
  String get practiceSubmit => '回答する';

  @override
  String get hintAnswerDecimal => '10進数で答える';

  @override
  String get hintAnswerBinary => '2進数で答える';

  @override
  String get resultTitle => '結果';

  @override
  String get resultMessage => 'おつかれさま！';

  @override
  String get resultCorrectCount => '正解数';

  @override
  String get resultMaxStreak => '最大連続正解';

  @override
  String get resultElapsedTime => '所要時間';

  @override
  String get resultTotalTime => '合計タイム';

  @override
  String get resultAverageTime => '平均回答時間';

  @override
  String get resultHomeButton => 'Homeへ';

  @override
  String get resultRetryButton => 'もう一回';

  @override
  String resultSecondsShort(String seconds) {
    return '${seconds}s';
  }

  @override
  String get resultSelfBestTitle => '自己ベスト';

  @override
  String get resultBestToday => '今日のベスト';

  @override
  String get resultBestThisWeek => '今週のベスト';

  @override
  String get resultBestAllTime => '全期間ベスト';

  @override
  String get resultAllTimeBestUpdated => '全期間ベスト更新！';

  @override
  String get resultTodayBestUpdated => '今日のベスト更新！';

  @override
  String get resultEncourageAllTimeBest => '自己ベスト更新！すばらしい！';

  @override
  String resultEncourageGapAllTime(String seconds) {
    return '全期間ベストまであと${seconds}s。';
  }

  @override
  String resultEncourageGapToday(String seconds) {
    return '今日のベストまであと${seconds}s。';
  }

  @override
  String get resultEncourageKeepGoing => 'この調子！';

  @override
  String get calendarTitle => '学習カレンダー';

  @override
  String calendarMonthFormat(int year, int month) {
    return '$year年$month月';
  }

  @override
  String get calendarNoStudy => 'この日はまだ解いていません';

  @override
  String get calendarCorrectCount => '正解数';

  @override
  String get calendarBreakdown => '正解内訳';

  @override
  String calendarQuestionCount(int count) {
    return '$count問';
  }

  @override
  String calendarCountQuestions(int count) {
    return '$count問';
  }

  @override
  String get weekdaySun => '日';

  @override
  String get weekdayMon => '月';

  @override
  String get weekdayTue => '火';

  @override
  String get weekdayWed => '水';

  @override
  String get weekdayThu => '木';

  @override
  String get weekdayFri => '金';

  @override
  String get weekdaySat => '土';

  @override
  String get statsTodayTitle => '今日の記録';

  @override
  String get statsTodayCorrect => '今日の正解数';

  @override
  String get statsLast7DaysTitle => '直近7日合計';

  @override
  String get statsLast7DaysCorrect => '7日間の正解数';

  @override
  String get statsTotalTitle => '総計';

  @override
  String get statsTotalCorrect => '総正解数';

  @override
  String get statsCalendarTitle => '学習カレンダー';

  @override
  String get statsRecentPace => '直近のペース';

  @override
  String get statsOpenCalendar => 'カレンダーを見る';

  @override
  String get statsBestRecords => 'ベスト記録';

  @override
  String get statsBestTimeNone => '最短 -';

  @override
  String statsBestTime(String seconds) {
    return '最短 ${seconds}s';
  }

  @override
  String get statsBestScoreNone => '正解 -';

  @override
  String statsBestScore(int correct, int streak) {
    return '正解 $correct / 連続 $streak';
  }

  @override
  String get menuTitle => 'メニュー';

  @override
  String get menuGetStarted => 'はじめに';

  @override
  String get menuPseudocodeDesc => '変数と出力を追う';

  @override
  String get menuControlFlowDesc => '分岐とループの流れ';

  @override
  String get menuBinaryToDecimalDesc => '2進数を10進数へ';

  @override
  String get menuDecimalToBinaryDesc => '10進数を2進数へ';

  @override
  String get menuBinaryMixedDesc => 'ランダム出題';

  @override
  String get menuLinks => 'リンク';

  @override
  String get menuOfficialWebsite => '公式WEBサイト';

  @override
  String get menuOfficialWebsiteDesc => '最新情報はこちら';

  @override
  String get menuOtherApps => '他のアプリ一覧';

  @override
  String get menuOtherAppsDesc => 'シリーズをチェック';

  @override
  String get menuAbout => 'このアプリについて';

  @override
  String get menuLicenses => 'ライセンス';

  @override
  String get menuLicensesDesc => '使用しているライブラリ';

  @override
  String get menuOpenLinkError => 'リンクを開けませんでした';

  @override
  String get rankingComingSoon => 'ランキング機能は近日公開予定です';

  @override
  String get introPointsTitle => 'ポイント';

  @override
  String get introSolutionTitle => '解き方';

  @override
  String get introPseudocodePoints => '変数の値がどう変わるかを順番に追います。';

  @override
  String get introPseudocodeSolution => '疑似コードを上から実行し、最後の出力や値を入力します。';

  @override
  String get introControlFlowPoints => '条件の真偽と繰り返し回数を整理します。';

  @override
  String get introControlFlowSolution => '分岐の結果やループ回数、最終出力を数字で答えます。';

  @override
  String get introBinaryToDecimalPoints => '各桁の重み(1,2,4,8...)を足し合わせます。';

  @override
  String get introBinaryToDecimalSolution => '2進数を10進数で入力します。';

  @override
  String get introDecimalToBinaryPoints => '2で割った余りを逆順に並べます。';

  @override
  String get introDecimalToBinarySolution => '10進数を2進数で入力します。';

  @override
  String get introBinaryMixedPoints => '変換方向を問題文で確認します。';

  @override
  String get introBinaryMixedSolution => '指定された形式で答えを入力します。';

  @override
  String get tabHome => 'Home';

  @override
  String get tabStats => 'Stats';

  @override
  String get tabRanking => 'Ranking';
}
