import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import 'package:home_management/l10n/app_localizations.dart';
import 'package:home_management/services/family_service.dart';
import 'package:home_management/services/user_service.dart';
import 'package:home_management/models/family/family_dto.dart';
import 'package:home_management/models/family/update_family_dto.dart';

class FamilyProfileEditScreen extends StatefulWidget {
  @override
  _FamilyProfileEditScreenState createState() =>
      _FamilyProfileEditScreenState();
}

class _FamilyProfileEditScreenState extends State<FamilyProfileEditScreen> {
  final _familyService = FamilyService();
  final _userService = UserSerice();

  final _familyNameController = TextEditingController();
  final _monthlyIncomeController = TextEditingController();

  List<Map<String, dynamic>> _fixedExpenses = [
    {
      'name': 'Rent',
      'controller': TextEditingController(),
      'icon': Icons.home,
      'isDefault': true
    },
    {
      'name': 'Utilities',
      'controller': TextEditingController(),
      'icon': Icons.flash_on,
      'isDefault': true
    },
    {
      'name': 'Internet',
      'controller': TextEditingController(),
      'icon': Icons.wifi,
      'isDefault': true
    },
    {
      'name': 'Insurance',
      'controller': TextEditingController(),
      'icon': Icons.security,
      'isDefault': true
    },
  ];

  String? _tenantId;
  bool _loading = true;

  int _summaryIncome = 0;
  int _summaryExpenses = 0;

  @override
  void initState() {
    super.initState();
    _loadFamilyData();
  }

  Future<void> _loadFamilyData() async {
    setState(() {
      _loading = true;
    });
    try {
      _tenantId = await _userService.getTenantId();
      if (_tenantId == null || _tenantId!.isEmpty) {
        throw Exception("TenantId bulunamadı");
      }

      final family = await _familyService.getFamilyByTenantId(_tenantId!);

      _familyNameController.text = family.name;
      _monthlyIncomeController.text = family.familyIncome.toString();

      // Harcamaları doldur
      _fixedExpenses = [];
      final icons = [
        Icons.home,
        Icons.flash_on,
        Icons.wifi,
        Icons.security,
        Icons.shopping_cart,
        Icons.directions_car,
        Icons.school,
        Icons.local_hospital,
        Icons.fitness_center,
        Icons.card_giftcard,
        Icons.pets,
      ];
      for (int i = 0; i < family.fixedExpenses.length; i++) {
        final exp = family.fixedExpenses[i];
        _fixedExpenses.add({
          'name': exp['name'],
          'controller': TextEditingController(text: exp['value'].toString()),
          'icon': i < icons.length ? icons[i] : Icons.shopping_cart,
          'isDefault': i < 4,
        });
      }

      // Profil özeti için gerçek verileri ayarla
      _summaryIncome = family.familyIncome;
      _summaryExpenses = family.fixedExpenses.fold<int>(
        0,
        (sum, item) => (sum +
                (item['value'] is int
                    ? item['value']
                    : int.tryParse(item['value'].toString()) ?? 0))
            .toInt(),
      );
    } catch (e) {
      // Hata yönetimi
      debugPrint("Family data yüklenirken hata: $e");
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Aile bilgisi yüklenemedi: $e")));
    }
    setState(() {
      _loading = false;
    });
  }

  void _addExpense() {
    setState(() {
      final icons = [
        Icons.shopping_cart,
        Icons.directions_car,
        Icons.school,
        Icons.local_hospital,
        Icons.fitness_center,
        Icons.card_giftcard,
        Icons.pets,
      ];
      _fixedExpenses.add({
        'name': 'Expense ${_fixedExpenses.length + 1}',
        'controller': TextEditingController(),
        'icon': icons[_fixedExpenses.length % icons.length],
        'isDefault': false,
      });
    });
  }

  void _deleteExpense(int index) {
    if (_fixedExpenses[index]['isDefault'] == true) return;
    setState(() {
      _fixedExpenses[index]['controller'].dispose();
      _fixedExpenses.removeAt(index);
    });
    _updateExpenseNames();
  }

  void _updateExpenseNames() {
    for (int i = 4; i < _fixedExpenses.length; i++) {
      _fixedExpenses[i]['name'] = 'Expense ${i + 1}';
    }
  }

