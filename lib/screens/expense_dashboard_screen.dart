import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import 'package:home_management/l10n/app_localizations.dart';
import 'settings_screen.dart';
import 'expense_list_screen.dart';
import 'add_expense_screen.dart';
import 'package:home_management/services/expense_service.dart';
import 'package:home_management/services/user_service.dart';
import 'package:home_management/services/family_service.dart'; // Eklendi
import 'package:home_management/models/espenses/expense_dto.dart';
import 'package:home_management/models/family/family_dto.dart'; // Eklendi
import 'package:intl/intl.dart';

class ExpenseDashboardScreen extends StatefulWidget {
  const ExpenseDashboardScreen({super.key});

  @override
  _ExpenseDashboardScreenState createState() => _ExpenseDashboardScreenState();
}

class _ExpenseDashboardScreenState extends State<ExpenseDashboardScreen> {
  int _selectedPeriod = 0;
  final List<String> _periods = ['Week', 'Month', 'Year'];
  int _selectedChartIndex = 0;

  // Servisler
  final _expenseService = ExpenseService();
  final _userService = UserService();
  final _familyService = FamilyService(); // Eklendi

  // State değişkenleri
  bool _isLoading = true;
  String? _error;
  List<ExpenseDto> _expenses = [];
  Map<String, double> _categoryTotals = {};
  Map<int, double> _monthlyTotals = {};
  double _totalSpending = 0;
  double _lastMonthSpending = 0;
  double _monthlyBudget = 0; // Varsayılan 3000 değerini kaldırdık
  FamilyDto? _family; // Aile bilgilerini tutacak değişken

  // Tarih filtresi
  DateTimeRange _dateRange = DateTimeRange(
    start: DateTime.now().subtract(const Duration(days: 30)),
    end: DateTime.now(),
  );
  bool _isDateRangeActive = false; // Tarih filtresinin aktif olup olmadığını takip etme

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      // Önce kullanıcı profili al
      final user = await _userService.getCurrentUserProfile();

      if (user.tenantId == null || user.tenantId!.isEmpty) {
        setState(() {
          _error = "Henüz bir aileye bağlı değilsiniz";
          _isLoading = false;
        });
        return;
      }

      // Aile bilgilerini al
      final family = await _familyService.getFamilyByTenantId(user.tenantId!);

      // Tüm harcamaları çek
      final expenses = await _expenseService.getAllExpenses();

