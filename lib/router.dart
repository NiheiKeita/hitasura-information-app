import 'package:go_router/go_router.dart';

import 'core/ads/ad_service.dart';
import 'core/clock/clock.dart';
import 'core/navigation/route_args.dart';
import 'core/storage/stats_repository.dart';
import 'features/calendar/container/calendar_container.dart';
import 'features/mode_select/container/mode_select_container.dart';
import 'features/practice/container/practice_container.dart';
import 'features/practice/domain/generators/problem_generator.dart';
import 'features/practice/domain/problem.dart';
import 'features/result/container/result_container.dart';
import 'features/tabs/tabs_container.dart';

GoRouter createRouter({
  required StatsRepository statsRepository,
  required InfoProblemGenerator infoProblemGenerator,
  required Clock clock,
  required AdService adService,
}) {
  return GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        name: 'home',
        builder: (context, state) => TabsContainer(
          statsRepository: statsRepository,
          clock: clock,
        ),
      ),
      GoRoute(
        path: '/mode',
        name: 'mode',
        builder: (context, state) {
          final args = state.extra as ModeSelectArgs;
          return ModeSelectContainer(
            category: args.category,
            onStart: (mode, difficulty) {
              context.goNamed(
                'practice',
                extra: PracticeArgs(
                  category: args.category,
                  mode: mode,
                  difficulty: difficulty,
                ),
              );
            },
          );
        },
      ),
      GoRoute(
        path: '/practice',
        name: 'practice',
        builder: (context, state) {
          final args = state.extra as PracticeArgs;
          return PracticeContainer(
            category: args.category,
            mode: args.mode,
            difficulty: args.difficulty,
            infoProblemGenerator: infoProblemGenerator,
            statsRepository: statsRepository,
            clock: clock,
            adService: adService,
            onFinish: (result) => context.goNamed('result', extra: result),
            onExit: () => context.goNamed('home'),
          );
        },
      ),
      GoRoute(
        path: '/calendar',
        name: 'calendar',
        builder: (context, state) {
          return CalendarContainer(
            statsRepository: statsRepository,
            clock: clock,
          );
        },
      ),
      GoRoute(
        path: '/result',
        name: 'result',
        builder: (context, state) {
          final result = state.extra as PracticeResult;
          return ResultContainer(
            result: result,
            adService: adService,
            onRetry: () {
              context.goNamed(
                'practice',
                extra: PracticeArgs(
                  category: result.category,
                  mode: result.mode,
                  difficulty: result.difficulty,
                ),
              );
            },
            onHome: () => context.goNamed('home'),
          );
        },
      ),
    ],
  );
}
