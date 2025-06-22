import 'dart:developer' as debugConsole;
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:home_management/screens/create_family_profile_screen.dart';
import 'package:home_management/services/auth_service.dart';
import 'package:provider/provider.dart';
import '../models/register_dto.dart';
import '../models/users/create_user_dto.dart';
import '../providers/language_provider.dart';
import '../providers/theme_provider.dart';
import 'package:home_management/l10n/app_localizations.dart';

import '../services/user_service.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _authService = AuthService();
  final _userService = UserSerice();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _agreeToTerms = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

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
                      const SizedBox(height: 20),
                      _buildBackButton(themeProvider),
                      const SizedBox(height: 20),
                      _buildHeader(l10n, themeProvider),
                      const SizedBox(height: 32),
                      _buildRegisterForm(l10n, themeProvider),
                      const SizedBox(height: 32),
                      _buildSignInPrompt(l10n, themeProvider),
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
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.language,
                    color: Color(0xFF6366F1),
                    size: 20,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    languageProvider.currentLanguageCode.toUpperCase(),
                    style: const TextStyle(
                      color: Color(0xFF6366F1),
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
          color: isSelected
              ? const Color(0xFF6366F1).withOpacity(0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color:
                isSelected ? const Color(0xFF6366F1) : const Color(0xFFE5E7EB),
          ),
        ),
        child: Row(
          children: [
            Icon(
              Icons.language,
              color: isSelected
                  ? const Color(0xFF6366F1)
                  : const Color(0xFF6B7280),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                languageName,
                style: TextStyle(
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  color: isSelected
                      ? const Color(0xFF6366F1)
                      : const Color(0xFF1F2937),
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

  Widget _buildBackButton(ThemeProvider themeProvider) {
    return Row(
      children: [
        IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back_ios, color: themeProvider.iconColor),
        ),
        Text(
          AppLocalizations.of(context)!.createAccount,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: themeProvider.primaryTextColor,
          ),
        ),
      ],
    );
  }

  Widget _buildHeader(AppLocalizations l10n, ThemeProvider themeProvider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.createAccount,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: themeProvider.primaryTextColor,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          l10n.joinUs,
          style: TextStyle(
            fontSize: 16,
            color: themeProvider.secondaryTextColor,
          ),
        ),
      ],
    );
  }

  Widget _buildRegisterForm(
      AppLocalizations l10n, ThemeProvider themeProvider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FadeInUp(
          delay: const Duration(milliseconds: 400),
          child: _buildTextField(
            controller: _nameController,
            label: l10n.fullName,
            icon: Icons.person_outline,
            themeProvider: themeProvider,
          ),
        ),
        const SizedBox(height: 20),
        FadeInUp(
          delay: const Duration(milliseconds: 500),
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
            suffixIcon: IconButton(
              icon: Icon(
                _obscurePassword ? Icons.visibility : Icons.visibility_off,
                color: themeProvider.iconColor,
              ),
              onPressed: () =>
                  setState(() => _obscurePassword = !_obscurePassword),
            ),
            themeProvider: themeProvider,
          ),
        ),
        const SizedBox(height: 20),
        FadeInUp(
          delay: const Duration(milliseconds: 700),
          child: _buildTextField(
            controller: _confirmPasswordController,
            label: l10n.confirmPassword,
            icon: Icons.lock_outline,
            obscureText: _obscureConfirmPassword,
            suffixIcon: IconButton(
              icon: Icon(
                _obscureConfirmPassword
                    ? Icons.visibility
                    : Icons.visibility_off,
                color: themeProvider.iconColor,
              ),
              onPressed: () => setState(
                  () => _obscureConfirmPassword = !_obscureConfirmPassword),
            ),
            themeProvider: themeProvider,
          ),
        ),
        const SizedBox(height: 20),
        FadeInUp(
          delay: const Duration(milliseconds: 800),
          child: Row(
            children: [
              Checkbox(
                value: _agreeToTerms,
                onChanged: (value) => setState(() => _agreeToTerms = value!),
                activeColor: themeProvider.primaryColor,
              ),
              Expanded(
                child: Text(
                  l10n.agreeToTerms,
                  style: TextStyle(color: themeProvider.secondaryTextColor),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 32),
        FadeInUp(
          delay: const Duration(milliseconds: 1000),
          child: SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: _agreeToTerms ? () async => await _register() : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: themeProvider.primaryColor,
              ),
              child: Text(
                l10n.createAccount,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSignInPrompt(
      AppLocalizations l10n, ThemeProvider themeProvider) {
    return FadeInUp(
      delay: const Duration(milliseconds: 1200),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            l10n.alreadyHaveAAccount,
            style: TextStyle(color: themeProvider.secondaryTextColor),
          ),
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Text(
              l10n.signIn,
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

  Future<void> _register() async {
    final l10n = AppLocalizations.of(context)!;
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;

    if (_nameController.text.isEmpty ||
        _emailController.text.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.fillAllFields)),
      );
      return;
    }

    if (password != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.passwordsDoNotMatch)),
      );
      return;
    }

    // Burada kayıt işlemini gerçekleştirebilirsiniz
    var registerDto = RegisterDto(
      email: _emailController.text,
      password: password,
      firstName: _nameController.text.split(' ').first,
      lastName: _nameController.text.split(' ').length > 1
          ? _nameController.text.split(' ')[1]
          : null,
    );

    debugConsole.log("Register DTO: ${registerDto.toJson()}");

    try {

      var isUser = await _userService.getUserProfileByEmail(registerDto.email);

      if (isUser != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.userAlreadyExists)),
        );
        return;
      }

      var result = await _authService.registerWithEmail(registerDto);
      await _userService.createUserProfile(
        CreateUserDto(
          id: result!.uid,
          email: registerDto.email,
          firstName: registerDto.firstName,
          lastName: registerDto.lastName,
          photoURL: '', // Fotoğraf URL'si eklenebilir
        ),
      );
      debugConsole.log('Registration result: $result');

      if (result == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.registrationFailed)),
        );
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.registrationSuccess)),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => CreateFamilyProfileScreen(),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.registrationFailed)),
      );
    }
  }
}