  Future<void> _saveFamily() async {
    if (_tenantId == null) return;
    final name = _familyNameController.text.trim();
    final income = int.tryParse(_monthlyIncomeController.text.trim()) ?? 0;
    final expenses = _fixedExpenses.map((expense) {
      final valueText = expense['controller'].text.trim();
      final value = int.tryParse(valueText) ?? 0;
      return {
        'name': expense['name'],
        'value': value,
      };
    }).toList();

    final updateDto = UpdateFamilyDto(
      tenantId: _tenantId,
      name: name,
      familyIncome: income,
      fixedExpenses: expenses,
    );

    try {
      await _familyService.updateFamily(updateDto);
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Aile profili güncellendi")));
      Navigator.pop(context);
    } catch (e) {
      debugPrint("Aile profili güncellenirken hata: $e");
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Güncelleme hatası: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        if (_loading) {
          return Scaffold(
            backgroundColor: themeProvider.backgroundColor,
            body: const Center(child: CircularProgressIndicator()),
          );
        }
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
                onPressed: _saveFamily,
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

  Widget _buildProfileSummary(
      AppLocalizations l10n, ThemeProvider themeProvider) {
    final currencySymbol = l10n.currencySymbol ?? '₺';
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
                child: _buildSummaryItem(
                  l10n.monthlyIncome,
                  '$currencySymbol${_summaryIncome.toString()}',
                  themeProvider.successColor,
                ),
              ),
              Container(
                width: 1,
                height: 40,
                color: themeProvider.dividerColor,
                margin: const EdgeInsets.symmetric(horizontal: 16),
              ),
              Expanded(
                child: _buildSummaryItem(
                  l10n.fixedExpenses,
                  '$currencySymbol${_summaryExpenses.toString()}',
                  themeProvider.errorColor,
                ),
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

  Widget _buildFamilyNameField(
      AppLocalizations l10n, ThemeProvider themeProvider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.familyName,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xFF374151),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: TextField(
            controller: _familyNameController,
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.family_restroom, color: Color(0xFF6B7280)),
              border: InputBorder.none,
              contentPadding: EdgeInsets.all(16),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMonthlyIncomeField(
      AppLocalizations l10n, ThemeProvider themeProvider) {
    final currencySymbol = l10n.currencySymbol ?? '₺';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.monthlyFamilyIncome,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xFF374151),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: TextField(
            controller: _monthlyIncomeController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(
              prefixIcon: Container(
                margin: const EdgeInsets.all(12),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF10B981).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  currencySymbol,
                  style: const TextStyle(
                    color: Color(0xFF10B981),
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.all(16),
            ),
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1F2937),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFixedExpensesSection(
      AppLocalizations l10n, ThemeProvider themeProvider) {
    final currencySymbol = l10n.currencySymbol ?? '₺';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              l10n.fixedMonthlyExpenses,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF374151),
              ),
            ),
            const Spacer(),
            TextButton.icon(
              onPressed: _addExpense,
              icon: const Icon(Icons.add, size: 16),
              label: Text(l10n.addMore),
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFF6366F1),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ...List.generate(_fixedExpenses.length, (index) {
          final expense = _fixedExpenses[index];
          final isDefault = expense['isDefault'] == true;
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: expense['controller'],
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    decoration: InputDecoration(
                      labelText: expense['name'],
                      prefixIcon:
                          Icon(expense['icon'], color: const Color(0xFF6B7280)),
                      suffixText: currencySymbol,
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.all(16),
                      labelStyle: const TextStyle(color: Color(0xFF6B7280)),
                    ),
                  ),
                ),
                if (!isDefault)
                  IconButton(
                    onPressed: () => _deleteExpense(index),
                    icon: const Icon(Icons.delete_outline,
                        color: Color(0xFFEF4444)),
                  ),
              ],
            ),
          );
        }),
      ],
    );
  }

  Widget _buildActionButtons(
      AppLocalizations l10n, ThemeProvider themeProvider) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            onPressed: _saveFamily,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF6366F1),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              l10n.saveChanges,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          height: 56,
          child: OutlinedButton(
            onPressed: () => Navigator.pop(context),
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Color(0xFFEF4444)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              l10n.cancelChanges,
              style: const TextStyle(
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
