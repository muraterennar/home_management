import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:home_management/screens/login_screen.dart';
import '../l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import '../providers/language_provider.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final controller = PageController();
  bool isLastPage = false;

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  // Karşılama ekranını tamamlama fonksiyonu
  Future<void> _completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('showOnboarding', false);

    if (!mounted) return;

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          AppLocalizations.of(context)!.selectLanguage,
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<Locale>(
                value: Localizations.localeOf(context),
                items: AppLocalizations.supportedLocales.map((locale) {
                  return DropdownMenuItem(
                    value: locale,
                    child: Text(
                      Provider.of<LanguageProvider>(context, listen: false).getLanguageName(locale.languageCode),
                      style: const TextStyle(fontSize: 16, color: Colors.black),
                    ),
                  );
                }).toList(),
                onChanged: (Locale? newLocale) {
                  if (newLocale != null) {
                    final languageProvider = Provider.of<LanguageProvider>(context, listen: false);
                    languageProvider.changeLanguage(newLocale.languageCode);
                  }
                },
                icon: const Icon(Icons.language, color: Colors.black),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView(
                controller: controller,
                onPageChanged: (index) {
                  setState(() {
                    isLastPage = index == 2;
                  });
                },
                children: [
                  _buildOnboardingPage(
                    image: 'assets/images/onboarding_1.png',
                    title: AppLocalizations.of(context)!.onBoardingOneTitle,
                    description: AppLocalizations.of(context)!.onBoardingOneDesc,
                  ),
                  _buildOnboardingPage(
                    image: 'assets/images/onboarding_2.png',
                    title: AppLocalizations.of(context)!.onBoardingTwoTitle,
                    description: AppLocalizations.of(context)!.onBoardingTwoDesc,
                  ),
                  _buildOnboardingPage(
                    image: 'assets/images/onboarding_3.png',
                    title: AppLocalizations.of(context)!.onBoardingThreeTitle,
                    description: AppLocalizations.of(context)!.onBoardingThreeDesc,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: SmoothPageIndicator(
                controller: controller,
                count: 3,
                effect: const WormEffect(
                  dotHeight: 8,
                  dotWidth: 8,
                  spacing: 8,
                  dotColor: Color(0xFFE0E0E0),
                  activeDotColor: Color(0xFF6C63FF),
                ),
                onDotClicked: (index) => controller.animateToPage(
                  index,
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.easeInOut,
                ),
              ),
            ),
            isLastPage ? _buildGetStartedButton() : _buildBottomSheetControls(),
          ],
        ),
      ),
    );
  }

  Widget _buildOnboardingPage({
    required String image,
    required String title,
    required String description,
  }) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFF7F8FA), Color(0xFFEDECF3)],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 24, bottom: 16),
              child: Image.asset(
                image,
                height: screenHeight * 0.44,
                width: screenWidth * 0.85,
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF22223B),
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                description,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  color: Color(0xFF4A4E69),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGetStartedButton() {
    return Container(
      padding: const EdgeInsets.only(bottom: 24, left: 24, right: 24),
      width: double.infinity,
      height: 80,
      color: Colors.white,
      child: SizedBox(
        width: double.infinity,
        height: 48,
        child: ElevatedButton(
          onPressed: _completeOnboarding,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF6C63FF),
            foregroundColor: Colors.white,
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            textStyle: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.2,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(AppLocalizations.of(context)!.getStarted),
              const SizedBox(width: 8),
              const Icon(Icons.arrow_forward_rounded, size: 22),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomSheetControls() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      height: 56,
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextButton(
            style: TextButton.styleFrom(
              foregroundColor: const Color(0xFF6C63FF),
              textStyle: const TextStyle(fontWeight: FontWeight.bold),
            ),
            child: Text(AppLocalizations.of(context)!.skip),
            onPressed: () => _completeOnboarding(),
          ),
          TextButton(
            style: TextButton.styleFrom(
              foregroundColor: const Color(0xFF6C63FF),
              textStyle: const TextStyle(fontWeight: FontWeight.bold),
            ),
            child: Text(AppLocalizations.of(context)!.go),
            onPressed: () => controller.nextPage(
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeInOut,
            ),
          ),
        ],
      ),
    );
  }
}
