import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdMobService {
  static const String testDevice = 'YOUR_DEVICE_ID';
  static const int maxFailedLoadAttempts = 3;

  static final AdRequest _request = AdRequest(
    keywords: <String>['foo', 'bar'],
    contentUrl: 'http://foo.com/bar.html',
    nonPersonalizedAds: true,
  );

  BannerAd? _bannerAd;
  
  BannerAd? get bannerAd => _bannerAd;
  bool isBannerAdReady=false; 

  InterstitialAd? _interstitialAd;
  int _interstitialLoadAttempts = 0;

  RewardedAd? _rewardedAd;
  int _rewardedLoadAttempts = 0;

  RewardedInterstitialAd? _rewardedInterstitialAd;
  int _rewardedInterstitialLoadAttempts = 0;
  Timer? _adTimer;

  /// Singleton pattern
  static final AdMobService _instance = AdMobService._internal();
  factory AdMobService() => _instance;
  AdMobService._internal();

  // -----------------------------
  // Initialization
  // -----------------------------
  Future<void> initialize() async {
    await MobileAds.instance.initialize();
    await MobileAds.instance.updateRequestConfiguration(
      RequestConfiguration(testDeviceIds: [testDevice]),
    );
  }
  // -----------------------------
  // Banner Ad
  // -----------------------------
  void loadBannerAd({Function()? onLoaded}) {
    _bannerAd = BannerAd(
      adUnitId: Platform.isAndroid
          ? 'ca-app-pub-3940256099942544/6300978111' // Test banner ID
          : 'ca-app-pub-4159281980067233/9750208642',
      size: AdSize.banner,
      request: _request,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          print('BannerAd loaded.');
          onLoaded?.call();
        },
        onAdFailedToLoad: (ad, error) {
          print('BannerAd failed to load: $error');
          ad.dispose();
          _bannerAd = null;
        },
      ),
    )..load().then((value)=>isBannerAdReady=true);
  }
  /// Returns a ready-to-use widget for showing the banner
  Widget getBannerAdWidget() {
    if (_bannerAd == null) {
      loadBannerAd();
      return const SizedBox(height: 50); // Placeholder until ad loads
    }
    return Container(
      alignment: Alignment.center,
      width: _bannerAd!.size.width.toDouble(),
      height: _bannerAd!.size.height.toDouble(),
      child: AdWidget(ad: _bannerAd!),
    );
  }
  void init() {
    loadInterstitialAd();
    _startAdTimer();
  }
  void _startAdTimer() {
    _adTimer?.cancel();
    _adTimer = Timer.periodic(const Duration(minutes: 2), (timer) {
      print('🕑 Timer triggered: showing ad if available...');
      showInterstitialAd();
    });
  }
  // -----------------------------
  // Interstitial Ad
  // -----------------------------
  void loadInterstitialAd() {
    InterstitialAd.load(
      adUnitId: Platform.isAndroid
          ? 'ca-app-pub-3940256099942544/1033173712'
          : 'ca-app-pub-4159281980067233/4153309174',
      request: _request,
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) {
          _interstitialAd = ad;
          _interstitialLoadAttempts = 0;
          _interstitialAd!.setImmersiveMode(true);
          print('InterstitialAd loaded.');
        },
        onAdFailedToLoad: (LoadAdError error) {
          print('InterstitialAd failed to load: $error');
          _interstitialAd = null;
          _interstitialLoadAttempts++;
          if (_interstitialLoadAttempts < maxFailedLoadAttempts) {
            loadInterstitialAd();
          }
        },
      ),
    );
  }

  void showInterstitialAd() {
    if (_interstitialAd == null) {
      print('Warning: Interstitial ad not loaded yet.');
      return;
    }

    _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (ad) => print('Interstitial shown.'),
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        loadInterstitialAd();
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        print('Interstitial failed to show: $error');
        ad.dispose();
        loadInterstitialAd();
      },
    );

    _interstitialAd!.show();
    _interstitialAd = null;
  }

  // -----------------------------
  // Rewarded Ad
  // -----------------------------
  void loadRewardedAd() {
    RewardedAd.load(
      adUnitId: Platform.isAndroid
          ? 'ca-app-pub-3940256099942544/5224354917'
          : 'ca-app-pub-3940256099942544/1712485313',
      request: _request,
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (RewardedAd ad) {
          _rewardedAd = ad;
          _rewardedLoadAttempts = 0;
          print('RewardedAd loaded.');
        },
        onAdFailedToLoad: (LoadAdError error) {
          print('RewardedAd failed to load: $error');
          _rewardedAd = null;
          _rewardedLoadAttempts++;
          if (_rewardedLoadAttempts < maxFailedLoadAttempts) {
            loadRewardedAd();
          }
        },
      ),
    );
  }

  void showRewardedAd({required Function(RewardItem) onRewarded}) {
    if (_rewardedAd == null) {
      print('Warning: Rewarded ad not loaded yet.');
      return;
    }

    _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (ad) => print('RewardedAd shown.'),
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        loadRewardedAd();
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        print('RewardedAd failed to show: $error');
        ad.dispose();
        loadRewardedAd();
      },
    );

    _rewardedAd!.setImmersiveMode(true);
    _rewardedAd!.show(onUserEarnedReward: (ad, reward) {
      onRewarded(reward);
    });
    _rewardedAd = null;
  }

  // -----------------------------
  // Rewarded Interstitial Ad
  // -----------------------------
  void loadRewardedInterstitialAd() {
    RewardedInterstitialAd.load(
      adUnitId: Platform.isAndroid
          ? 'ca-app-pub-3940256099942544/5354046379'
          : 'ca-app-pub-3940256099942544/6978759866',
      request: _request,
      rewardedInterstitialAdLoadCallback: RewardedInterstitialAdLoadCallback(
        onAdLoaded: (RewardedInterstitialAd ad) {
          _rewardedInterstitialAd = ad;
          _rewardedInterstitialLoadAttempts = 0;
          print('RewardedInterstitialAd loaded.');
        },
        onAdFailedToLoad: (LoadAdError error) {
          print('RewardedInterstitialAd failed to load: $error');
          _rewardedInterstitialAd = null;
          _rewardedInterstitialLoadAttempts++;
          if (_rewardedInterstitialLoadAttempts < maxFailedLoadAttempts) {
            loadRewardedInterstitialAd();
          }
        },
      ),
    );
  }

  void showRewardedInterstitialAd({required Function(RewardItem) onRewarded}) {
    if (_rewardedInterstitialAd == null) {
      print('Warning: Rewarded Interstitial ad not loaded yet.');
      return;
    }

    _rewardedInterstitialAd!.fullScreenContentCallback =
        FullScreenContentCallback(
      onAdShowedFullScreenContent: (ad) => print('RewardedInterstitial shown.'),
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        loadRewardedInterstitialAd();
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        print('RewardedInterstitial failed to show: $error');
        ad.dispose();
        loadRewardedInterstitialAd();
      },
    );

    _rewardedInterstitialAd!.setImmersiveMode(true);
    _rewardedInterstitialAd!.show(onUserEarnedReward: (ad, reward) {
      onRewarded(reward);
    });
    _rewardedInterstitialAd = null;
  }

  // -----------------------------
  // Cleanup
  // -----------------------------
  void dispose() {
    _bannerAd?.dispose();
    _interstitialAd?.dispose();
    _rewardedAd?.dispose();
    _rewardedInterstitialAd?.dispose();
  }
}
