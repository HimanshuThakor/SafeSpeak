import 'dart:async';
import 'package:flutter/material.dart';
import 'package:safespeak/Utils/LoginHelper.dart';
import 'package:safespeak/view/bottom_navigation/SafeSpeakBottomNav.dart';
import 'package:safespeak/view/onboarding/onboarding_view.dart';

/// Animated Splash Screen with:
///  - Pulsing gradient background
///  - Logo fade-in
///  - Shimmer sweep over title text
///  - Token check → navigate to SafeSpeakApp or Onboarding
class AnimatedSplashScreen extends StatefulWidget {
  const AnimatedSplashScreen({super.key});

  @override
  State<AnimatedSplashScreen> createState() => _AnimatedSplashScreenState();
}

class _AnimatedSplashScreenState extends State<AnimatedSplashScreen>
    with TickerProviderStateMixin {
  final _loginHelper = LoginHelper();

  late final AnimationController _fadeCtrl;
  late final Animation<double> _fade;

  late final AnimationController _bgCtrl; // drives background color lerp
  late final AnimationController _shimmerCtrl; // drives shimmer sweep

  @override
  void initState() {
    super.initState();

    /// Fade controller
    _fadeCtrl = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _fade = CurvedAnimation(parent: _fadeCtrl, curve: Curves.easeIn);
    _fadeCtrl.forward();

    /// Background pulse controller (loops)
    _bgCtrl = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    )..repeat(reverse: true);

    /// Shimmer controller (loops)
    _shimmerCtrl = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();

    /// After short delay check auth/token
    Timer(const Duration(seconds: 3), _checkLoginStatus);
  }

  Future<void> _checkLoginStatus() async {
    try {
      await _loginHelper.getSecureData();
      final token = _loginHelper.getToken(); // String? expected
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => (token != null && token.isNotEmpty)
              ? const SafeSpeakApp()
              : OnboardingScreen(),
        ),
      );
    } catch (e) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => OnboardingScreen(),
        ),
      );
    }
  }

  @override
  void dispose() {
    _fadeCtrl.dispose();
    _bgCtrl.dispose();
    _shimmerCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([_bgCtrl, _shimmerCtrl]),
      builder: (context, _) {
        final t = _bgCtrl.value; // 0→1→0 pulse
        // Gradient color lerp set
        final topColor =
            Color.lerp(const Color(0xFF1E3C72), const Color(0xFF0052D4), t)!;
        final bottomColor =
            Color.lerp(const Color(0xFF2A5298), const Color(0xFF65C7F7), t)!;

        return Scaffold(
          body: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [topColor, bottomColor],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Stack(
              children: [
                /// Center logo + shimmer text
                Center(
                  child: FadeTransition(
                    opacity: _fade,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // App Logo
                        Image.asset(
                          'assets/Images/safespeak-logo.png',
                          height: 140,
                          fit: BoxFit.contain,
                        ),
                        const SizedBox(height: 20),
                        _ShimmerTitle(
                          animation: _shimmerCtrl,
                          text: 'SafeSpeak',
                          textStyle: const TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors
                                .white, // base color (seen between shimmers)
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                /// Progress indicator bottom
                Positioned(
                  bottom: 48,
                  left: 0,
                  right: 0,
                  child: Column(
                    children: const [
                      SizedBox(
                        width: 36,
                        height: 36,
                        child: CircularProgressIndicator(
                          strokeWidth: 3,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      ),
                      SizedBox(height: 12),
                      Text(
                        'Loading...',
                        style: TextStyle(color: Colors.white70, fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

/// Lightweight shimmer (no external package)
class _ShimmerTitle extends StatelessWidget {
  const _ShimmerTitle({
    required this.animation,
    required this.text,
    required this.textStyle,
  });

  final Animation<double> animation;
  final String text;
  final TextStyle textStyle;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        // Sweep position: -1 to +2 (so gradient passes fully across)
        final double sweep = -1 + 3 * animation.value;
        return ShaderMask(
          shaderCallback: (Rect bounds) {
            return LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              stops: const [0.0, 0.5, 1.0],
              colors: [
                Colors.white.withOpacity(0.2),
                Colors.white.withOpacity(0.9), // bright streak
                Colors.white.withOpacity(0.2),
              ],
              transform: _SlidingGradientTransform(slidePercent: sweep),
            ).createShader(bounds);
          },
          blendMode: BlendMode.srcATop,
          child: Text(text, style: textStyle),
        );
      },
    );
  }
}

/// Moves gradient horizontally to create shimmer sweep
class _SlidingGradientTransform extends GradientTransform {
  const _SlidingGradientTransform({required this.slidePercent});

  final double slidePercent;

  @override
  Matrix4 transform(Rect bounds, {TextDirection? textDirection}) {
    return Matrix4.translationValues(bounds.width * slidePercent, 0.0, 0.0);
  }
}
