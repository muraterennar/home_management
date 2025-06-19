import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:home_management/l10n/app_localizations.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _emailController = TextEditingController();
  bool _isEmailSent = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              FadeInDown(
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF6B7280)),
                    ),
                    Text(
                      l10n.resetPassword,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1F2937),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              if (!_isEmailSent) ...[
                FadeInUp(
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: const Color(0xFF6366F1).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Icon(
                      Icons.lock_reset,
                      size: 40,
                      color: Color(0xFF6366F1),
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                FadeInUp(
                  delay: const Duration(milliseconds: 200),
                  child: Text(
                    l10n.forgotYourPassword,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1F2937),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                FadeInUp(
                  delay: const Duration(milliseconds: 400),
                  child: Text(
                    l10n.resetPasswordMessage,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Color(0xFF6B7280),
                      height: 1.5,
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                FadeInUp(
                  delay: const Duration(milliseconds: 600),
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFF9FAFB),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFE5E7EB)),
                    ),
                    child: TextField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: l10n.emailAddress,
                        prefixIcon: const Icon(Icons.email_outlined, color: Color(0xFF6B7280)),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.all(16),
                        labelStyle: const TextStyle(color: Color(0xFF6B7280)),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                FadeInUp(
                  delay: const Duration(milliseconds: 800),
                  child: SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: () => setState(() => _isEmailSent = true),
                      child: Text(
                        l10n.sendResetLink,
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ),
              ] else ...[
                FadeInUp(
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: const Color(0xFF10B981).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Icon(
                      Icons.mark_email_read,
                      size: 40,
                      color: Color(0xFF10B981),
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                FadeInUp(
                  delay: const Duration(milliseconds: 200),
                  child: Text(
                    l10n.checkYourEmail,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1F2937),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                FadeInUp(
                  delay: const Duration(milliseconds: 400),
                  child: Text(
                    '${l10n.resetLinkSent}\n${_emailController.text}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Color(0xFF6B7280),
                      height: 1.5,
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                FadeInUp(
                  delay: const Duration(milliseconds: 600),
                  child: SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        l10n.backToLogin,
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                FadeInUp(
                  delay: const Duration(milliseconds: 800),
                  child: Center(
                    child: TextButton(
                      onPressed: () => setState(() => _isEmailSent = false),
                      child: Text(
                        l10n.resendEmail,
                        style: const TextStyle(
                          color: Color(0xFF6366F1),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
