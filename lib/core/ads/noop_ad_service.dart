import 'ad_service.dart';

class NoopAdService implements AdService {
  @override
  Future<void> init() async {}

  @override
  Future<void> maybeShowInterstitial(String placement) async {}
}
