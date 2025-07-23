import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:safespeak/view/Report/ReportIncidentScreen.dart';
import 'package:safespeak/view/bottom_navigation/SafeSpeakBottomNav.dart';

// Home Screen matching SafeSpeak design exactly
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFFB8E6E6), // Light teal at top
            Color(0xFFA3D9D9), // Slightly darker teal at bottom
          ],
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              // Main content container
              Flexible(
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 20,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // SafeSpeak Header with logo
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: const Color(0xFF4A90E2),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: const Icon(
                                Icons.favorite,
                                color: Colors.white,
                                size: 24,
                              ),
                            ),
                            const SizedBox(width: 12),
                            const Text(
                              'SafeSpeak',
                              style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF2C3E50),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 40),

                        // How are you feeling section
                        const Text(
                          'How are you feeling?',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF2C3E50),
                          ),
                        ),
                        const SizedBox(height: 30),

                        // Emoji buttons
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _buildEmojiButton(
                              child: _buildFaceIcon(true, false), // Happy face
                              color: const Color(0xFFFDD835), // Yellow
                            ),
                            _buildEmojiButton(
                              child: _buildFaceIcon(false, false), // Sad face
                              color: const Color(0xFFFFB74D), // Orange
                            ),
                            _buildEmojiButton(
                              child:
                                  _buildFaceIcon(false, true), // Very sad face
                              color:
                                  const Color(0xFF81C784), // Light blue-green
                            ),
                          ],
                        ),
                        const SizedBox(height: 40),

                        // Report Bullying Button
                        Container(
                          width: double.infinity,
                          height: 60,
                          decoration: BoxDecoration(
                            color: const Color(0xFF7B68EE),
                            borderRadius: BorderRadius.circular(30),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF7B68EE).withOpacity(0.3),
                                blurRadius: 15,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          child: ElevatedButton(
                            onPressed: () {
                              ref
                                  .read(bottomNavigationProvider.notifier)
                                  .state = 2;
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            child: const Text(
                              'Report Bullying',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),

                        // Kindness Score Card
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(25),
                            border: Border.all(
                              color: const Color(0xFFE0E0E0),
                              width: 1,
                            ),
                          ),
                          child: Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(16),
                                decoration: const BoxDecoration(
                                  color: Color(0xFFFFF3E0),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.star,
                                  color: Color(0xFFFFA726),
                                  size: 32,
                                ),
                              ),
                              const SizedBox(height: 16),
                              const Text(
                                'Kindness Score',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF2C3E50),
                                ),
                              ),
                              const SizedBox(height: 20),
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF8F9FA),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Column(
                                  children: [
                                    const Text(
                                      "Today's Uplift",
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500,
                                        color: Color(0xFF2C3E50),
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    const Text(
                                      '"You are capable of\namazing things."',
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600,
                                        color: Color(0xFF2C3E50),
                                        height: 1.3,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmojiButton({required Widget child, required Color color}) {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _buildFaceIcon(bool isHappy, bool isVerySad) {
    return CustomPaint(
      size: const Size(40, 40),
      painter: FacePainter(isHappy: isHappy, isVerySad: isVerySad),
    );
  }
}

// Custom painter for face icons
class FacePainter extends CustomPainter {
  final bool isHappy;
  final bool isVerySad;

  FacePainter({required this.isHappy, required this.isVerySad});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = const Color(0xFF2C3E50)
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final double centerX = size.width / 2;
    final double centerY = size.height / 2;

    // Draw eyes
    canvas.drawCircle(
      Offset(centerX - 8, centerY - 6),
      2,
      Paint()
        ..color = const Color(0xFF2C3E50)
        ..style = PaintingStyle.fill,
    );
    canvas.drawCircle(
      Offset(centerX + 8, centerY - 6),
      2,
      Paint()
        ..color = const Color(0xFF2C3E50)
        ..style = PaintingStyle.fill,
    );

    // Draw mouth
    if (isHappy) {
      // Happy smile
      canvas.drawArc(
        Rect.fromCenter(
          center: Offset(centerX, centerY + 4),
          width: 16,
          height: 12,
        ),
        0,
        3.14159,
        false,
        paint,
      );
    } else if (isVerySad) {
      // Very sad with tears
      canvas.drawArc(
        Rect.fromCenter(
          center: Offset(centerX, centerY + 12),
          width: 16,
          height: 12,
        ),
        3.14159,
        3.14159,
        false,
        paint,
      );
      // Tears
      canvas.drawLine(
        Offset(centerX - 8, centerY + 2),
        Offset(centerX - 8, centerY + 8),
        paint,
      );
      canvas.drawLine(
        Offset(centerX + 8, centerY + 2),
        Offset(centerX + 8, centerY + 8),
        paint,
      );
    } else {
      // Neutral/sad
      canvas.drawArc(
        Rect.fromCenter(
          center: Offset(centerX, centerY + 12),
          width: 16,
          height: 12,
        ),
        3.14159,
        3.14159,
        false,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
