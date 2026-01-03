import 'package:flutter/material.dart';

import '../../../core/ads/ad_config.dart';
import '../../../core/ads/ad_service.dart';
import '../../../core/ads/banner_ad_widget.dart';
import '../../practice/domain/enums.dart';
import '../../practice/domain/problem.dart';
import '../presentation/result_presentation.dart';

class ResultContainer extends StatefulWidget {
  const ResultContainer({
    super.key,
    required this.result,
    required this.adService,
    required this.onRetry,
    required this.onHome,
  });

  final PracticeResult result;
  final AdService adService;
  final VoidCallback onRetry;
  final VoidCallback onHome;

  @override
  State<ResultContainer> createState() => _ResultContainerState();
}

class _ResultContainerState extends State<ResultContainer> {
  Widget? _banner;

  @override
  void initState() {
    super.initState();
    final bannerId = AdConfig.bannerId();
    if (bannerId.isNotEmpty) {
      _banner = BannerAdWidget(adUnitId: bannerId);
    }
    _maybeShowAd();
  }

  Future<void> _maybeShowAd() async {
    if (widget.result.mode != PracticeMode.timeAttack10) {
      return;
    }
    await Future.delayed(const Duration(milliseconds: 600));
    if (!mounted) {
      return;
    }
    await widget.adService.maybeShowInterstitial('time_attack_end');
  }

  @override
  Widget build(BuildContext context) {
    return ResultPresentation(
      result: widget.result,
      banner: _banner,
      onRetry: widget.onRetry,
      onHome: widget.onHome,
    );
  }
}
