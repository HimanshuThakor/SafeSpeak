import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:safespeak/Services/SocketManager.dart';
import 'package:safespeak/Support/Widgets/primary_button.dart';
import 'package:safespeak/Utils/ApiHelper.dart';
import 'package:safespeak/Utils/app_colors.dart';
import 'package:safespeak/models/onboarding.dart';
import 'package:safespeak/view/authentication/SignInScreen.dart';
import 'package:safespeak/view/authentication/bunny_login.dart';
import 'package:safespeak/view/authentication/kochalo_login.dart';
import 'package:safespeak/view/authentication/man_login.dart';
import 'package:safespeak/view/onboarding/components/next_button.dart';
import 'package:safespeak/view/onboarding/components/onboarding_card.dart';
import 'package:safespeak/view/onboarding/components/skip_button.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  OnboardingScreenState createState() => OnboardingScreenState();
}

class OnboardingScreenState extends State<OnboardingScreen> {
  int _currentPageIndex = 0;
  late IO.Socket _socket;
  final _pageController = PageController();
  final socketManager = SocketManager();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _connectSocket();
  }

  void _connectSocket() {
    _socket = IO.io(
        ApiHelper.socketUrl,
        IO.OptionBuilder()
            .setTransports(['websocket'])
            .setExtraHeaders({"Content-type": "application/json"})
            .setTimeout(30000)
            .enableAutoConnect()
            .enableReconnection()
            .enableForceNewConnection()
            .build());

    _socket.onConnect((data) => print('Connection established on count Read'));
    _socket.onConnectError(
      (data) => socketManager.connectWithRetry(),
    );
    // _socket.onConnectTimeout((data) {
    //   socketManager.connectWithRetry();
    // });
    _socket.onDisconnect(
        (data) => print('Socket.IO server disconnected on count'));

    _socket.on('login_success', (data) {
      if (data != null) {
        print("Data=$data");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkMode(BuildContext context) =>
        Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor:
          isDarkMode(context) ? AppColors.kDarkBackground : AppColors.kWhite,
      appBar: AppBar(
        backgroundColor:
            isDarkMode(context) ? AppColors.kDarkBackground : AppColors.kWhite,
        actions: [
          SkipButton(
            onTap: () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ManLoginScreen(),
                  ));
              // Navigator.pushAndRemoveUntil(
              //     context,
              //     MaterialPageRoute(
              //       builder: (context) => SignInScreen(),
              //     ),);
              // Get.offAll(() => const SignIn());
            },
          ),
          SizedBox(width: 16.w),
        ],
      ),
      body: Column(
        children: [
          Expanded(
              child: PageView.builder(
            itemCount: onboardingList.length,
            controller: _pageController,
            physics: const NeverScrollableScrollPhysics(),
            onPageChanged: (index) {
              setState(() {
                _currentPageIndex = index;
              });
            },
            itemBuilder: (context, index) {
              return OnboardingCard(
                playAnimation: true,
                onboarding: onboardingList[index],
              );
            },
          )),
          SmoothPageIndicator(
              controller: _pageController,
              count: onboardingList.length,
              effect: WormEffect(
                  dotHeight: 8.h,
                  dotWidth: 8.w,
                  dotColor: AppColors.kPrimary.withOpacity(0.2)),
              onDotClicked: (index) {
                setState(() {
                  _currentPageIndex = index;
                });
                _pageController.animateToPage(
                  index,
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeInOut,
                );
              }),
          SizedBox(height: 30.h),
          (_currentPageIndex < onboardingList.length - 1)
              ? NextButton(onTap: () {
                  _pageController.nextPage(
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeInOut,
                  );
                })
              : PrimaryButton(
                  onTap: () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BunnyLoginScreen(),
                        ));
                    // Get.offAll(() => const SignIn(),
                    //     transition: Transition.zoom);
                  },
                  width: 166.w,
                  text: 'Get Started',
                ),
          SizedBox(height: 20.h),
        ],
      ),
    );
  }
}
