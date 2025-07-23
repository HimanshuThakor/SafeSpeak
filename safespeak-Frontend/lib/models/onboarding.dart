import 'package:safespeak/Utils/app_assets.dart';

class Onboarding {
  final String image;
  final String title;
  final String description;

  Onboarding({
    required this.description,
    required this.image,
    required this.title,
  });
}

/// SafeSpeak onboarding data
///
/// Keep descriptions short (<=2 lines) for small screens.
/// Use `\n` to control wrapping.
final List<Onboarding> onboardingList = [
  Onboarding(
    title: 'Stay Safe Online',
    description:
        'AI detects harmful & bullying messages.\nYour data stays private & secure.',
    image: AppAssets.kOnboardingFirst,
  ),
  Onboarding(
    title: 'Report & Get Help Fast',
    description:
        'One‑tap SOS or anonymous report.\nNotify trusted contacts instantly.',
    image: AppAssets.kOnboardingSecond,
  ),
  Onboarding(
    title: 'Learn & Build Confidence',
    description:
        'Cyber safety tips, privacy guides, support.\nTogether we make kinder digital spaces.',
    image: AppAssets.kOnboardingThird,
  ),
  Onboarding(
    title: 'Your Control, Your Voice',
    description:
        'Block, mute & manage who can contact you.\nSafeSpeak never sells your data.',
    image: AppAssets.kOnboardingFourth, // add to assets when ready
  ),
];
