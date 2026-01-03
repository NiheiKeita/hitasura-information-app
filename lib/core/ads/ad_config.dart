import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AdConfig {
  static String interstitialId() {
    return _byPlatform(
      iosKey: 'ADMOB_IOS_INTERSTITIAL',
      androidKey: 'ADMOB_ANDROID_INTERSTITIAL',
      fallbackIosKey: 'ADMOB_IOS',
      fallbackAndroidKey: 'ADMOB_ANDROID',
    );
  }

  static String bannerId() {
    return _byPlatform(
      iosKey: 'ADMOB_IOS_BANNER',
      androidKey: 'ADMOB_ANDROID_BANNER',
      fallbackIosKey: 'ADMOB_IOS',
      fallbackAndroidKey: 'ADMOB_ANDROID',
    );
  }

  static String _byPlatform({
    required String iosKey,
    required String androidKey,
    required String fallbackIosKey,
    required String fallbackAndroidKey,
  }) {
    final platform = defaultTargetPlatform;
    if (platform == TargetPlatform.iOS) {
      return dotenv.env[iosKey] ??
          dotenv.env[fallbackIosKey] ??
          '';
    }
    return dotenv.env[androidKey] ??
        dotenv.env[fallbackAndroidKey] ??
        '';
  }
}
