import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../res/colors.dart';
import '../res/uris.dart';

class AnnoyingBanner extends StatelessWidget {

  const AnnoyingBanner({
   super.key,
    required this.bannerKey,
    required this.hideBanner,
});

  final void Function() hideBanner;
  final GlobalKey bannerKey;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(child: Image.asset("images/banners/banner_main_background.png", fit: BoxFit.fill,)),
        Center(
          child: GestureDetector(
            onTapUp: (TapUpDetails details) async {
              Size bannerSize = getWidgetSize(bannerKey);
              bool condition1 = details.localPosition.dx >= bannerSize.width * 0.86
                  && details.localPosition.dx <= bannerSize.width * 0.96;
              bool condition2 = details.localPosition.dy >= bannerSize.height * 0.02
                  && details.localPosition.dy <= bannerSize.height * 0.07;
              if(condition1 && condition2) {
                hideBanner();
              }
              else {
                await launchUrl(bannersUri);
              }
            },
            child: Image.asset("images/banners/banner_main.png",
              key: bannerKey,
            ),
          ),
        ),
      ],
    );
  }

  Size getWidgetSize(GlobalKey key) {
    RenderBox? box = key.currentContext?.findRenderObject() as RenderBox?;
    if(box != null) {
      return box.size;
    }
    return Size.zero;
  }

  Widget bannerBackground() {
    return Expanded(
      child: Column(
        children: [
          Container(
            height: getWidgetSize(bannerKey).height * 0.098,
            decoration: BoxDecoration(
                color: defaultBackground
            ),
            child: null,
          ),
          Expanded(child: Container(
            decoration: BoxDecoration(
                color: inactive
            ),
            child: null,
          ),)
        ],
      ),
    );
  }
}