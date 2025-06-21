import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:home_management/screens/login_screen.dart';
import 'package:provider/provider.dart';
import '../providers/language_provider.dart';
import '../providers/currency_provider.dart';
import '../providers/theme_provider.dart';
import 'package:home_management/l10n/app_localizations.dart';
import '../services/auth_service.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late AuthService _authService;

  @override
  void initState() {
    super.initState();
    _authService = AuthService(context: context);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return Scaffold(
          backgroundColor: themeProvider.backgroundColor,
          appBar: AppBar(
            backgroundColor: themeProvider.surfaceColor,
            elevation: 0,
            leading: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: Icon(Icons.arrow_back_ios, color: themeProvider.iconColor),
            ),
            title: Text(
              l10n.settings,
              style: TextStyle(
                color: themeProvider.primaryTextColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FadeInUp(
                  child: _buildGeneralSection(l10n, themeProvider),
                ),
                const SizedBox(height: 32),
                FadeInUp(
                  delay: const Duration(milliseconds: 200),
                  child: _buildLanguageSection(l10n, themeProvider),
                ),
                const SizedBox(height: 32),
                FadeInUp(
                  delay: const Duration(milliseconds: 300),
                  child: _buildCurrencySection(l10n, themeProvider),
                ),
                const SizedBox(height: 32),
                FadeInUp(
                  delay: const Duration(milliseconds: 400),
                  child: _buildNotificationSection(l10n, themeProvider),
                ),
                const SizedBox(height: 32),
                FadeInUp(
                  delay: const Duration(milliseconds: 600),
                  child: _buildAboutSection(l10n, themeProvider),
                ),
                const SizedBox(height: 32),
                FadeInUp(
                  delay: const Duration(milliseconds: 700),
                  child: _buildLogoutSection(l10n, themeProvider),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildGeneralSection(
      AppLocalizations l10n, ThemeProvider themeProvider) {
    return _buildSection(
      title: l10n.general,
      themeProvider: themeProvider,
      children: [
        _buildSettingsTile(
          icon: themeProvider.isDarkMode ? Icons.dark_mode : Icons.light_mode,
          title: l10n.darkMode,
          subtitle: l10n.switchThemes,
          trailing: Switch(
            value: themeProvider.isDarkMode,
            onChanged: (value) {
              themeProvider.toggleTheme();
              _showThemeChangedSnackbar(context);
            },
          ),
          themeProvider: themeProvider,
        ),
      ],
    );
  }

  Widget _buildCurrencySection(
      AppLocalizations l10n, ThemeProvider themeProvider) {
    return _buildSection(
      title: l10n.currency,
      themeProvider: themeProvider,
      children: [
        Consumer<CurrencyProvider>(
          builder: (context, currencyProvider, child) {
            return _buildSettingsTile(
              icon: Icons.attach_money,
              title: l10n.selectCurrency,
              subtitle: currencyProvider
                  .getCurrencyName(currencyProvider.currentCurrency),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () => _showCurrencyDialog(context, l10n),
              themeProvider: themeProvider,
            );
          },
        ),
      ],
    );
  }

  Widget _buildLanguageSection(
      AppLocalizations l10n, ThemeProvider themeProvider) {
    return _buildSection(
      title: l10n.language,
      themeProvider: themeProvider,
      children: [
        Consumer<LanguageProvider>(
          builder: (context, languageProvider, child) {
            return _buildSettingsTile(
              icon: Icons.language,
              title: l10n.selectLanguage,
              subtitle: languageProvider
                  .getLanguageName(languageProvider.currentLanguageCode),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () => _showLanguageDialog(context, l10n),
              themeProvider: themeProvider,
            );
          },
        ),
      ],
    );
  }

  Widget _buildNotificationSection(
      AppLocalizations l10n, ThemeProvider themeProvider) {
    return _buildSection(
      title: l10n.notifications,
      themeProvider: themeProvider,
      children: [
        _buildSettingsTile(
          icon: Icons.notifications_outlined,
          title: l10n.pushNotifications,
          subtitle: l10n.receivePushNotifications,
          trailing: Switch(
            value: true,
            onChanged: (value) {}, // Non-functional
            activeColor: const Color(0xFF6366F1),
          ),
          themeProvider: themeProvider,
        ),
        _buildSettingsTile(
          icon: Icons.email_outlined,
          title: l10n.emailNotifications,
          subtitle: l10n.receiveEmailNotifications,
          trailing: Switch(
            value: false,
            onChanged: (value) {}, // Non-functional
            activeColor: const Color(0xFF6366F1),
          ),
          themeProvider: themeProvider,
        ),
      ],
    );
  }

  Widget _buildAboutSection(
      AppLocalizations l10n, ThemeProvider themeProvider) {
    return _buildSection(
      title: l10n.about,
      themeProvider: themeProvider,
      children: [
        _buildSettingsTile(
          icon: Icons.info_outline,
          title: l10n.version,
          subtitle: '1.0.0',
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          onTap: () {},
          // Non-functional
          themeProvider: themeProvider,
        ),
        _buildSettingsTile(
          icon: Icons.privacy_tip_outlined,
          title: l10n.privacyPolicy,
          subtitle: l10n.readPrivacyPolicy,
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          onTap: () {},
          // Non-functional
          themeProvider: themeProvider,
        ),
        _buildSettingsTile(
          icon: Icons.description_outlined,
          title: l10n.termsOfService,
          subtitle: l10n.readTermsOfService,
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          onTap: () {},
          // Non-functional
          themeProvider: themeProvider,
        ),
      ],
    );
  }

  Widget _buildLogoutSection(
      AppLocalizations l10n, ThemeProvider themeProvider) {
    return _buildSection(
      title: l10n.account,
      themeProvider: themeProvider,
      children: [
        _buildSettingsTile(
          icon: Icons.logout,
          title: l10n.logout,
          subtitle: l10n.logoutDescription,
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          onTap: () => _showLogoutConfirmationDialog(context),
          themeProvider: themeProvider,
        ),
      ],
    );
  }

  Widget _buildSection({
    required String title,
    required List<Widget> children,
    required ThemeProvider themeProvider,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: themeProvider.primaryTextColor,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          decoration: BoxDecoration(
            color: themeProvider.cardColor,
            borderRadius: BorderRadius.circular(16),
            boxShadow: themeProvider.cardShadow,
          ),
          child: Column(
            children: children,
          ),
        ),
      ],
    );
  }

  Widget _buildSettingsTile({
    required IconData icon,
    required String title,
    required String subtitle,
    Widget? trailing,
    VoidCallback? onTap,
    required ThemeProvider themeProvider,
  }) {
    return ListTile(
      onTap: onTap,
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: themeProvider.primaryColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          color: themeProvider.primaryColor,
          size: 20,
        ),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          color: themeProvider.primaryTextColor,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          color: themeProvider.secondaryTextColor,
          fontSize: 12,
        ),
      ),
      trailing: trailing,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    );
  }

  void _showThemeChangedSnackbar(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);

    if (l10n != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            themeProvider.isDarkMode
                ? 'Dark mode enabled'
                : 'Light mode enabled',
            style: const TextStyle(color: Colors.white),
          ),
          backgroundColor: themeProvider.successColor,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      );
    }
  }

  void _showLanguageDialog(BuildContext context, AppLocalizations l10n) {
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
        ),
      );
    }
  }

  void _showCurrencyDialog(BuildContext context, AppLocalizations l10n) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return Consumer<CurrencyProvider>(
          builder: (context, currencyProvider, child) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              title: Text(
                l10n.selectCurrency,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1F2937),
                ),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildCurrencyOption(
                    context,
                    l10n.usd,
                    'USD',
                    currencyProvider.currentCurrency == 'USD',
                    currencyProvider,
                  ),
                  const SizedBox(height: 8),
                  _buildCurrencyOption(
                    context,
                    l10n.tr,
                    'TRY',
                    currencyProvider.currentCurrency == 'TRY',
                    currencyProvider,
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

  Widget _buildCurrencyOption(
    BuildContext context,
    String currencyName,
    String currencyCode,
    bool isSelected,
    CurrencyProvider currencyProvider,
  ) {
    return GestureDetector(
      onTap: () {
        currencyProvider.changeCurrency(currencyCode);
        Navigator.of(context).pop();
        _showCurrencyChangedSnackbar(context);
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
              Icons.attach_money,
              color: isSelected
                  ? const Color(0xFF6366F1)
                  : const Color(0xFF6B7280),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                currencyName,
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

  void _showCurrencyChangedSnackbar(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    if (l10n != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            l10n.currencyChanged,
            style: const TextStyle(color: Colors.white),
          ),
          backgroundColor: const Color(0xFF10B981),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      );
    }
  }

  void _showLogoutConfirmationDialog(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(
            l10n.logoutConfirmation,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xFF1F2937),
            ),
          ),
          content: Text(
            l10n.logoutMessage,
            style: TextStyle(
              color: themeProvider.secondaryTextColor,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: Text(
                l10n.cancel,
                style: const TextStyle(color: Color(0xFF6B7280)),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                _performLogout(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: themeProvider.errorColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(l10n.logout),
            ),
          ],
        );
      },
    );
  }

  Future<void> _performLogout(BuildContext context) async {
    try {
      await _authService.logout();
// Kullanıcıyı giriş sayfasına yönlendir
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const LoginScreen()),
        (route) => false,
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
          backgroundColor:
              Provider.of<ThemeProvider>(context, listen: false).errorColor,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      );
    }
  }
}
