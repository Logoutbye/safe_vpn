import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:safe_vpn/widgets/drawer.dart';

import '../controllers/home_controller.dart';
import '../helpers/ad_helper.dart';
import '../helpers/config.dart';
import '../helpers/pref.dart';
import '../main.dart';

import '../models/vpn_status.dart';
import '../services/vpn_engine.dart';
import '../widgets/count_down_timer.dart';
import '../widgets/home_card.dart';
import '../widgets/watch_ad_dialog.dart';
import 'location_screen.dart';
import 'network_test_screen.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final _controller = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    ///Add listener to update vpn state
    VpnEngine.vpnStageSnapshot().listen((event) {
      _controller.vpnState.value = event;
    });

    return Scaffold(
        //app bar
        drawer: MyDrawer(
          width: double.infinity,
        ),
        appBar: AppBar(
          // leading: Icon(CupertinoIcons.home),
          title: Text('Safe VPN'),
          actions: [
            IconButton(
                padding: EdgeInsets.only(right: 8),
                onPressed: () => Get.to(() => NetworkTestScreen()),
                icon: Icon(
                  CupertinoIcons.info,
                  size: 27,
                )),
          ],
        ),
        bottomNavigationBar: _changeLocation(context),

        //body
        body: Stack(
          children: [
            // Lottie Animation as background
            Positioned.fill(
              child: Lottie.asset(
                Get.isDarkMode
                    ? 'assets/lottie/backgrounddark.json'
                    : 'assets/lottie/background.json',
                fit: BoxFit.cover,
              ),
            ),
            Center(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    //vpn button
                    Obx(() => _vpnButton()),

                    StreamBuilder<VpnStatus?>(
                        initialData: VpnStatus(),
                        stream: VpnEngine.vpnStatusSnapshot(),
                        builder: (context, snapshot) => Container(
                              padding: EdgeInsets.all(8),
                              margin: EdgeInsets.symmetric(horizontal: 20),
                              decoration: BoxDecoration(
                                // gradient: AppColors.gradient,
                                color: Get.isDarkMode
                                    ? AppColors.greyColor
                                    : AppColors.whiteColor,
                                borderRadius: BorderRadius.circular(19),
                              ),
                              child: FittedBox(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Row(
                                        children: [
                                          Row(children: [
                                            Icon(
                                              Icons.trending_down_rounded,
                                              color: AppColors
                                                  .orangehardAccentColor,
                                              size: 32,
                                            ),
                                            SizedBox(
                                              width: 12,
                                            ),
                                            Column(
                                              children: [
                                                Text(
                                                  '${snapshot.data?.byteIn ?? '0 kbps'}',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 18),
                                                ),
                                                Text('Download')
                                              ],
                                            )
                                          ]),
                                        ],
                                      ),
                                      Container(
                                          margin: const EdgeInsets.symmetric(
                                              horizontal: 10),
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height /
                                              20,
                                          width: 0.9,
                                          color:
                                              AppColors.orangehardAccentColor),
                                      Row(
                                        children: [
                                          Row(children: [
                                            Icon(
                                              Icons.trending_up_rounded,
                                              color: AppColors.greenColor,
                                              size: 32,
                                            ),
                                            SizedBox(
                                              width: 12,
                                            ),
                                            Column(
                                              children: [
                                                Text(
                                                  '${snapshot.data?.byteOut ?? '0 kbps'}',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 18),
                                                ),
                                                Text('Upload')
                                              ],
                                            )
                                          ]),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ))
                  ]),
            ),
          ],
        ));
  }

  //vpn button
  Widget _vpnButton() => Column(
        children: [
          //count down timer
          Obx(() => Column(
                children: [
                  Text('Connected Time'),
                  CountDownTimer(
                      startTimer:
                          _controller.vpnState.value == VpnEngine.vpnConnected),
                ],
              )),
          SizedBox(
            height: mq.height * 0.02,
          ),
          Semantics(
            button: true,
            child: InkWell(
              onTap: () {
                _controller.connectToVpn();
              },
              borderRadius: BorderRadius.circular(100),
              child: Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                    gradient: AppColors.gradient,
                    shape: BoxShape.circle,
                    color: _controller.getButtonColor.withOpacity(.1)),
                child: Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                      gradient: AppColors.gradient,
                      shape: BoxShape.circle,
                      color: _controller.getButtonColor.withOpacity(.3)),
                  child: Container(
                    width: mq.height * .14,
                    height: mq.height * .14,
                    decoration: BoxDecoration(
                        gradient: AppColors.gradient,
                        shape: BoxShape.circle,
                        color: _controller.getButtonColor),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        //icon
                        Icon(
                          Icons.power_settings_new,
                          size: 28,
                          color: Colors.white,
                        ),

                        SizedBox(height: 4),

                        //text
                        Text(
                          _controller.getButtonText,
                          style: TextStyle(
                              fontSize: 12.5,
                              color: Colors.white,
                              fontWeight: FontWeight.w500),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          //connection status label
          Container(
            margin:
                EdgeInsets.only(top: mq.height * .015, bottom: mq.height * .02),
            padding: EdgeInsets.symmetric(vertical: 6, horizontal: 16),
            decoration: BoxDecoration(
                color: Colors.blue, borderRadius: BorderRadius.circular(15)),
            child: Text(
              _controller.vpnState.value == VpnEngine.vpnDisconnected
                  ? 'Not Connected'
                  : _controller.vpnState.replaceAll('_', ' ').toUpperCase(),
              style: TextStyle(fontSize: 12.5, color: Colors.white),
            ),
          ),
        ],
      );

  //bottom nav to change location
  Widget _changeLocation(BuildContext context) => SafeArea(
          child: Semantics(
        button: true,
        child: InkWell(
          onTap: () => Get.to(() => LocationScreen()),
          child: Obx(
            () => Container(
                // padding: EdgeInsets.symmetric(horizontal: mq.width * .04),
                margin: EdgeInsets.all(8),
                decoration: BoxDecoration(
                    color: Theme.of(context).bottomNav,
                    borderRadius: BorderRadius.all(Radius.circular(20))),
                // height: 60,
                child: ListTile(
                  title: Text(_controller.vpn.value.countryLong.isEmpty
                      ? 'Tap to select Country'
                      : _controller.vpn.value.countryLong),
                  subtitle: Text('FREE'),
                  leading: CircleAvatar(
                    backgroundColor: AppColors.orangeAccentColor,
                    child: _controller.vpn.value.countryLong.isEmpty
                        ? Icon(Icons.vpn_lock_rounded,
                            size: 30, color: Colors.white)
                        : null,
                    backgroundImage: _controller.vpn.value.countryLong.isEmpty
                        ? null
                        : AssetImage(
                            'assets/flags/${_controller.vpn.value.countryShort.toLowerCase()}.png'),
                  ),
                  trailing: Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          backgroundColor:
                              Get.isDarkMode ? Colors.white : Colors.black,
                          child: Icon(Icons.keyboard_arrow_right_rounded,
                              color:
                                  Get.isDarkMode ? Colors.black : Colors.white,
                              size: 26),
                        ),
                        Text(_controller.vpn.value.countryLong.isEmpty
                            ? '100 ms'
                            : '${_controller.vpn.value.ping} ms')
                      ],
                    ),
                  ),
                )),
          ),
        ),
      ));
}
