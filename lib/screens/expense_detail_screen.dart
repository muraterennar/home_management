import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:home_management/models/espenses/expense_dto.dart';
import 'package:home_management/providers/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:home_management/l10n/app_localizations.dart';
import 'package:intl/intl.dart';

import '../models/espenses/expense_category.dart';
import 'full_screen_image_view.dart';

class ExpenseDetailScreen extends StatefulWidget {
  final ExpenseDto expense;

  const ExpenseDetailScreen({Key? key, required this.expense}) : super(key: key);

  @override
  _ExpenseDetailScreenState createState() => _ExpenseDetailScreenState();
}

class _ExpenseDetailScreenState extends State<ExpenseDetailScreen> {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final themeProvider = Provider.of<ThemeProvider>(context);
    final currencySymbol = l10n.currencySymbol ?? '₺';

    return Scaffold(
      backgroundColor: themeProvider.backgroundColor,
      appBar: AppBar(
        backgroundColor: themeProvider.surfaceColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: themeProvider.iconColor),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          l10n.expenseDetails,
          style: TextStyle(color: themeProvider.primaryTextColor),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.edit, color: themeProvider.iconColor),
            onPressed: () {
              // TODO: Düzenleme ekranına yönlendir
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Üst Bilgi Kartı
            FadeInDown(
              child: Container(
                width: double.infinity,
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.expense.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _getCategoryName(widget.expense.category, l10n),
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.8),
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              l10n.amount,
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.8),
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '$currencySymbol${widget.expense.amount.toStringAsFixed(2)}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.calendar_today,
                                color: Colors.white.withOpacity(0.8),
                                size: 16,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                DateFormat('dd MMMM yyyy').format(widget.expense.date),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Detay Kartları
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.details,
                    style: TextStyle(
                      color: themeProvider.primaryTextColor,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Not Kartı
                  if (widget.expense.notes?.isNotEmpty == true)
                    FadeInUp(
                      delay: const Duration(milliseconds: 200),
                      child: _buildDetailCard(
                        icon: Icons.note,
                        title: l10n.notes,
                        content: widget.expense.notes!,
                        themeProvider: themeProvider,
                      ),
                    ),

                  // Fatura Kartı
                  if (widget.expense.voucherUrl?.isNotEmpty == true)
                    FadeInUp(
                      delay: const Duration(milliseconds: 300),
                      child: _buildReceiptCard(
                        themeProvider: themeProvider,
                        l10n: l10n,
                      ),
                    ),

                  // Konum Kartı
                  if (widget.expense.location?.isNotEmpty == true)
                    FadeInUp(
                      delay: const Duration(milliseconds: 400),
                      child: _buildDetailCard(
                        icon: Icons.location_on,
                        title: l10n.location,
                        content: widget.expense.location!,
                        themeProvider: themeProvider,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailCard({
    required IconData icon,
    required String title,
    required String content,
    required ThemeProvider themeProvider,
  }) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: themeProvider.cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: themeProvider.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                size: 20,
                color: themeProvider.primaryColor,
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  color: themeProvider.primaryTextColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            content,
            style: TextStyle(
              color: themeProvider.secondaryTextColor,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReceiptCard({
    required ThemeProvider themeProvider,
    required AppLocalizations l10n,
  }) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: themeProvider.cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: themeProvider.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.receipt_long,
                size: 20,
                color: themeProvider.primaryColor,
              ),
              const SizedBox(width: 8),
              Text(
                l10n.receipt,
                style: TextStyle(
                  color: themeProvider.primaryTextColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Fatura görüntüleyici widget'ı
          Container(
            height: 200,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: themeProvider.backgroundColor,
            ),
            child: widget.expense.voucherUrl != null
                ? Image.network(
                    widget.expense.voucherUrl!,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Center(
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                                  loadingProgress.expectedTotalBytes!
                              : null,
                        ),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return Center(
                        child: Icon(
                          Icons.broken_image,
                          size: 48,
                          color: themeProvider.primaryColor.withOpacity(0.5),
                        ),
                      );
                    },
                  )
                : Center(
                    child: Icon(
                      Icons.image_not_supported,
                      size: 48,
                      color: themeProvider.primaryColor.withOpacity(0.5),
                    ),
                  ),
          ),
          const SizedBox(height: 12),
          TextButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FullScreenImageView(image: widget.expense.voucherUrl!),
                ),
              );
            },
            icon: const Icon(Icons.fullscreen),
            label: Text(l10n.viewFullscreen),
            style: TextButton.styleFrom(
              foregroundColor: themeProvider.primaryColor,
            ),
          ),
        ],
      ),
    );
  }

  String _getCategoryName(ExpenseCategory category, AppLocalizations l10n) {
    switch (category) {
      case ExpenseCategory.foodDining:
        return l10n.foodDining;
      case ExpenseCategory.transportation:
        return l10n.transportation;
      case ExpenseCategory.shopping:
        return l10n.shopping;
      case ExpenseCategory.entertainment:
        return l10n.entertainment;
      case ExpenseCategory.billsUtilities:
        return l10n.billsUtilities;
      case ExpenseCategory.healthcare:
        return l10n.healthcare;
      case ExpenseCategory.education:
        return l10n.education;
      case ExpenseCategory.other:
        return l10n.other;
      default:
        return '';
    }
  }
}
