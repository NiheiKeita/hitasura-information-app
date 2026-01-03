import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/clock/clock.dart';
import '../../core/ads/ad_config.dart';
import '../../core/ads/banner_ad_widget.dart';
import 'package:go_router/go_router.dart';

import '../../core/navigation/route_args.dart';
import '../../core/storage/stats_repository.dart';
import '../calendar/container/calendar_container.dart';
import '../home/container/home_container.dart';
import '../intro/presentation/intro_presentation.dart';
import '../menu/presentation/menu_presentation.dart';
import '../mode_select/container/mode_select_container.dart';
import '../ranking/container/ranking_container.dart';
import '../stats/container/stats_container.dart';

class TabsContainer extends StatefulWidget {
  const TabsContainer({
    super.key,
    required this.statsRepository,
    required this.clock,
  });

  final StatsRepository statsRepository;
  final Clock clock;

  @override
  State<TabsContainer> createState() => _TabsContainerState();
}

class _TabsContainerState extends State<TabsContainer> {
  final PageController _controller = PageController();
  final GlobalKey<NavigatorState> _homeNavigatorKey =
      GlobalKey<NavigatorState>();
  final GlobalKey<NavigatorState> _statsNavigatorKey =
      GlobalKey<NavigatorState>();
  int _currentIndex = 0;
  Widget? _banner;

  @override
  void initState() {
    super.initState();
    final bannerId = AdConfig.bannerId();
    if (bannerId.isNotEmpty) {
      _banner = BannerAdWidget(adUnitId: bannerId);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _setIndex(int index) {
    if (index == _currentIndex) {
      if (index == 0) {
        _homeNavigatorKey.currentState?.popUntil((route) => route.isFirst);
      }
      return;
    }
    setState(() {
      _currentIndex = index;
    });
    if (index == 0) {
      _homeNavigatorKey.currentState?.popUntil((route) => route.isFirst);
    }
    _controller.animateToPage(
      index,
      duration: const Duration(milliseconds: 280),
      curve: Curves.easeOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _controller,
        physics: const NeverScrollableScrollPhysics(),
        onPageChanged: (index) => setState(() => _currentIndex = index),
        children: [
          Navigator(
            key: _homeNavigatorKey,
            onGenerateRoute: (settings) {
              return MaterialPageRoute(
                builder: (context) => HomeContainer(
                  statsRepository: widget.statsRepository,
                  clock: widget.clock,
                  onSelectCategory: (category) {
                    _homeNavigatorKey.currentState?.push(
                      MaterialPageRoute(
                        builder: (context) => ModeSelectContainer(
                          category: category,
                          onStart: (mode, difficulty) {
                            GoRouter.of(context).goNamed(
                              'practice',
                              extra: PracticeArgs(
                                category: category,
                                mode: mode,
                                difficulty: difficulty,
                              ),
                            );
                          },
                        ),
                      ),
                    );
                  },
                  onOpenStats: () => _setIndex(1),
                  onOpenRanking: () => _setIndex(2),
                          onOpenMenu: () {
                    _homeNavigatorKey.currentState?.push(
                      MaterialPageRoute(
                        builder: (menuContext) => MenuPresentation(
                          onOpenPseudocodeIntro: () {
                            Navigator.of(menuContext).push(
                              MaterialPageRoute(
                                builder: (_) => const InfoIntroPresentation(
                                  title: '疑似コードの実行結果',
                                  sections: [
                                    IntroSection(
                                      title: 'ポイント',
                                      body: '変数の値がどう変わるかを順番に追います。',
                                    ),
                                    IntroSection(
                                      title: '解き方',
                                      body:
                                          '疑似コードを上から実行し、最後の出力や値を入力します。',
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                          onOpenControlFlowIntro: () {
                            Navigator.of(menuContext).push(
                              MaterialPageRoute(
                                builder: (_) => const InfoIntroPresentation(
                                  title: 'if / for / while の処理追跡',
                                  sections: [
                                    IntroSection(
                                      title: 'ポイント',
                                      body: '条件の真偽と繰り返し回数を整理します。',
                                    ),
                                    IntroSection(
                                      title: '解き方',
                                      body:
                                          '分岐の結果やループ回数、最終出力を数字で答えます。',
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                          onOpenBinaryToDecimalIntro: () {
                            Navigator.of(menuContext).push(
                              MaterialPageRoute(
                                builder: (_) => const InfoIntroPresentation(
                                  title: '2進数→10進数',
                                  sections: [
                                    IntroSection(
                                      title: 'ポイント',
                                      body: '各桁の重み(1,2,4,8...)を足し合わせます。',
                                    ),
                                    IntroSection(
                                      title: '解き方',
                                      body: '2進数を10進数で入力します。',
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                          onOpenDecimalToBinaryIntro: () {
                            Navigator.of(menuContext).push(
                              MaterialPageRoute(
                                builder: (_) => const InfoIntroPresentation(
                                  title: '10進数→2進数',
                                  sections: [
                                    IntroSection(
                                      title: 'ポイント',
                                      body: '2で割った余りを逆順に並べます。',
                                    ),
                                    IntroSection(
                                      title: '解き方',
                                      body: '10進数を2進数で入力します。',
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                          onOpenBinaryMixedIntro: () {
                            Navigator.of(menuContext).push(
                              MaterialPageRoute(
                                builder: (_) => const InfoIntroPresentation(
                                  title: '2進数/10進数ミックス',
                                  sections: [
                                    IntroSection(
                                      title: 'ポイント',
                                      body: '変換方向を問題文で確認します。',
                                    ),
                                    IntroSection(
                                      title: '解き方',
                                      body: '指定された形式で答えを入力します。',
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                          onOpenLicenses: () {
                            showLicensePage(
                              context: menuContext,
                              applicationName: 'ひたすら情報',
                            );
                          },
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          ),
          Navigator(
            key: _statsNavigatorKey,
            onGenerateRoute: (settings) {
              return MaterialPageRoute(
                builder: (context) => StatsContainer(
                  statsRepository: widget.statsRepository,
                  clock: widget.clock,
                  onOpenCalendar: () {
                    _statsNavigatorKey.currentState?.push(
                      MaterialPageRoute(
                        builder: (context) => CalendarContainer(
                          statsRepository: widget.statsRepository,
                          clock: widget.clock,
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          ),
          const RankingContainer(),
        ],
      ),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (_banner != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Center(child: _banner!),
            ),
          BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: (index) {
              HapticFeedback.lightImpact();
              _setIndex(index);
            },
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.bar_chart),
                label: 'Stats',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.emoji_events),
                label: 'Ranking',
              ),
            ],
          ),
        ],
      ),
    );
  }
}