      if (mounted) {
        setState(() {
          _family = family;
          _expenses = expenses;

          // Aile gelirini aylık bütçe olarak ayarla
          _monthlyBudget = family.monthlyBudget.toDouble();

          _processData();
          _isLoading = false;
        });
      }
    } catch (e) {
      print("Dashboard veri yükleme hatası: $e");
      if (mounted) {
        setState(() {
          _error = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  void _processData() {
    // Harcama istatistiklerini hesapla
    _calculateTotalSpending();
    _calculateCategoryTotals();
    _calculateMonthlyTotals();
  }

  void _calculateTotalSpending() {
    // Seçili döneme göre (hafta, ay, yıl) filtrele
    List<ExpenseDto> filteredExpenses = _filterExpensesByPeriod(_expenses);

    // Toplam harcama
    _totalSpending = filteredExpenses.fold(0, (sum, expense) => sum + expense.amount);

    // Geçen dönem harcaması (seçilen periyoda göre)
    List<ExpenseDto> lastPeriodExpenses;
    final now = DateTime.now();

    if (_isDateRangeActive) {
      // Tarih aralığı seçildiyse, aynı uzunlukta önceki aralık
      final duration = _dateRange.duration;
      final lastPeriodStart = _dateRange.start.subtract(Duration(days: duration.inDays + 1));
      final lastPeriodEnd = _dateRange.start.subtract(const Duration(days: 1));

      lastPeriodExpenses = _expenses.where((expense) =>
        expense.date.isAfter(lastPeriodStart) &&
        expense.date.isBefore(lastPeriodEnd.add(const Duration(days: 1)))
      ).toList();
    } else if (_selectedPeriod == 0) { // Hafta
      // Geçen hafta
      final thisWeekStart = now.subtract(Duration(days: now.weekday - 1));
      final lastWeekStart = thisWeekStart.subtract(const Duration(days: 7));
      final lastWeekEnd = thisWeekStart.subtract(const Duration(days: 1));

      lastPeriodExpenses = _expenses.where((expense) =>
        expense.date.isAfter(lastWeekStart.subtract(const Duration(days: 1))) &&
        expense.date.isBefore(lastWeekEnd.add(const Duration(days: 1)))
      ).toList();
    } else if (_selectedPeriod == 1) { // Ay
      // Geçen ay
      final lastMonth = DateTime(now.year, now.month - 1);
      lastPeriodExpenses = _expenses.where((expense) =>
        expense.date.year == lastMonth.year && expense.date.month == lastMonth.month
      ).toList();
    } else { // Yıl
      // Geçen yıl
      lastPeriodExpenses = _expenses.where((expense) =>
        expense.date.year == now.year - 1
      ).toList();
    }

    _lastMonthSpending = lastPeriodExpenses.fold(0, (sum, expense) => sum + expense.amount);
  }

  void _calculateCategoryTotals() {
    _categoryTotals = {};

    // Seçili döneme göre (hafta, ay, yıl) filtrele
    List<ExpenseDto> filteredExpenses = _filterExpensesByPeriod(_expenses);

    // Kategori bazlı toplam hesapla
    for (var expense in filteredExpenses) {
      final category = expense.category;
      if (_categoryTotals.containsKey(category)) {
        _categoryTotals[category] = (_categoryTotals[category] ?? 0) + expense.amount;
      } else {
        _categoryTotals[category] = expense.amount;
      }
    }
  }

  void _calculateMonthlyTotals() {
    _monthlyTotals = {};

    // Son 6 ay için aylık toplamları hesapla
    final now = DateTime.now();
    for (int i = 5; i >= 0; i--) {
      final month = now.month - i;
      final year = now.year + (month <= 0 ? -1 : 0);
      final adjustedMonth = month <= 0 ? month + 12 : month;

      final monthExpenses = _expenses.where((expense) =>
        expense.date.year == year && expense.date.month == adjustedMonth);

      final total = monthExpenses.fold(0.0, (sum, expense) => sum + expense.amount);
      _monthlyTotals[adjustedMonth] = total;
    }
  }

  List<ExpenseDto> _filterExpensesByPeriod(List<ExpenseDto> expenses) {
    // Önce tarih aralığına göre filtrele (eğer aktifse)
    if (_isDateRangeActive) {
      expenses = expenses.where((expense) =>
        expense.date.isAfter(_dateRange.start.subtract(const Duration(days: 1))) &&
        expense.date.isBefore(_dateRange.end.add(const Duration(days: 1)))
      ).toList();
      return expenses; // Tarih aralığı aktifse diğer filtreleri uygulamadan dön
    }

    // Tarih aralığı aktif değilse, seçilen periyoda göre filtrele
    final now = DateTime.now();

    if (_selectedPeriod == 0) { // Hafta
      final weekStart = now.subtract(Duration(days: now.weekday - 1));
      return expenses.where((expense) =>
        expense.date.isAfter(weekStart.subtract(const Duration(days: 1))) ||
        expense.date.day == weekStart.day).toList();
    } else if (_selectedPeriod == 1) { // Ay
      return expenses.where((expense) =>
        expense.date.year == now.year && expense.date.month == now.month).toList();
    } else { // Yıl
      return expenses.where((expense) => expense.date.year == now.year).toList();
    }
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
            title: Text(
              l10n.analytics,
              style: TextStyle(
                color: themeProvider.primaryTextColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            actions: [
              Stack(
                alignment: Alignment.topRight,
                children: [
                  IconButton(
                    onPressed: _showDateRangePicker,
                    icon: Icon(
                      Icons.calendar_today,
                      color: _isDateRangeActive
                          ? themeProvider.primaryColor
                          : themeProvider.iconColor
                    ),
                  ),
                  if (_isDateRangeActive)
                    Positioned(
                      right: 8,
                      top: 8,
                      child: Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: Color(0xFFEF4444),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                ],
              ),
              IconButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const SettingsScreen()),
                ),
                icon: Icon(Icons.settings, color: themeProvider.iconColor),
              ),
            ],
          ),
          body: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _error != null
                  ? Center(child: Text('Error: $_error'))
                  : RefreshIndicator(
                      onRefresh: _loadData,
                      child: SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        child: Column(
                          children: [
                            _buildPeriodSelector(themeProvider),
                            _buildTotalSpendingCard(l10n, themeProvider),
                            _buildBudgetProgressCard(l10n, themeProvider),
                            _buildChartSection(l10n, themeProvider),
                            _buildCategoryBreakdown(l10n, themeProvider),
                            _buildMonthlyComparison(l10n, themeProvider),
                            _buildRecentTransactions(l10n, themeProvider),
                            const SizedBox(height: 80), // Artırılmış bottom padding
                          ],
                        ),
                      ),
                    ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddExpenseScreen()),
              );
              // Yeni harcama eklendiğinde verileri yenile
              _loadData();
            },
            backgroundColor: themeProvider.primaryColor,
            icon: const Icon(Icons.add, color: Colors.white),
            label: Text(l10n.addExpense,
                style: const TextStyle(color: Colors.white)),
            elevation: 4.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.endFloat,
        );
      },
    );
  }

  void _showDateRangePicker() async {
    final pickedDateRange = await showDateRangePicker(
      context: context,
      initialDateRange: _dateRange,
      firstDate: DateTime(DateTime.now().year - 1),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF6366F1),
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDateRange != null) {
      setState(() {
        _dateRange = pickedDateRange;
        _isDateRangeActive = true; // Tarih aralığı filtresini aktifleştir
      });
      _loadData(); // Yeni tarih aralığı için verileri yükle
    }
  }

  Widget _buildPeriodSelector(ThemeProvider themeProvider) {
    final l10n = AppLocalizations.of(context)!;
    final List<String> localizedPeriods = [
      l10n.week,
      l10n.month,
      l10n.year,
    ];

    return FadeInDown(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: themeProvider.cardColor,
          borderRadius: BorderRadius.circular(12),
          boxShadow: themeProvider.cardShadow,
        ),
        child: Column(
          children: [
            // Tarih aralığı göstergesi
            if (_isDateRangeActive)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '${DateFormat('dd MMM').format(_dateRange.start)} - ${DateFormat('dd MMM').format(_dateRange.end)}',
                      style: TextStyle(
                        color: themeProvider.primaryTextColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _isDateRangeActive = false;
                        });
                        _loadData();
                      },
                      child: Icon(
                        Icons.close,
                        size: 16,
                        color: themeProvider.secondaryTextColor,
                      ),
                    ),
                  ],
                ),
              ),
            Row(
              children: localizedPeriods.map((period) {
                final index = localizedPeriods.indexOf(period);
                final isSelected = _selectedPeriod == index && !_isDateRangeActive;

                return Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedPeriod = index;
                        _isDateRangeActive = false; // Periyot seçildiğinde tarih aralığı filtresini devre dışı bırak
                      });
                      _loadData(); // Yeni periyot için verileri yükle
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? themeProvider.primaryColor
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        period,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: isSelected
                              ? Colors.white
                              : _isDateRangeActive
                                ? themeProvider.secondaryTextColor.withOpacity(0.5)
                                : themeProvider.secondaryTextColor,
                          fontWeight:
                              isSelected ? FontWeight.w600 : FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTotalSpendingCard(AppLocalizations l10n, ThemeProvider themeProvider) {
    // Yüzde değişimi hesapla
    double percentChange = 0;
    if (_lastMonthSpending > 0) {
      percentChange = ((_totalSpending - _lastMonthSpending) / _lastMonthSpending) * 100;
    }

    final currencySymbol = l10n.currencySymbol ?? '₺';

    // Karşılaştırma etiketi (seçilen periyoda göre)
    String comparisonLabel;
    if (_isDateRangeActive) {
      comparisonLabel = l10n.vsPreviousPeriod ?? "vs Previous Period";
    } else if (_selectedPeriod == 0) {
      comparisonLabel = l10n.vsLastWeek ?? "vs Last Week";
    } else if (_selectedPeriod == 1) {
      comparisonLabel = l10n.vsLastMonth;
    } else {
      comparisonLabel = l10n.vsLastYear ?? "vs Last Year";
    }

    // Günlük ortalamayı hesapla
    double dailyAverage = 0;
    final filteredExpenses = _filterExpensesByPeriod(_expenses);
    if (filteredExpenses.isNotEmpty) {
      if (_isDateRangeActive) {
        // Tarih aralığına göre günlük ortalama
        final days = _dateRange.duration.inDays + 1; // Seçilen gün sayısı
        dailyAverage = _totalSpending / days;
      } else if (_selectedPeriod == 0) { // Hafta
        dailyAverage = _totalSpending / 7;
      } else if (_selectedPeriod == 1) { // Ay
        final daysInMonth = DateTime(DateTime.now().year, DateTime.now().month + 1, 0).day;
        dailyAverage = _totalSpending / daysInMonth;
      } else { // Yıl
        dailyAverage = _totalSpending / 365;
      }
    }

    return FadeInUp(
      delay: const Duration(milliseconds: 200),
      child: Container(
        margin: const EdgeInsets.all(24),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
          ),
          borderRadius: BorderRadius.circular(20),
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
                      l10n.totalSpendingText,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '$currencySymbol${_totalSpending.toStringAsFixed(2)}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    percentChange >= 0 ? Icons.trending_up : Icons.trending_down,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                _buildSpendingMetric(
                    comparisonLabel,
                    '${percentChange >= 0 ? '+' : ''}${percentChange.toStringAsFixed(1)}%',
                    percentChange >= 0 ? const Color(0xFF10B981) : Colors.red),
                const SizedBox(width: 24),
                _buildSpendingMetric(
                    l10n.averageDaily, '$currencySymbol${dailyAverage.toStringAsFixed(2)}', Colors.white70),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSpendingMetric(String label, String value, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            color: color,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildBudgetProgressCard(
      AppLocalizations l10n, ThemeProvider themeProvider) {
    // Bütçe yüzdesini hesapla
    double progressPercentage = _monthlyBudget > 0 ? _totalSpending / _monthlyBudget : 0;
    // Aşım durumunda progressPercentage değerini 1 olarak sınırla (UI için)
    bool isBudgetExceeded = progressPercentage > 1;

    if (progressPercentage > 1) progressPercentage = 1;

    final currencySymbol = l10n.currencySymbol ?? '₺';

    // Kalan bütçeyi hesapla, eksi değeri olduğu gibi bırak
    double remaining = _monthlyBudget - _totalSpending;

    return FadeInUp(
      delay: const Duration(milliseconds: 300),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: themeProvider.cardColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: themeProvider.cardShadow,
          // Bütçe aşıldıysa hafif kırmızı bir kenarlık ekle
          border: isBudgetExceeded
              ? Border.all(color: const Color(0xFFEF4444).withOpacity(0.5), width: 2)
              : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  l10n.monthlyBudget,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: themeProvider.primaryTextColor,
                  ),
                ),
                Text(
                  '$currencySymbol${_monthlyBudget.toStringAsFixed(0)}',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: themeProvider.primaryTextColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: progressPercentage,
                minHeight: 12,
                backgroundColor: const Color(0xFFE5E7EB),
                valueColor: AlwaysStoppedAnimation<Color>(
                    isBudgetExceeded
                        ? const Color(0xFFEF4444)
                        : progressPercentage > 0.8
                            ? const Color(0xFFF59E0B) // Sarı
                            : const Color(0xFF10B981)), // Yeşil
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
                      l10n.totalSpendingText, // "Kira" yerine "Toplam Harcama"
                      style: TextStyle(
                        fontSize: 12,
                        color: themeProvider.secondaryTextColor,
                      ),
                    ),
                    Text(
                      '$currencySymbol${_totalSpending.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFFEF4444),
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      remaining >= 0 ? l10n.remaining : l10n.budgetExceeded ?? "Bütçe Aşımı",
                      style: TextStyle(
                        fontSize: 12,
                        color: remaining >= 0
                            ? themeProvider.secondaryTextColor
                            : const Color(0xFFEF4444),
                      ),
                    ),
                    Text(
                      remaining >= 0
                          ? '$currencySymbol${remaining.toStringAsFixed(2)}'
                          : '-$currencySymbol${remaining.abs().toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: remaining >= 0
                            ? const Color(0xFF10B981) // Yeşil
                            : const Color(0xFFEF4444), // Kırmızı
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChartSection(
      AppLocalizations l10n, ThemeProvider themeProvider) {
    final List<Map<String, dynamic>> chartOptions = [
      {'title': l10n.spendingTrend, 'icon': Icons.trending_up},
      {'title': l10n.incomeVsExpenses, 'icon': Icons.swap_vert},
      {'title': l10n.savingsGoals, 'icon': Icons.savings},
    ];

    return FadeInUp(
      delay: const Duration(milliseconds: 400),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: themeProvider.cardColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: themeProvider.cardShadow,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(
                  chartOptions.length,
                  (index) => GestureDetector(
                    onTap: () => setState(() => _selectedChartIndex = index),
                    child: Container(
                      margin: const EdgeInsets.only(right: 12),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: _selectedChartIndex == index
                            ? themeProvider.primaryColor
                            : themeProvider.primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            chartOptions[index]['icon'],
                            size: 16,
                            color: _selectedChartIndex == index
                                ? Colors.white
                                : themeProvider.primaryColor,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            chartOptions[index]['title'],
                            style: TextStyle(
                              color: _selectedChartIndex == index
                                  ? Colors.white
                                  : themeProvider.primaryColor,
                              fontWeight: _selectedChartIndex == index
                                  ? FontWeight.w600
                                  : FontWeight.normal,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 500),
              child: _selectedChartIndex == 0
                  ? _buildLineChart()
                  : _selectedChartIndex == 1
                      ? _buildIncomeVsExpensesChart()
                      : _buildSavingsGoalChart(themeProvider),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLineChart() {
    // Haftalık ya da aylık harcama trendini oluştur
    final spots = <FlSpot>[];

    if (_selectedPeriod == 0) { // Hafta
      // Haftanın her günü için verileri topla
      final now = DateTime.now();
      for (int i = 6; i >= 0; i--) {
        final day = now.subtract(Duration(days: i));
        final dayExpenses = _expenses.where((expense) =>
          expense.date.year == day.year &&
          expense.date.month == day.month &&
          expense.date.day == day.day);

        double total = dayExpenses.fold(0, (sum, expense) => sum + expense.amount);
        spots.add(FlSpot(6 - i.toDouble(), total));
      }
    } else { // Ay veya Yıl
      // Son 7 günlük veri
      final now = DateTime.now();
      for (int i = 6; i >= 0; i--) {
        final day = now.subtract(Duration(days: i));
        final dayExpenses = _expenses.where((expense) =>
          expense.date.year == day.year &&
          expense.date.month == day.month &&
          expense.date.day == day.day);

        double total = dayExpenses.fold(0, (sum, expense) => sum + expense.amount);
        spots.add(FlSpot(6 - i.toDouble(), total));
      }
    }

    // Boş grafik göstermeyi önlemek için
    if (spots.isEmpty) {
      spots.add(const FlSpot(0, 0));
      spots.add(const FlSpot(6, 0));
    }

    return SizedBox(
      height: 200,
      child: LineChart(
        LineChartData(
          gridData: const FlGridData(show: false),
          titlesData: const FlTitlesData(show: false),
          borderData: FlBorderData(show: false),
          lineBarsData: [
            LineChartBarData(
              spots: spots,
              isCurved: true,
              gradient: const LinearGradient(
                colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
              ),
              barWidth: 3,
              dotData: FlDotData(
                show: true,
                getDotPainter: (spot, percent, barData, index) =>
                    FlDotCirclePainter(
                  radius: 4,
                  color: Colors.white,
                  strokeColor: const Color(0xFF8B5CF6),
                  strokeWidth: 2,
                ),
              ),
              belowBarData: BarAreaData(
                show: true,
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFF6366F1).withOpacity(0.3),
                    const Color(0xFF8B5CF6).withOpacity(0.1),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ],
          lineTouchData: LineTouchData(
            touchTooltipData: LineTouchTooltipData(
              tooltipBgColor: const Color(0xFF6366F1),
              getTooltipItems: (touchedSpots) {
                return touchedSpots.map((touchedSpot) {
                  return LineTooltipItem(
                    '\$${touchedSpot.y.toStringAsFixed(2)}',
                    const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  );
                }).toList();
              },
            ),
            handleBuiltInTouches: true,
          ),
        ),
      ),
    );
  }

  // IncomeVsExpensesChart için gerçek aile geliri kullanımı
  Widget _buildIncomeVsExpensesChart() {
    // Gerçek aile geliri (her ay aynı olduğunu varsayıyoruz)
    final familyIncome = _family?.familyIncome ?? 0;
    final simulatedIncome = List.generate(6, (index) => familyIncome.toDouble());

    // Son 6 ayın harcamaları
    final now = DateTime.now();
    final months = <int>[];
    final expenses = <double>[];

    for (int i = 5; i >= 0; i--) {
      final monthIndex = now.month - i;
      final year = now.year + (monthIndex <= 0 ? -1 : 0);
      final month = monthIndex <= 0 ? monthIndex + 12 : monthIndex;

      months.add(month);

      if (_monthlyTotals.containsKey(month)) {
        expenses.add(_monthlyTotals[month]!);
      } else {
        expenses.add(0);
      }
    }

    return SizedBox(
      height: 200,
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: familyIncome * 1.2, // Maksimum Y değerini gelire göre ayarla
          titlesData: FlTitlesData(
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  const monthNames = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
                  if (value.toInt() < months.length) {
                    final monthIndex = months[value.toInt()] - 1;
                    return Text(
                      monthNames[monthIndex],
                      style: const TextStyle(
                        color: Color(0xFF6B7280),
                        fontSize: 10,
                      ),
                    );
                  }
                  return const Text('');
                },
              ),
            ),
            leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          gridData: const FlGridData(show: false),
          borderData: FlBorderData(show: false),
          barGroups: months.asMap().entries.map((entry) {
            return BarChartGroupData(
              x: entry.key,
              barRods: [
                BarChartRodData(
                  toY: simulatedIncome[entry.key],
                  color: const Color(0xFF10B981),
                  width: 12,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(3)),
                ),
                BarChartRodData(
                  toY: expenses[entry.key],
                  color: const Color(0xFF6366F1),
                  width: 12,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(3)),
                ),
              ],
            );
          }).toList(),
          barTouchData: BarTouchData(
            touchTooltipData: BarTouchTooltipData(
              tooltipBgColor: const Color(0xFF6366F1),
              getTooltipItem: (group, groupIndex, rod, rodIndex) {
                return BarTooltipItem(
                  rodIndex == 0 ? 'Income: \$${rod.toY.toStringAsFixed(0)}' : 'Expense: \$${rod.toY.toStringAsFixed(0)}',
                  const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSavingsGoalChart(ThemeProvider themeProvider) {
    const goalAmount = 10000.0;
    const currentAmount = 4500.0;
    const progress = currentAmount / goalAmount;

    return Column(
      children: [
        SizedBox(
          height: 160,
          width: 160,
          child: Stack(
            children: [
              const Center(
                child: SizedBox(
                  height: 160,
                  width: 160,
                  child: CircularProgressIndicator(
                    value: progress,
                    strokeWidth: 12,
                    backgroundColor: Color(0xFFE5E7EB),
                    valueColor:
                        AlwaysStoppedAnimation<Color>(Color(0xFF10B981)),
                  ),
                ),
              ),
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '${(progress * 100).toInt()}%',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: themeProvider.primaryTextColor,
                      ),
                    ),
                    Text(
                      '\$${currentAmount.toStringAsFixed(0)}',
                      style: TextStyle(
                        fontSize: 14,
                        color: themeProvider.secondaryTextColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              AppLocalizations.of(context)!.goal,
              style: TextStyle(
                fontSize: 14,
                color: themeProvider.secondaryTextColor,
              ),
            ),
            const SizedBox(width: 4),
            Text(
              '\$${goalAmount.toStringAsFixed(0)}',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: themeProvider.primaryTextColor,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCategoryBreakdown(
      AppLocalizations l10n, ThemeProvider themeProvider) {
    if (_categoryTotals.isEmpty) {
      return const SizedBox.shrink();
    }

    final currencySymbol = l10n.currencySymbol ?? '₺';

    // Top 5 kategoriyi seç
    final sortedCategories = _categoryTotals.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    final topCategories = sortedCategories.take(5).toList();

    // Renk ve çeviri eşleştirme
    final categoryColors = {
      'Yemek ve Restoran': const Color(0xFF10B981),
      'Ulaşım': const Color(0xFF3B82F6),
      'Alışveriş': const Color(0xFFF59E0B),
      'Eğlence': const Color(0xFFEF4444),
      'Faturalar ve Hizmetler': const Color(0xFF8B5CF6),
      'Sağlık': const Color(0xFFEC4899),
      'Eğitim': const Color(0xFF6366F1),
    };

    // Kategorinin toplam yüzdesini hesapla
    final totalAmount = topCategories.fold(0.0, (sum, item) => sum + item.value);

    final categoryData = topCategories.map((entry) {
      final percentage = totalAmount > 0 ? (entry.value / totalAmount) * 100 : 0;
      return {
        'name': entry.key,
        'amount': entry.value,
        'percentage': percentage,
        'color': categoryColors[entry.key] ?? const Color(0xFF6B7280),
      };
    }).toList();

    return FadeInUp(
      delay: const Duration(milliseconds: 600),
      child: Container(
        margin: const EdgeInsets.all(24),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: themeProvider.cardColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: themeProvider.cardShadow,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  l10n.categoryBreakdown,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1F2937),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ExpenseListScreen()),
                    );
                  },
                  child: Text(l10n.viewAll),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 120,
                  height: 120,
                  child: PieChart(
                    PieChartData(
                      sectionsSpace: 2,
                      centerSpaceRadius: 30,
                      sections: categoryData.map((category) {
                        return PieChartSectionData(
                          color: category['color'] as Color,
                          value: category['percentage'] as double,
                          radius: 25,
                          showTitle: false,
                        );
                      }).toList(),
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    children: categoryData.map((category) {
                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: Row(
                          children: [
                            Container(
                              width: 12,
                              height: 12,
                              decoration: BoxDecoration(
                                color: category['color'] as Color,
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                category['name'] as String,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF6B7280),
                                ),
                              ),
                            ),
                            Text(
                              '$currencySymbol${(category['amount'] as double).toStringAsFixed(0)}',
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF1F2937),
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMonthlyComparison(
      AppLocalizations l10n, ThemeProvider themeProvider) {
    // Son 6 ayın verilerini hazırla
    final now = DateTime.now();
    final months = <String>[];
    final amounts = <double>[];

    for (int i = 5; i >= 0; i--) {
      final monthIndex = now.month - i;
      final year = now.year + (monthIndex <= 0 ? -1 : 0);
      final month = monthIndex <= 0 ? monthIndex + 12 : monthIndex;

      const monthNames = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
      months.add(monthNames[month - 1]);

      if (_monthlyTotals.containsKey(month)) {
        amounts.add(_monthlyTotals[month]!);
      } else {
        amounts.add(0);
      }
    }

    return FadeInUp(
      delay: const Duration(milliseconds: 800),
      child: Container(
        margin: const EdgeInsets.only(left: 24, right: 24, bottom: 24),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: themeProvider.cardColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: themeProvider.cardShadow,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.monthlyComparison,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1F2937),
              ),
            ),
            const SizedBox(height: 20),
            Container(
              height: 150,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: amounts.isEmpty ? 3000 : amounts.reduce((a, b) => a > b ? a : b) * 1.2,
                  barTouchData: BarTouchData(enabled: false),
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          if (value.toInt() < months.length) {
                            return Text(
                              months[value.toInt()],
                              style: const TextStyle(
                                color: Color(0xFF6B7280),
                                fontSize: 12,
                              ),
                            );
                          }
                          return const Text('');
                        },
                      ),
                    ),
                    leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  ),
                  gridData: const FlGridData(show: false),
                  borderData: FlBorderData(show: false),
                  barGroups: amounts.asMap().entries.map((entry) {
                    return BarChartGroupData(
                      x: entry.key,
                      barRods: [
                        BarChartRodData(
                          toY: entry.value,
                          gradient: const LinearGradient(
                            colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                          ),
                          width: 24,
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentTransactions(
      AppLocalizations l10n, ThemeProvider themeProvider) {
    // Son 3 işlemi al
    final recentTransactions = _expenses
      ..sort((a, b) => b.date.compareTo(a.date));

    final currencySymbol = l10n.currencySymbol ?? '₺';

    final transactions = recentTransactions.take(3).map((expense) {
      final now = DateTime.now();
      final difference = now.difference(expense.date);

      String formattedDate;
      if (difference.inDays == 0) {
        formattedDate = l10n.today;
      } else if (difference.inDays == 1) {
        formattedDate = l10n.yesterday;
      } else {
        formattedDate = '${difference.inDays} ${l10n.daysAgo}';
      }

      IconData icon;
      Color color;

      switch (expense.category.toLowerCase()) {
        case 'yemek ve restoran':
          icon = Icons.restaurant;
          color = const Color(0xFFF59E0B);
          break;
        case 'ulaşım':
          icon = Icons.directions_car;
          color = const Color(0xFF3B82F6);
          break;
        case 'alışveriş':
          icon = Icons.shopping_bag;
          color = const Color(0xFFF59E0B);
          break;
        case 'faturalar ve hizmetler':
          icon = Icons.receipt_long;
          color = const Color(0xFF8B5CF6);
          break;
        default:
          icon = Icons.attach_money;
          color = const Color(0xFF6B7280);
      }

      return {
        'name': expense.name,
        'amount': -expense.amount, // Eksi olarak göster (harcama)
        'date': formattedDate,
        'icon': icon,
        'color': color,
      };
    }).toList();

    return FadeInUp(
      delay: const Duration(milliseconds: 900),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: themeProvider.cardColor,
          borderRadius: BorderRadius.circular(16),
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
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ExpenseListScreen()),
                    );
                  },
                  child: Text(l10n.viewAll),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (transactions.isEmpty)
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    l10n.noRecentTransactions ?? 'No recent transactions',
                    style: TextStyle(color: themeProvider.secondaryTextColor),
                  ),
                ),
              )
            else
              ...transactions.map((tx) => Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: (tx['color'] as Color?)?.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(
                            tx['icon'] as IconData,
                            color: tx['color'] as Color,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                tx['name'] as String,
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: themeProvider.primaryTextColor,
                                ),
                              ),
                              Text(
                                tx['date'] as String,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: themeProvider.secondaryTextColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          (tx['amount'] as double) > 0
                              ? '+$currencySymbol${((tx['amount'] ?? 0) as num).toStringAsFixed(2)}'
                              : '-$currencySymbol${(-((tx['amount'] ?? 0) as double)).toStringAsFixed(2)}',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            color: (tx['amount'] as double) > 0
                                ? const Color(0xFF10B981)
                                : const Color(0xFFEF4444),
                          ),
                        ),
                      ],
                    ),
                  )).toList(),
          ],
        ),
      ),
    );
  }
}
