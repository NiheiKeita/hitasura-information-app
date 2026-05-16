import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/clock/clock.dart';
import '../../core/ads/ad_config.dart';
import '../../core/ads/banner_ad_widget.dart';
import 'package:go_router/go_router.dart';

import '../../core/l10n/l10n.dart';
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
                        builder: (menuContext) {
                          final l10n = menuContext.l10n;
                          return MenuPresentation(
                            onOpenPseudocodeIntro: () {
                              Navigator.of(menuContext).push(
                                MaterialPageRoute(
                                  builder: (introContext) {
                                    final il = introContext.l10n;
                                    return InfoIntroPresentation(
                                      title: il.categoryPseudocodeExecution,
                                      sections: [
                                        IntroSection(
                                          title: il.introPointsTitle,
                                          body: il.introPseudocodePoints,
                                        ),
                                        IntroSection(
                                          title: il.introSolutionTitle,
                                          body: il.introPseudocodeSolution,
                                        ),
                                      ],
                                    );
                                  },
                                ),
                              );
                            },
                            onOpenControlFlowIntro: () {
                              Navigator.of(menuContext).push(
                                MaterialPageRoute(
                                  builder: (introContext) {
                                    final il = introContext.l10n;
                                    return InfoIntroPresentation(
                                      title: il.categoryControlFlowTrace,
                                      sections: [
                                        IntroSection(
                                          title: il.introPointsTitle,
                                          body: il.introControlFlowPoints,
                                        ),
                                        IntroSection(
                                          title: il.introSolutionTitle,
                                          body: il.introControlFlowSolution,
                                        ),
                                      ],
                                    );
                                  },
                                ),
                              );
                            },
                            onOpenBinaryToDecimalIntro: () {
                              Navigator.of(menuContext).push(
                                MaterialPageRoute(
                                  builder: (introContext) {
                                    final il = introContext.l10n;
                                    return InfoIntroPresentation(
                                      title: il.categoryBinaryToDecimal,
                                      sections: [
                                        IntroSection(
                                          title: il.introPointsTitle,
                                          body: il.introBinaryToDecimalPoints,
                                        ),
                                        IntroSection(
                                          title: il.introSolutionTitle,
                                          body:
                                              il.introBinaryToDecimalSolution,
                                        ),
                                      ],
                                    );
                                  },
                                ),
                              );
                            },
                            onOpenDecimalToBinaryIntro: () {
                              Navigator.of(menuContext).push(
                                MaterialPageRoute(
                                  builder: (introContext) {
                                    final il = introContext.l10n;
                                    return InfoIntroPresentation(
                                      title: il.categoryDecimalToBinary,
                                      sections: [
                                        IntroSection(
                                          title: il.introPointsTitle,
                                          body: il.introDecimalToBinaryPoints,
                                        ),
                                        IntroSection(
                                          title: il.introSolutionTitle,
                                          body:
                                              il.introDecimalToBinarySolution,
                                        ),
                                      ],
                                    );
                                  },
                                ),
                              );
                            },
                            onOpenBinaryMixedIntro: () {
                              Navigator.of(menuContext).push(
                                MaterialPageRoute(
                                  builder: (introContext) {
                                    final il = introContext.l10n;
                                    return InfoIntroPresentation(
                                      title: il.categoryBinaryMixed,
                                      sections: [
                                        IntroSection(
                                          title: il.introPointsTitle,
                                          body: il.introBinaryMixedPoints,
                                        ),
                                        IntroSection(
                                          title: il.introSolutionTitle,
                                          body: il.introBinaryMixedSolution,
                                        ),
                                      ],
                                    );
                                  },
                                ),
                              );
                            },
                            onOpenLicenses: () {
                              showLicensePage(
                                context: menuContext,
                                applicationName: l10n.appTitle,
                              );
                            },
                          );
                        },
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
            items: [
              BottomNavigationBarItem(
                icon: const Icon(Icons.home),
                label: context.l10n.tabHome,
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.bar_chart),
                label: context.l10n.tabStats,
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.emoji_events),
                label: context.l10n.tabRanking,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
