import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/route_manager.dart';

import '../helpers/ad_helper.dart';
import '../main.dart';
import 'home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 1500), () {
      //exit full-screen
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

      AdHelper.precacheInterstitialAd();
      AdHelper.precacheNativeAd();

      //navigate to home
      Get.off(() => HomeScreen());
    });
  }

  @override
  Widget build(BuildContext context) {
    //initializing media query (for getting device screen size)
    mq = MediaQuery.of(context).size;

    return Scaffold(
        backgroundColor:
            Get.isDarkMode ? AppColors.blackHalf : AppColors.whiteColor,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(Get.isDarkMode
                    ? 'assets/images/logo_dark.png'
                    : 'assets/images/logo.png'),
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: 'Welcome\n',
                        style: TextStyle(
                          color: AppColors.orangeAccentColor,
                          fontSize: 34,
                          fontFamily: 'Pacifico',
                        ),
                      ),
                      TextSpan(
                        text: 'To\n',
                        style: TextStyle(
                          color: AppColors.orangeAccentColor,
                          fontSize: 24,
                          fontFamily: 'Pacifico',
                        ),
                      ),
                      TextSpan(
                        text: 'Safe VPN',
                        style: TextStyle(
                          color: AppColors.orangeAccentColor,
                          fontSize: 34,
                          fontFamily: 'Pacifico',
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
