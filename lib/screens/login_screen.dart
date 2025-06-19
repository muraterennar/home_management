import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:provider/provider.dart';
import '../providers/language_provider.dart';
import '../providers/theme_provider.dart';
import 'package:home_management/l10n/app_localizations.dart';
import 'register_screen.dart';
import 'forgot_password_screen.dart';
import 'dashboard_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return Scaffold(
          backgroundColor: themeProvider.backgroundColor,
          body: Stack(
            children: [
              SafeArea(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 60),
                      _buildHeader(l10n, themeProvider),
                      const SizedBox(height: 40),
                      _buildLoginForm(l10n, themeProvider),
                      const SizedBox(height: 32),
                      _buildSignUpPrompt(l10n, themeProvider),
                    ],
                  ),
                ),
              ),
              _buildLanguageSelector(themeProvider),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLanguageSelector(ThemeProvider themeProvider) {
    return Positioned(
      top: MediaQuery.of(context).padding.top + 16,
      right: 16,
      child: Consumer<LanguageProvider>(
        builder: (context, languageProvider, child) {
          return GestureDetector(
            onTap: () => _showLanguageDialog(context),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: themeProvider.cardColor,
                borderRadius: BorderRadius.circular(12),
                boxShadow: themeProvider.cardShadow,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.language,
                    size: 20,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    languageProvider.currentLanguageCode.toUpperCase(),
                    style: TextStyle(
                      color: themeProvider.primaryColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _showLanguageDialog(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return Consumer<LanguageProvider>(
          builder: (context, languageProvider, child) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              title: Text(
                l10n.selectLanguage,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1F2937),
                ),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildLanguageOption(
                    context,
                    'English',
                    'en',
                    languageProvider.currentLanguageCode == 'en',
                    languageProvider,
                  ),
                  const SizedBox(height: 8),
                  _buildLanguageOption(
                    context,
                    'Türkçe',
                    'tr',
                    languageProvider.currentLanguageCode == 'tr',
                    languageProvider,
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(dialogContext).pop(),
                  child: Text(
                    l10n.cancel,
                    style: const TextStyle(color: Color(0xFF6B7280)),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildLanguageOption(
    BuildContext context,
    String languageName,
    String languageCode,
    bool isSelected,
    LanguageProvider languageProvider,
  ) {
    return GestureDetector(
      onTap: () {
        languageProvider.changeLanguage(languageCode);
        Navigator.of(context).pop();
        _showLanguageChangedSnackbar(context);
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF6366F1).withOpacity(0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? const Color(0xFF6366F1) : const Color(0xFFE5E7EB),
          ),
        ),
        child: Row(
          children: [
            Icon(
              Icons.language,
              color: isSelected ? const Color(0xFF6366F1) : const Color(0xFF6B7280),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                languageName,
                style: TextStyle(
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  color: isSelected ? const Color(0xFF6366F1) : const Color(0xFF1F2937),
                ),
              ),
            ),
            if (isSelected)
              const Icon(
                Icons.check,
                color: Color(0xFF6366F1),
              ),
          ],
        ),
      ),
    );
  }

  void _showLanguageChangedSnackbar(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    if (l10n != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            l10n.languageChanged,
            style: const TextStyle(color: Colors.white),
          ),
          backgroundColor: const Color(0xFF10B981),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  Widget _buildHeader(AppLocalizations l10n, ThemeProvider themeProvider) {
    return FadeInDown(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.welcomeBack,
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: themeProvider.primaryTextColor,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.signInToContinue,
            style: TextStyle(
              fontSize: 16,
              color: themeProvider.secondaryTextColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoginForm(AppLocalizations l10n, ThemeProvider themeProvider) {
    return Column(
      children: [
        FadeInUp(
          delay: const Duration(milliseconds: 400),
          child: _buildTextField(
            controller: _emailController,
            label: l10n.email,
            icon: Icons.email_outlined,
            keyboardType: TextInputType.emailAddress,
            themeProvider: themeProvider,
          ),
        ),
        const SizedBox(height: 20),
        FadeInUp(
          delay: const Duration(milliseconds: 600),
          child: _buildTextField(
            controller: _passwordController,
            label: l10n.password,
            icon: Icons.lock_outline,
            obscureText: _obscurePassword,
            themeProvider: themeProvider,
            suffixIcon: IconButton(
              icon: Icon(
                _obscurePassword ? Icons.visibility : Icons.visibility_off,
                color: themeProvider.iconColor,
              ),
              onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
            ),
          ),
        ),
        const SizedBox(height: 12),
        FadeInUp(
          delay: const Duration(milliseconds: 800),
          child: Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ForgotPasswordScreen()),
              ),
              child: Text(
                l10n.forgotPassword,
                style: TextStyle(color: themeProvider.primaryColor),
              ),
            ),
          ),
        ),
        const SizedBox(height: 32),
        FadeInUp(
          delay: const Duration(milliseconds: 1000),
          child: SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: () => Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const DashboardScreen()),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: themeProvider.primaryColor,
              ),
              child: Text(
                l10n.signIn,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool obscureText = false,
    Widget? suffixIcon,
    TextInputType? keyboardType,
    required ThemeProvider themeProvider,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: themeProvider.inputBackgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: themeProvider.inputBorderColor),
      ),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        style: TextStyle(color: themeProvider.primaryTextColor),
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: themeProvider.iconColor),
          suffixIcon: suffixIcon,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.all(16),
          labelStyle: TextStyle(color: themeProvider.secondaryTextColor),
        ),
      ),
    );
  }

  Widget _buildSignUpPrompt(AppLocalizations l10n, ThemeProvider themeProvider) {
    return FadeInUp(
      delay: const Duration(milliseconds: 1200),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            l10n.dontHaveAccount,
            style: TextStyle(color: themeProvider.secondaryTextColor),
          ),
          TextButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const RegisterScreen()),
            ),
            child: Text(
              l10n.signUp,
              style: TextStyle(
                color: themeProvider.primaryColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
