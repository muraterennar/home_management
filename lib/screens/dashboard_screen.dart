import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:home_management/models/espenses/expense_dto.dart';
import 'package:home_management/models/family/family_dto.dart';
import 'package:home_management/models/users/user_dto.dart';
import 'package:home_management/screens/create_family_profile_screen.dart';
import 'package:home_management/screens/family_profile_edit_screen.dart';
import 'package:home_management/services/expense_service.dart';
import 'package:home_management/services/family_service.dart';
import 'package:home_management/services/user_service.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../models/espenses/expense_category.dart';
import '../providers/theme_provider.dart';
import 'add_expense_screen.dart';
import 'expense_list_screen.dart';
import 'expense_dashboard_screen.dart';
import 'settings_screen.dart';
import 'package:home_management/l10n/app_localizations.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        final List<Widget> _screens = [
          DashboardHome(),
          ExpenseListScreen(),
          const ExpenseDashboardScreen(),
          const SettingsScreen(),
        ];

        return Scaffold(
          backgroundColor: themeProvider.backgroundColor,
          body: _screens[_selectedIndex],
          bottomNavigationBar: _buildBottomNavBar(l10n, themeProvider),
        );
      },
    );
  }

  Widget _buildBottomNavBar(
      AppLocalizations l10n, ThemeProvider themeProvider) {
    return Container(
      decoration: BoxDecoration(
        color: themeProvider.surfaceColor,
        boxShadow: [
          BoxShadow(
            color: themeProvider.isDarkMode ? Colors.black54 : Colors.black12,
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Container(
          height: 65,
          // Reduced from 70
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
          // Reduced vertical padding
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(Icons.dashboard_outlined, Icons.dashboard,
                  l10n.dashboard, 0, themeProvider),
              _buildNavItem(Icons.receipt_long_outlined, Icons.receipt_long,
                  l10n.expenses, 1, themeProvider),
              _buildNavItem(Icons.analytics_outlined, Icons.analytics,
                  l10n.analytics, 2, themeProvider),
              _buildNavItem(Icons.settings_outlined, Icons.settings,
                  l10n.settings, 3, themeProvider),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData outlinedIcon, IconData filledIcon, String label,
      int index, ThemeProvider themeProvider) {
    final isSelected = _selectedIndex == index;

    return GestureDetector(
      onTap: () => setState(() => _selectedIndex = index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        // Reduced padding
        decoration: BoxDecoration(
          color: isSelected
              ? themeProvider.primaryColor.withOpacity(0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isSelected ? filledIcon : outlinedIcon,
              color: isSelected
                  ? themeProvider.primaryColor
                  : themeProvider.iconColor,
              size: 22, // Reduced from 24
            ),
            const SizedBox(height: 2), // Reduced from 4
            Text(
              label,
              style: TextStyle(
                color: isSelected
                    ? themeProvider.primaryColor
                    : themeProvider.secondaryTextColor,
                fontSize: 10, // Reduced from 11
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

class DashboardHome extends StatefulWidget {
  @override
  _DashboardHomeState createState() => _DashboardHomeState();
}

class _DashboardHomeState extends State<DashboardHome> {
  // Servisler
  final _userService = UserService();
  final _familyService = FamilyService();
  final _expenseService = ExpenseService();

  // Veri state'leri
  bool _isLoading = true;
  String? _errorMessage;
  UserDto? _currentUser;
  FamilyDto? _family;
  List<ExpenseDto> _expenses = [];

  // Hesaplanan değerler
  double _totalIncome = 0;
  double _totalExpenses = 0;
  double _remainingBalance = 0;
  double _monthlyBudget = 0;
  List<Map<String, dynamic>> _recentTransactions = [];

  // Dinamik değişim yüzdeleri
  String _incomeChangePercent = '+0.0%';
  String _expenseChangePercent = '+0.0%';

  // Tarih bilgileri
  String _currentMonth = '';
  int _daysLeft = 0;
  double _monthProgress = 0;

  @override
  void initState() {
    super.initState();
    _loadData();
    _calculateDateInfo();
  }

  void _calculateDateInfo() {
    final now = DateTime.now();

    // Ay adını hesapla
    _currentMonth = DateFormat('MMMM yyyy').format(now);

    // Ay içinde kalan gün sayısını hesapla
    final lastDayOfMonth = DateTime(now.year, now.month + 1, 0);
    _daysLeft = lastDayOfMonth.day - now.day;

    // Ay ilerlemesini hesapla
    _monthProgress = now.day / lastDayOfMonth.day;
  }

  Future<void> _loadData() async {
    if (!mounted) return;
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Kullanıcı bilgilerini yükle
      _currentUser = await _userService.getCurrentUserProfile();

      if (_currentUser?.tenantId == null || _currentUser!.tenantId!.isEmpty) {
        if (!mounted) return;
        setState(() {
          _isLoading = false;
          _errorMessage = "Aile bilgisi bulunamadı";
        });
        return;
      }

      // Aile bilgilerini yükle
      _family =
          await _familyService.getFamilyByTenantId(_currentUser!.tenantId!);

      // Harcamaları yükle
      _expenses = await _expenseService.getAllExpenses();

      // Verileri işle
      _processData();

      if (!mounted) return;
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _errorMessage = e.toString();
      });
      print("Dashboard veri yükleme hatası: $e");
    }
  }

  void _processData() {
    final l10n = AppLocalizations.of(context)!;

    // Aylık gelir - Null kontrolü ekleyerek güvenli bir şekilde double'a dönüştürme
    final monthlyBudget = _family?.monthlyBudget?.toDouble() ?? 0.0;
    _totalIncome = _family?.familyIncome?.toDouble() ?? 0.0;
    _monthlyBudget = monthlyBudget;

    final now = DateTime.now();
    // Bu ay ve geçen ay için harcamaları ayır
    final thisMonthExpenses = _expenses
        .where((expense) =>
            expense.date.year == now.year && expense.date.month == now.month)
        .toList();
    final lastMonth = DateTime(now.year, now.month - 1, 1);
    final lastMonthExpenses = _expenses
        .where((expense) =>
            expense.date.year == lastMonth.year && expense.date.month == lastMonth.month)
        .toList();

    _totalExpenses =
        thisMonthExpenses.fold(0, (sum, expense) => sum + expense.amount);

    // Kalan bakiye
    _remainingBalance = _monthlyBudget - _totalExpenses;

    // Son harcamalar
    _expenses.sort((a, b) => b.date.compareTo(a.date)); // En yeni en başta
    final recentExpenses = _expenses.take(3).toList();

    _recentTransactions = recentExpenses.map((expense) {
      // Zaman farkını hesapla
      final difference = DateTime.now().difference(expense.date);
      String timeAgo;

      if (difference.inHours < 1) {
        timeAgo = '${difference.inMinutes} dakika önce';
      } else if (difference.inHours < 24) {
        timeAgo = '${difference.inHours} saat önce';
      } else if (difference.inDays < 30) {
        timeAgo = '${difference.inDays} gün önce';
      } else {
        timeAgo = DateFormat('dd MMM').format(expense.date);
      }

      IconData icon;
      Color color;
      String categoryName; // String olarak kategori adını tutacağız

      // Kategori ikonları ve renkleri
      switch (expense.category) {
        case ExpenseCategory.foodDining:
          icon = Icons.restaurant;
          color = Colors.redAccent;
          categoryName = l10n.foodDining;
          break;
        case ExpenseCategory.shopping:
          icon = Icons.shopping_bag;
          color = Colors.orangeAccent;
          categoryName = l10n.shopping;
          break;
        case ExpenseCategory.transportation:
          icon = Icons.directions_car;
          color = Colors.blueAccent;
          categoryName = l10n.transportation;
          break;
        case ExpenseCategory.billsUtilities:
          icon = Icons.receipt_long;
          color = Colors.purpleAccent;
          categoryName = l10n.billsUtilities;
          break;
        case ExpenseCategory.entertainment:
          icon = Icons.movie;
          color = Colors.pinkAccent;
          categoryName = l10n.entertainment;
          break;
        default:
          icon = Icons.attach_money;
          color = Colors.grey;
          categoryName = l10n.other;
      }

      return {
        'title': expense.name,
        'amount': '-\$${expense.amount.toStringAsFixed(2)}',
        'category': categoryName,
        'time': timeAgo,
        'icon': icon,
        'color': color
      };
    }).toList();

    // Dinamik değişim yüzdeleri hesaplama
    // Gelir değişimi
    double thisMonthIncome = _family?.familyIncome?.toDouble() ?? 0.0;
    double lastMonthIncome = _family?.lastMonthIncome?.toDouble() ?? 0.0;
    if (lastMonthIncome > 0) {
      double diff = thisMonthIncome - lastMonthIncome;
      double percent = (diff / lastMonthIncome) * 100;
      _incomeChangePercent = (percent >= 0 ? '+' : '') + percent.toStringAsFixed(1) + '%';
    } else {
      _incomeChangePercent = '+0.0%';
    }
    // Harcama değişimi
    double lastMonthTotalExpenses = lastMonthExpenses.fold(0, (sum, expense) => sum + expense.amount);
    if (lastMonthTotalExpenses > 0) {
      double diff = _totalExpenses - lastMonthTotalExpenses;
      double percent = (diff / lastMonthTotalExpenses) * 100;
      _expenseChangePercent = (percent >= 0 ? '+' : '') + percent.toStringAsFixed(1) + '%';
    } else {
      _expenseChangePercent = '+0.0%';
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        if (_isLoading) {
          return const SafeArea(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (_errorMessage != null) {
          return SafeArea(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Hata: $_errorMessage',
                    style: TextStyle(color: themeProvider.errorColor),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _loadData,
                    child: Text(l10n.tryAgain),
                  ),
                  const SizedBox(height: 20),
                  if (_currentUser?.tenantId == null ||
                      _currentUser!.tenantId!.isEmpty)
                    ElevatedButton(
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CreateFamilyProfileScreen()),
                      ),
                      child: Text(l10n.createFamilyProfile),
                    ),
                ],
              ),
            ),
          );
        }

        return SafeArea(
          child: RefreshIndicator(
            onRefresh: _loadData,
            child: CustomScrollView(
              slivers: [
                _buildHeader(context, l10n, themeProvider),
                SliverPadding(
                  padding: const EdgeInsets.all(20),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      _buildBudgetOverview(l10n, themeProvider),
                      const SizedBox(height: 24),
                      _buildMonthlyProgress(l10n, themeProvider),
                      const SizedBox(height: 24),
                      _buildQuickActions(context, l10n, themeProvider),
                      const SizedBox(height: 24),
                      _buildRecentTransactions(l10n, themeProvider),
                      const SizedBox(height: 20),
                    ]),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context, AppLocalizations l10n,
      ThemeProvider themeProvider) {
    // Aile adını formatla
    final familyName = _family?.name ?? 'Aile';
    final familyDisplay = '$familyName ${l10n.familySuffix}';

    return SliverToBoxAdapter(
      child: FadeInDown(
        child: Container(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                themeProvider.primaryColor,
                themeProvider.primaryVariant,
              ],
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _getGreeting(),
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '$familyName ${l10n.familySuffix}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      _buildHeaderAction(Icons.notifications_outlined, () {}),
                      const SizedBox(width: 12),
                      _buildHeaderAction(Icons.person_outline, () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => FamilyProfileEditScreen()),
                        ).then((_) =>
                            _loadData()); // Geri döndüğünde verileri yenile
                      }),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.white.withOpacity(0.2)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.calendar_today_outlined,
                        color: Colors.white, size: 20),
                    const SizedBox(width: 12),
                    Text(
                      _currentMonth,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      l10n.daysLeft(_daysLeft),
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderAction(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: Colors.white, size: 20),
      ),
    );
  }

  Widget _buildBudgetOverview(
      AppLocalizations l10n, ThemeProvider themeProvider) {
    // Aile adını formatla
    final familyName = _family?.name;
    final familyDisplay = '$familyName ${l10n.familySuffix}';
    final currencySymbol = l10n.currencySymbol ?? '₺';

    // Geçen aya göre değişim yüzdesi (örnek - gerçek veri yok)
    // final incomeChangePercent = '+2.0%';
    // final expenseChangePercent = _expenses.isEmpty ? '+0.0%' : '+12.5%';
    final incomeChangePercent = _incomeChangePercent;
    final expenseChangePercent = _expenseChangePercent;

    // Bütçe durumu (Yolunda mı, aşıldı mı?)
    final bool isBudgetOnTrack = _totalExpenses <= _totalIncome;

    // Kalan bakiyenin gelire oranı
    final remainingPercentage = _totalIncome > 0
        ? (_remainingBalance / _totalIncome * 100).toStringAsFixed(0)
        : '0';

    return FadeInUp(
      delay: const Duration(milliseconds: 200),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: themeProvider.cardColor,
          borderRadius: BorderRadius.circular(20),
          boxShadow: themeProvider.cardShadow,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    l10n.budgetOverview,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: themeProvider.primaryTextColor,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: isBudgetOnTrack
                        ? themeProvider.successColor.withOpacity(0.1)
                        : themeProvider.errorColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    isBudgetOnTrack ? l10n.onTrack : l10n.budgetOverflow,
                    style: TextStyle(
                      color: isBudgetOnTrack
                          ? themeProvider.successColor
                          : themeProvider.errorColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: _buildBudgetItem(
                    l10n.totalIncome,
                    '$currencySymbol${_totalIncome.toStringAsFixed(0)}',
                    Icons.trending_up,
                    themeProvider.successColor,
                    incomeChangePercent,
                    themeProvider,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildBudgetItem(
                    l10n.totalSpending,
                    '$currencySymbol${_totalExpenses.toStringAsFixed(0)}',
                    Icons.trending_down,
                    themeProvider.errorColor,
                    expenseChangePercent,
                    themeProvider,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    themeProvider.successColor.withOpacity(0.1),
                    themeProvider.successColor.withOpacity(0.05),
                  ],
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                    color: themeProvider.successColor.withOpacity(0.2)),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: _remainingBalance >= 0
                          ? themeProvider.successColor
                          : themeProvider.errorColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.account_balance_wallet,
                        color: Colors.white, size: 24),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.remainingBalance,
                          style: TextStyle(
                            color: themeProvider.secondaryTextColor,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '$currencySymbol${_remainingBalance.toStringAsFixed(0)}',
                          style: TextStyle(
                            color: _remainingBalance >= 0
                                ? themeProvider.primaryTextColor
                                : themeProvider.errorColor,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '${remainingPercentage}%',
                        style: TextStyle(
                          color: _remainingBalance >= 0
                              ? themeProvider.successColor
                              : themeProvider.errorColor,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        l10n?.ofIncome(remainingPercentage) ?? '',
                        style: TextStyle(
                          color: themeProvider.secondaryTextColor,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBudgetItem(String title, String amount, IconData icon,
      Color color, String change, ThemeProvider themeProvider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: color, size: 16),
            ),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                change,
                style: TextStyle(
                  color: color,
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Text(
          title,
          style: TextStyle(
            color: themeProvider.secondaryTextColor,
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          amount,
          style: TextStyle(
            color: themeProvider.primaryTextColor,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildMonthlyProgress(
      AppLocalizations l10n, ThemeProvider themeProvider) {
    // Günlük ortalama harcama
    final now = DateTime.now();
    final daysPassedInMonth = now.day;
    final averageDaily =
        daysPassedInMonth > 0 ? (_totalExpenses / daysPassedInMonth) : 0;

    // Bütçe kullanım yüzdesi
    final budgetUsedPercent = _totalIncome > 0
        ? ((_totalExpenses / _totalIncome) * 100).toStringAsFixed(0)
        : '0';

    return FadeInUp(
      delay: const Duration(milliseconds: 300),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: themeProvider.cardColor,
          borderRadius: BorderRadius.circular(20),
          boxShadow: themeProvider.cardShadow,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  l10n.monthlyProgress,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: themeProvider.primaryTextColor,
                  ),
                ),
                Text(
                  l10n.daysLeft(_daysLeft),
                  style: TextStyle(
                    color: themeProvider.secondaryTextColor,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            LinearProgressIndicator(
              value: _monthProgress,
              backgroundColor: themeProvider.borderColor,
              valueColor:
                  AlwaysStoppedAnimation<Color>(themeProvider.primaryColor),
              minHeight: 8,
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: _buildProgressItem(
                      l10n.daysPassed, '$daysPassedInMonth', themeProvider),
                ),
                Expanded(
                  child: _buildProgressItem(
                      l10n.budgetUsed, '$budgetUsedPercent%', themeProvider),
                ),
                Expanded(
                  child: _buildProgressItem(
                      l10n.dailyAverage,
                      '${l10n.currencySymbol} ${averageDaily.toStringAsFixed(0)}',
                      themeProvider),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressItem(
      String label, String value, ThemeProvider themeProvider) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            color: themeProvider.primaryTextColor,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: themeProvider.secondaryTextColor,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildQuickActions(BuildContext context, AppLocalizations l10n,
      ThemeProvider themeProvider) {
    return FadeInUp(
      delay: const Duration(milliseconds: 400),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.quickActions,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: themeProvider.primaryTextColor,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildActionCard(
                  l10n.addExpenseAction,
                  Icons.add_circle_outline,
                  themeProvider.primaryColor,
                  () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AddExpenseScreen())),
                  themeProvider,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildActionCard(
                  l10n.viewAnalyticsAction,
                  Icons.analytics_outlined,
                  themeProvider.warningColor,
                  () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              const ExpenseDashboardScreen())),
                  themeProvider,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildActionCard(
                  l10n.allExpensesAction,
                  Icons.receipt_long_outlined,
                  themeProvider.successColor,
                  () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ExpenseListScreen())),
                  themeProvider,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionCard(String title, IconData icon, Color color,
      VoidCallback onTap, ThemeProvider themeProvider) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.2)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 8),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: themeProvider.primaryTextColor,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentTransactions(
      AppLocalizations l10n, ThemeProvider themeProvider) {
    final currencySymbol = l10n.currencySymbol ?? '₺';

    return FadeInUp(
      delay: const Duration(milliseconds: 500),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: themeProvider.cardColor,
          borderRadius: BorderRadius.circular(20),
          boxShadow: themeProvider.cardShadow,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  l10n.recentTransactions,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: themeProvider.primaryTextColor,
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ExpenseListScreen())),
                  child: Text(
                    l10n.viewAll,
                    style: TextStyle(
                      color: themeProvider.primaryColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ..._recentTransactions.map((transaction) {
              // Tutarı düzenle
              String formattedAmount = (transaction['amount'] as String)
                  .replaceAll('\$', currencySymbol);
              transaction['amount'] = formattedAmount;

              return _buildTransactionItem(transaction, themeProvider);
            }).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionItem(
      Map<String, dynamic> transaction, ThemeProvider themeProvider) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: (transaction['color'] as Color).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              transaction['icon'] as IconData,
              color: transaction['color'] as Color,
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction['title'] as String,
                  style: TextStyle(
                    color: themeProvider.primaryTextColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${transaction['category']} • ${transaction['time']}',
                  style: TextStyle(
                    color: themeProvider.secondaryTextColor,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8), // Biraz boşluk ekleyelim
          Text(
            transaction['amount'] as String,
            style: TextStyle(
              color: (transaction['amount'] as String).startsWith('+')
                  ? themeProvider.successColor
                  : themeProvider.errorColor,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    final l10n = AppLocalizations.of(context);

    if (hour < 12) return l10n?.goodMorning ?? "";
    if (hour < 17) return l10n?.goodAfternoon ?? "";
    return l10n?.goodEvening ?? "";
  }
}
