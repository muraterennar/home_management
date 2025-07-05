import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:home_management/screens/dashboard_screen.dart';
import 'package:home_management/services/family_service.dart';
import 'dart:developer';
import '../l10n/app_localizations.dart';
import '../models/family/crete_family_dto.dart';
import '../services/user_service.dart';

class CreateFamilyProfileScreen extends StatefulWidget {
  @override
  _CreateFamilyProfileScreenState createState() =>
      _CreateFamilyProfileScreenState();
}

class _CreateFamilyProfileScreenState extends State<CreateFamilyProfileScreen> {
  final _familyNameController = TextEditingController();
  final _monthlyIncomeController = TextEditingController();
  final _invitationCodeController = TextEditingController(); // Davet kodu için
  final _familyService = FamilyService();
  final _userService = UserService();

  // Görünüm modu - 0: seçim ekranı, 1: yeni aile oluştur, 2: aileye katıl
  int _viewMode = 0;
  bool _isLoading = false;
  String? _errorMessage;

  final List<Map<String, dynamic>> _fixedExpenses = [
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
    if (index < 4) return; // Varsayılan harcamaları silmeye izin verme

    setState(() {
      // Önce controller'ı dispose edelim
      _fixedExpenses[index]['controller'].dispose();
      // Sonra listeden kaldıralım
      _fixedExpenses.removeAt(index);
    });

    // İsteğe bağlı: Silindikten sonra, geri kalan harcamaların isimlerini güncelle
    _updateExpenseNames();
  }

  void _updateExpenseNames() {
    for (int i = 4; i < _fixedExpenses.length; i++) {
      _fixedExpenses[i]['name'] = 'Expense ${i + 1}';
    }
  }

  CreateFamilyDto _createFamilyDto() {
    // Aile adını al
    final name = _familyNameController.text.trim();

    // Aylık geliri int'e dönüştür (geçersiz ise 0 kullan)
    final incomeText = _monthlyIncomeController.text.trim();
    final income = int.tryParse(incomeText) ?? 0;

    // Sabit giderleri işle
    final expenses = _fixedExpenses.map((expense) {
      final valueText = expense['controller'].text.trim();
      final value = int.tryParse(valueText) ?? 0;

      return {
        'name': expense['name'],
        'value': value,
      };
    }).toList();

    return CreateFamilyDto(
        name: name,
        familyIncome: income,
        fixedExpenses: expenses,
        tenantId: 'test');
  }

