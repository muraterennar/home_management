import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/language_provider.dart';
import 'package:home_management/l10n/app_localizations.dart';

class LanguageSelectorWidget extends StatelessWidget {
  final bool isFloating;
  final EdgeInsets? margin;

  const LanguageSelectorWidget({
    super.key,
    this.isFloating = true,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    if (isFloating) {
      return Positioned(
        top: MediaQuery.of(context).padding.top + 16,
        right: 16,
        child: _buildSelector(context),
      );
    } else {
      return Container(
        margin: margin ?? EdgeInsets.zero,
        child: _buildSelector(context),
      );
    }
  }

  Widget _buildSelector(BuildContext context) {
    return Consumer<LanguageProvider>(
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
                Icon(
                  Icons.language,
                  color: const Color(0xFF6366F1),
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
}
