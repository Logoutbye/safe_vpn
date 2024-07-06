// ignore_for_file: must_be_immutable

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:safe_vpn/helpers/ad_helper.dart';
import 'package:safe_vpn/helpers/config.dart';
import 'package:safe_vpn/helpers/pref.dart';
import 'package:safe_vpn/main.dart';
import 'package:safe_vpn/screens/location_screen.dart';
import 'package:safe_vpn/screens/network_test_screen.dart';
import 'package:safe_vpn/widgets/watch_ad_dialog.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class MyDrawer extends StatelessWidget {
  MyDrawer({
    super.key,
    required this.width,
  });

  final double width;

  Future<void> _launchInBrowser() async {
    var url = Uri.parse(
        'https://ginnieworks.blogspot.com/p/privacy-policy-notebook.html?m=1');
    if (!await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    )) {
      throw Exception('Could not launch $url');
    }
  }

  void shareApp() {
    const String appLinkAndroid =
        'https://play.google.com/store/apps/details?id=com.ginnieworks.notepad.sticky.color.notebook';
    const String appLinkiOS =
        'https://apps.apple.com/app/notepad-notes-memo-checklist/id6505040369';

    if (Platform.isAndroid) {
      Share.share('Check out this amazing app: $appLinkAndroid');
    } else if (Platform.isIOS) {
      Share.share('Check out this amazing app: $appLinkiOS');
    }
  }

  _moreApps() async {
    final url = 'https://play.google.com/store/apps/developer?id=GinnieWorks';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch Play Store';
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Drawer(
      width: width,
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.cancel_outlined))
            ],
          ),
          // theme
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: InkWell(
              onTap: () {
                //ad dialog

                if (Config.hideAds) {
                  Get.changeThemeMode(
                      Pref.isDarkMode ? ThemeMode.light : ThemeMode.dark);
                  Pref.isDarkMode = !Pref.isDarkMode;
                  return;
                }

                Get.dialog(WatchAdDialog(onComplete: () {
                  //watch ad to gain reward
                  AdHelper.showRewardedAd(onComplete: () {
                    Get.changeThemeMode(
                        Pref.isDarkMode ? ThemeMode.light : ThemeMode.dark);
                    Pref.isDarkMode = !Pref.isDarkMode;
                  });
                }));
              },
              child: Container(
                margin: const EdgeInsets.all(8),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                        color: Get.isDarkMode
                            ? AppColors.whiteColor
                            : AppColors.black)),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Leading widget
                    Row(
                      children: [
                        Icon(Icons.brightness_medium),
                        // Text widget as the button label
                        Padding(
                          padding: EdgeInsets.only(left: 18.0),
                          child: Text('Change Theme'),
                        ),
                      ],
                    ),

                    // Trailing widget
                    Icon(Icons.arrow_forward_ios),
                  ],
                ),
              ),
            ),
          ),
          // network
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: InkWell(
              onTap: () {
                Navigator.pop(context);
                Get.to(() => LocationScreen());
              },
              child: Container(
                margin: const EdgeInsets.all(8),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                        color: Get.isDarkMode
                            ? AppColors.whiteColor
                            : AppColors.black)),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Leading widget
                    Row(
                      children: [
                        Icon(Icons.equalizer_rounded),
                        // Text widget as the button label
                        Padding(
                          padding: EdgeInsets.only(left: 18.0),
                          child: Text('Change Server'),
                        ),
                      ],
                    ),

                    // Trailing widget
                    Icon(Icons.arrow_forward_ios),
                  ],
                ),
              ),
            ),
          ),

          // network
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: InkWell(
              onTap: () {
                Navigator.pop(context);
                Get.to(() => NetworkTestScreen());
              },
              child: Container(
                margin: const EdgeInsets.all(8),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                        color: Get.isDarkMode
                            ? AppColors.whiteColor
                            : AppColors.black)),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Leading widget
                    Row(
                      children: [
                        Icon(Icons.info),
                        // Text widget as the button label
                        Padding(
                          padding: EdgeInsets.only(left: 18.0),
                          child: Text('Network Details'),
                        ),
                      ],
                    ),

                    // Trailing widget
                    Icon(Icons.arrow_forward_ios),
                  ],
                ),
              ),
            ),
          ),

          //  privacy policy
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: InkWell(
              onTap: () {
                Navigator.pop(context);
                _launchInBrowser();
              },
              child: Container(
                margin: const EdgeInsets.all(8),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                        color: Get.isDarkMode
                            ? AppColors.whiteColor
                            : AppColors.black)),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Leading widget
                    Row(
                      children: [
                        Icon(Icons.privacy_tip_outlined),
                        // Text widget as the button label
                        Padding(
                          padding: const EdgeInsets.only(left: 18.0),
                          child: Text('Privacy Policy'),
                        ),
                      ],
                    ),

                    // Trailing widget
                    Icon(Icons.arrow_forward_ios),
                  ],
                ),
              ),
            ),
          ),
          // more apps
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: InkWell(
              onTap: () {
                Navigator.pop(context);
                _moreApps();
              },
              child: Container(
                margin: const EdgeInsets.all(8),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                        color: Get.isDarkMode
                            ? AppColors.whiteColor
                            : AppColors.black)),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Leading widget
                    Row(
                      children: [
                        Icon(Icons.dashboard),
                        // Text widget as the button label
                        Padding(
                          padding: EdgeInsets.only(left: 18.0),
                          child: Text('More Apps'),
                        ),
                      ],
                    ),

                    // Trailing widget
                    Icon(Icons.arrow_forward_ios),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    ));
  }
}
