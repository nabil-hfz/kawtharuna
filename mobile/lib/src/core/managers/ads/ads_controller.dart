import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'preloaded_banner_ad.dart';

/// Allows showing ads. A facade for `package:google_mobile_ads`.
class AdsController {
  final MobileAds _instance;
  static AdsController? instance;

  PreloadedBannerAd? _preloadedAd;

  /// Creates an [AdsController] that wraps around a [MobileAds] [instance].
  ///
  /// Example usage:
  ///
  ///     var controller = AdsController(MobileAds.instance);
  AdsController(MobileAds instance) : _instance = instance;

  static AdsController initGameService() {
    AdsController? adsController;
    if (!kIsWeb && (Platform.isIOS || Platform.isAndroid)) {
      /// Prepare the google_mobile_ads plugin so that the first ad loads
      /// faster. This can be done later or with a delay if startup
      /// experience suffers.
      adsController = AdsController(MobileAds.instance);
      adsController.initialize();
    }
    return instance = adsController!;
  }

  void dispose() {
    _preloadedAd?.dispose();
  }

  /// Initializes the injected [MobileAds.instance].
  Future<void> initialize() async {
    await _instance.initialize();
  }

  /// Starts preloading an ad to be used later.
  ///
  /// The work doesn't start immediately so that calling this doesn't have
  /// adverse effects (jank) during start of a new screen.
  void preloadAd() {
    // TODO: When ready, change this to the Ad Unit IDs provided by AdMob.
    //       The current values are AdMob's sample IDs.
    final adUnitId = defaultTargetPlatform == TargetPlatform.android
        ? 'ca-app-pub-3940256099942544/6300978111'
        // iOS
        : 'ca-app-pub-3940256099942544/2934735716';
    _preloadedAd =
        PreloadedBannerAd(size: AdSize.mediumRectangle, adUnitId: adUnitId);

    // Wait a bit so that calling at start of a new screen doesn't have
    // adverse effects on performance.
    Future<void>.delayed(const Duration(seconds: 1)).then((_) {
      return _preloadedAd!.load();
    });
  }

  /// Allows caller to take ownership of a [PreloadedBannerAd].
  ///
  /// If this method returns a non-null value, then the caller is responsible
  /// for disposing of the loaded ad.
  PreloadedBannerAd? takePreloadedAd() {
    final ad = _preloadedAd;
    _preloadedAd = null;
    return ad;
  }
}