  Future<void> _createNewFamily() async {
    if (_familyNameController.text.trim().isEmpty) {
      setState(() {
        _errorMessage = AppLocalizations.of(context)!.fillAllFields;
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Form verilerinden CreateFamilyDto objesi oluştur
      final familyDto = _createFamilyDto();

      // Aile oluştur
      var addedFamily = await _familyService.createFamily(familyDto);
      await _userService.setTenantId(addedFamily.tenantId!);

      // Ana ekrana git
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const DashboardScreen()),
      );
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _joinExistingFamily() async {
    final invitationCode = _invitationCodeController.text.trim();
    if (invitationCode.isEmpty) {
      setState(() {
        _errorMessage = AppLocalizations.of(context)!.fillAllFields;
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Davet koduyla aile bul ve katıl
      final family = await _familyService.getFamilyByCode(invitationCode);
      await _userService.setTenantId(family.tenantId!);

      // Ana ekrana git
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const DashboardScreen()),
      );
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    // Loading gösterimi
    if (_isLoading) {
      return Scaffold(
        backgroundColor: const Color(0xFFF8FAFC),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text(
            l10n.familySetup,
            style: const TextStyle(
              color: Color(0xFF1F2937),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: _viewMode > 0
            ? IconButton(
                onPressed: () {
                  setState(() {
                    _viewMode = 0;
                    _errorMessage = null;
                  });
                },
                icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF1F2937)),
              )
            : null,
        title: Text(
          _viewMode == 0
              ? l10n.familySetup
              : _viewMode == 1
                  ? l10n.createFamilyProfile
                  : l10n.joinFamily,
          style: const TextStyle(
            color: Color(0xFF1F2937),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_errorMessage != null)
              FadeInUp(
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  margin: const EdgeInsets.only(bottom: 24),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.red.shade200),
                  ),
                  child: Text(
                    _errorMessage!,
                    style: TextStyle(color: Colors.red.shade800),
                  ),
                ),
              ),

            // Görünüm moduna göre içerik göster
            if (_viewMode == 0) _buildSelectionView(l10n),
            if (_viewMode == 1) _buildCreateFamilyView(l10n),
            if (_viewMode == 2) _buildJoinFamilyView(l10n),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectionView(AppLocalizations l10n) {
    return Column(
      children: [
        FadeInUp(
          child: _buildWelcomeCard(),
        ),
        const SizedBox(height: 32),
        FadeInUp(
          delay: const Duration(milliseconds: 200),
          child: _buildOptionCard(
            title: l10n.createNewFamily,
            description: l10n.createNewFamilyDesc,
            icon: Icons.add_home,
            color: const Color(0xFF6366F1),
            onTap: () {
              setState(() {
                _viewMode = 1;
              });
            },
          ),
        ),
        const SizedBox(height: 16),
        FadeInUp(
          delay: const Duration(milliseconds: 300),
          child: _buildOptionCard(
            title: l10n.joinExistingFamily,
            description: l10n.joinExistingFamilyDesc,
            icon: Icons.family_restroom,
            color: const Color(0xFF10B981),
            onTap: () {
              setState(() {
                _viewMode = 2;
              });
            },
          ),
        ),
      ],
    );
  }

  Widget _buildOptionCard({
    required String title,
    required String description,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    icon,
                    color: color,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Color(0xFF1F2937),
                        ),
                      ),
                      Text(
                        description,
                        style: const TextStyle(
                          color: Color(0xFF6B7280),
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  color: color,
                  size: 16,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildJoinFamilyView(AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FadeInUp(
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF10B981), Color(0xFF059669)],
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.group_add, color: Colors.white, size: 32),
                const SizedBox(height: 16),
                Text(
                  l10n.joinExistingFamily,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  l10n.joinExistingFamilyDesc,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 32),
        FadeInUp(
          delay: const Duration(milliseconds: 200),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.invitationCode,
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
                  controller: _invitationCodeController,
                  decoration: InputDecoration(
                    hintText: "ABC123",
                    prefixIcon: const Icon(Icons.key, color: Color(0xFF6B7280)),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.all(16),
                    hintStyle: const TextStyle(color: Color(0xFF9CA3AF)),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _joinExistingFamily,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF10B981),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    l10n.joinFamily,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCreateFamilyView(AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FadeInUp(
          child: _buildWelcomeCard(),
        ),
        const SizedBox(height: 32),
        FadeInUp(
          delay: const Duration(milliseconds: 200),
          child: _buildFamilyNameField(),
        ),
        const SizedBox(height: 24),
        FadeInUp(
          delay: const Duration(milliseconds: 400),
          child: _buildMonthlyIncomeField(),
        ),
        const SizedBox(height: 32),
        FadeInUp(
          delay: const Duration(milliseconds: 600),
          child: _buildFixedExpensesSection(),
        ),
        const SizedBox(height: 40),
        FadeInUp(
          delay: const Duration(milliseconds: 800),
          child: _buildCreateButton(),
        ),
      ],
    );
  }

  Widget _buildWelcomeCard() {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      padding: const EdgeInsets.all(24),
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
          const Icon(Icons.family_restroom, color: Colors.white, size: 32),
          const SizedBox(height: 16),
          Text(
            l10n.welcomeToFamilyFinance,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.familyFinanceDesc,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFamilyNameField() {
    final l10n = AppLocalizations.of(context)!;

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
            decoration: InputDecoration(
              hintText: l10n.theFamilyName,
              prefixIcon:
                  const Icon(Icons.family_restroom, color: Color(0xFF6B7280)),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.all(16),
              hintStyle: const TextStyle(color: Color(0xFF9CA3AF)),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMonthlyIncomeField() {
    final l10n = AppLocalizations.of(context)!;
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
              hintText: '0.00',
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
              hintStyle: const TextStyle(color: Color(0xFF9CA3AF)),
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

  Widget _buildFixedExpensesSection() {
    final l10n = AppLocalizations.of(context)!;
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
                      labelText: isDefault
                          ? l10n.getString(
                              expense['name'].toString().toLowerCase())
                          : expense['name'],
                      prefixIcon:
                          Icon(expense['icon'], color: const Color(0xFF6B7280)),
                      suffixText: currencySymbol,
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.all(16),
                      labelStyle: const TextStyle(color: Color(0xFF6B7280)),
                    ),
                  ),
                ),
                // Varsayılan olmayan harcamalara silme butonu ekle
                if (!isDefault)
                  IconButton(
                    icon: const Icon(Icons.delete_outline,
                        color: Color(0xFFEF4444)),
                    // Kırmızı renkte silme ikonu
                    onPressed: () => _deleteExpense(index),
                    tooltip: l10n.delete,
                  ),
              ],
            ),
          );
        }),
      ],
    );
  }

  Widget _buildCreateButton() {
    final l10n = AppLocalizations.of(context)!;

    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: _createNewFamily,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF6366F1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          l10n.createFamilyProfile,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

extension AppLocalizationsHelper on AppLocalizations {
  String getString(String key) {
    switch (key) {
      case 'rent':
        return rent;
      case 'utilities':
        return utilities;
      case 'internet':
        return internet;
      case 'insurance':
        return insurance;
      default:
        return key;
    }
  }
}
