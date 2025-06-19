import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import 'package:home_management/l10n/app_localizations.dart';

class FamilyProfileEditScreen extends StatefulWidget {
  @override
  _FamilyProfileEditScreenState createState() => _FamilyProfileEditScreenState();
}

class _FamilyProfileEditScreenState extends State<FamilyProfileEditScreen> {
  final _familyNameController = TextEditingController(text: 'The Smith Family');
  final _monthlyIncomeController = TextEditingController(text: '5400');
  
  final List<Map<String, dynamic>> _fixedExpenses = [
    {'name': 'Rent', 'controller': TextEditingController(text: '1500'), 'icon': Icons.home},
    {'name': 'Utilities', 'controller': TextEditingController(text: '200'), 'icon': Icons.flash_on},
    {'name': 'Internet', 'controller': TextEditingController(text: '80'), 'icon': Icons.wifi},
    {'name': 'Insurance', 'controller': TextEditingController(text: '300'), 'icon': Icons.security},
  ];

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
              l10n.editFamilyProfile,
              style: TextStyle(
                color: themeProvider.primaryTextColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  l10n.save,
                  style: TextStyle(
                    color: themeProvider.primaryColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FadeInUp(
                  child: _buildProfileSummary(l10n, themeProvider),
                ),
                const SizedBox(height: 32),
                FadeInUp(
                  delay: const Duration(milliseconds: 200),
                  child: _buildFamilyNameField(l10n, themeProvider),
                ),
                const SizedBox(height: 24),
                FadeInUp(
                  delay: const Duration(milliseconds: 400),
                  child: _buildMonthlyIncomeField(l10n, themeProvider),
                ),
                const SizedBox(height: 32),
                FadeInUp(
                  delay: const Duration(milliseconds: 600),
                  child: _buildFixedExpensesSection(l10n, themeProvider),
                ),
                const SizedBox(height: 40),
                FadeInUp(
                  delay: const Duration(milliseconds: 800),
                  child: _buildActionButtons(l10n, themeProvider),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildProfileSummary(AppLocalizations l10n, ThemeProvider themeProvider) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: themeProvider.cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: themeProvider.cardShadow,
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: themeProvider.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.family_restroom,
                  color: themeProvider.primaryColor,
                  size: 32,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.profileSummary,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: themeProvider.primaryTextColor,
                      ),
                    ),
                    Text(
                      l10n.updateFamilyInfo,
                      style: TextStyle(
                        color: themeProvider.secondaryTextColor,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _buildSummaryItem(l10n.monthlyIncome, '\$5,400', themeProvider.successColor),
              ),
              Container(
                width: 1,
                height: 40,
                color: themeProvider.dividerColor,
                margin: const EdgeInsets.symmetric(horizontal: 16),
              ),
              Expanded(
                child: _buildSummaryItem(l10n.fixedExpenses, '\$2,080', themeProvider.errorColor),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryItem(String title, String amount, Color color) {
    return Column(
      children: [
        Text(
          title,
          style: TextStyle(
            color: Provider.of<ThemeProvider>(context).secondaryTextColor,
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          amount,
          style: TextStyle(
            color: color,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildFamilyNameField(AppLocalizations l10n, ThemeProvider themeProvider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.familyName,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xFF374151),
          ),
        ),
        SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: TextField(
            controller: _familyNameController,
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.family_restroom, color: Color(0xFF6B7280)),
              border: InputBorder.none,
              contentPadding: EdgeInsets.all(16),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMonthlyIncomeField(AppLocalizations l10n, ThemeProvider themeProvider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.monthlyFamilyIncome,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xFF374151),
          ),
        ),
        SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: TextField(
            controller: _monthlyIncomeController,
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(
              prefixIcon: Container(
                margin: EdgeInsets.all(12),
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Color(0xFF10B981).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  '\$',
                  style: TextStyle(
                    color: Color(0xFF10B981),
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
              border: InputBorder.none,
              contentPadding: EdgeInsets.all(16),
            ),
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1F2937),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFixedExpensesSection(AppLocalizations l10n, ThemeProvider themeProvider) {
    final List<Map<String, dynamic>> _fixedExpenses = [
      {'name': l10n.rent, 'controller': TextEditingController(text: '1500'), 'icon': Icons.home},
      {'name': l10n.utilities, 'controller': TextEditingController(text: '200'), 'icon': Icons.flash_on},
      {'name': l10n.internet, 'controller': TextEditingController(text: '80'), 'icon': Icons.wifi},
      {'name': l10n.insurance, 'controller': TextEditingController(text: '300'), 'icon': Icons.security},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              l10n.fixedMonthlyExpenses,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF374151),
              ),
            ),
            Spacer(),
            IconButton(
              onPressed: () {},
              icon: Icon(Icons.add, color: Color(0xFF6366F1)),
            ),
          ],
        ),
        SizedBox(height: 12),
        ...List.generate(_fixedExpenses.length, (index) {
          final expense = _fixedExpenses[index];
          return Container(
            margin: EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 8,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: expense['controller'],
                    keyboardType: TextInputType.numberWithOptions(decimal: true),
                    decoration: InputDecoration(
                      labelText: expense['name'],
                      prefixIcon: Icon(expense['icon'], color: Color(0xFF6B7280)),
                      suffixText: '\$',
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.all(16),
                      labelStyle: TextStyle(color: Color(0xFF6B7280)),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {}, // Non-functional delete
                  icon: Icon(Icons.delete_outline, color: Color(0xFFEF4444)),
                ),
              ],
            ),
          );
        }),
        SizedBox(height: 12),
        GestureDetector(
          onTap: () {},
          child: Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Color(0xFF6366F1), style: BorderStyle.solid),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.add, color: Color(0xFF6366F1)),
                SizedBox(width: 8),
                Text(
                  l10n.addNewFixedExpense,
                  style: TextStyle(
                    color: Color(0xFF6366F1),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(AppLocalizations l10n, ThemeProvider themeProvider) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF6366F1),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              l10n.saveChanges,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ),
        SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          height: 56,
          child: OutlinedButton(
            onPressed: () => Navigator.pop(context),
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: Color(0xFFEF4444)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              l10n.cancelChanges,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFFEF4444),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
