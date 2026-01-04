import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../clock/clock.dart';
import 'ad_service.dart';

class AdMobAdService implements AdService {
  AdMobAdService({
    required this.clock,
    required this.adUnitId,
    this.cooldownMinutes = 10,
  });

  final Clock clock;
  final String adUnitId;
  final int cooldownMinutes;

  InterstitialAd? _interstitial;
  DateTime? _lastShownAt;
  bool _loading = false;

  @override
  Future<void> init() async {
    if (kIsWeb) {
      return;
    }
    await MobileAds.instance.updateRequestConfiguration(
      RequestConfiguration(
        testDeviceIds: const [
          '0110c468cca81d0dd5af2e70bea43369',
          'e4030c9ba31d3567bca3f762c66ec016',
        ],
      ),
    );
    await MobileAds.instance.initialize();
    _loadInterstitial();
  }

  @override
  Future<void> maybeShowInterstitial(String placement) async {
    if (kIsWeb) {
      return;
    }
    if (adUnitId.isEmpty) {
      return;
    }
    if (!_canShow()) {
      return;
    }
    if (_interstitial == null) {
      _loadInterstitial();
      return;
    }
    _interstitial!.show();
    _lastShownAt = clock.now();
    _interstitial = null;
    _loadInterstitial();
  }

  bool _canShow() {
    final last = _lastShownAt;
    if (last == null) {
      return true;
    }
    final diff = clock.now().difference(last);
    return diff.inMinutes >= cooldownMinutes;
  }

  void _loadInterstitial() {
    if (_loading || adUnitId.isEmpty || kIsWeb) {
      return;
    }
    _loading = true;
    InterstitialAd.load(
      adUnitId: adUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _loading = false;
          _interstitial = ad;
          _interstitial!.fullScreenContentCallback =
              FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              ad.dispose();
              _interstitial = null;
              _loadInterstitial();
            },
            onAdFailedToShowFullScreenContent: (ad, error) {
              ad.dispose();
              _interstitial = null;
              _loadInterstitial();
            },
          );
        },
        onAdFailedToLoad: (error) {
          _loading = false;
          _interstitial = null;
        },
      ),
    );
  }
}
