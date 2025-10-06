import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../services/ad_service.dart';

class AdBannerWidget extends StatefulWidget {
  const AdBannerWidget({Key? key}) : super(key: key);

  @override
  State<AdBannerWidget> createState() => _AdBannerWidgetState();
}

class _AdBannerWidgetState extends State<AdBannerWidget> {
  final AdMobService _adService = AdMobService();

  @override
  void initState() {
    super.initState();
    _adService.initialize();
  }

  @override
  void dispose() {
    _adService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _adService.bannerAd == null
        ? const SizedBox()
        : SizedBox(
            height: _adService.bannerAd!.size.height.toDouble(),
            width: _adService.bannerAd!.size.width.toDouble(),
            child: AdWidget(ad: _adService.bannerAd!),
          );
  }
}