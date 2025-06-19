import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import 'package:home_management/l10n/app_localizations.dart';
import 'settings_screen.dart';
import 'expense_list_screen.dart';
import 'add_expense_screen.dart';

class ExpenseDashboardScreen extends StatefulWidget {
  const ExpenseDashboardScreen({super.key});

  @override
  _ExpenseDashboardScreenState createState() => _ExpenseDashboardScreenState();
}

class _ExpenseDashboardScreenState extends State<ExpenseDashboardScreen> {
  int _selectedPeriod = 0;
  final List<String> _periods = ['Week', 'Month', 'Year'];
  int _selectedChartIndex = 0;

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
              IconButton(
                onPressed: _showDateRangePicker,
                icon:
                    Icon(Icons.calendar_today, color: themeProvider.iconColor),
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
          body: RefreshIndicator(
            onRefresh: () async {
              // TODO: Implement refresh logic
              await Future.delayed(const Duration(seconds: 1));
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                children: [
                  _buildPeriodSelector(themeProvider),
                  _buildTotalSpendingCard(l10n),
                  _buildBudgetProgressCard(l10n, themeProvider),
                  _buildChartSection(l10n, themeProvider),
                  _buildCategoryBreakdown(l10n, themeProvider),
                  _buildMonthlyComparison(l10n, themeProvider),
                  _buildRecentTransactions(l10n, themeProvider),
                  const SizedBox(height: 20), // Bottom padding
                ],
              ),
            ),
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AddExpenseScreen()),
            ),
            backgroundColor: themeProvider.primaryColor,
            icon: const Icon(Icons.add, color: Colors.white),
            label: Text(l10n.addExpense,
                style: const TextStyle(color: Colors.white)),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
        );
      },
    );
  }

  void _showDateRangePicker() async {
    final initialDateRange = DateTimeRange(
      start: DateTime.now().subtract(const Duration(days: 30)),
      end: DateTime.now(),
    );

    final pickedDateRange = await showDateRangePicker(
      context: context,
      initialDateRange: initialDateRange,
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
      // TODO: Implement date range filtering
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              '${AppLocalizations.of(context)!.dateRangeSelected}: ${pickedDateRange.start.toString().substring(0, 10)} - ${pickedDateRange.end.toString().substring(0, 10)}'),
          duration: const Duration(seconds: 2),
        ),
      );
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
        child: Row(
          children: localizedPeriods.map((period) {
            final index = localizedPeriods.indexOf(period);
            final isSelected = _selectedPeriod == index;

            return Expanded(
              child: GestureDetector(
                onTap: () => setState(() => _selectedPeriod = index),
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
      ),
    );
  }

  Widget _buildTotalSpendingCard(AppLocalizations l10n) {
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
                    const Text(
                      '\$2,847.65',
                      style: TextStyle(
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
                  child: const Icon(
                    Icons.trending_up,
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
                    l10n.vsLastMonth, '+12.5%', const Color(0xFF10B981)),
                const SizedBox(width: 24),
                _buildSpendingMetric(
                    l10n.averageDaily, '\$94.92', Colors.white70),
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
    const double monthlyBudget = 3000.0;
    const double spent = 2847.65;
    const double remaining = monthlyBudget - spent;
    const double progressPercentage = spent / monthlyBudget;

    return FadeInUp(
      delay: const Duration(milliseconds: 300),
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
                  l10n.monthlyBudget,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: themeProvider.primaryTextColor,
                  ),
                ),
                Text(
                  '\$${monthlyBudget.toStringAsFixed(0)}',
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
              child: const LinearProgressIndicator(
                value: progressPercentage,
                minHeight: 12,
                backgroundColor: Color(0xFFE5E7EB),
                valueColor: AlwaysStoppedAnimation<Color>(
                    progressPercentage > 0.9
                        ? Color(0xFFEF4444)
                        : Color(0xFF10B981)),
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
                      l10n.rent,
                      style: TextStyle(
                        fontSize: 12,
                        color: themeProvider.secondaryTextColor,
                      ),
                    ),
                    Text(
                      '\$${spent.toStringAsFixed(2)}',
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
                      l10n.remaining,
                      style: TextStyle(
                        fontSize: 12,
                        color: themeProvider.secondaryTextColor,
                      ),
                    ),
                    Text(
                      '\$${remaining.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF10B981),
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
    return SizedBox(
      height: 200,
      child: LineChart(
        LineChartData(
          gridData: const FlGridData(show: false),
          titlesData: const FlTitlesData(show: false),
          borderData: FlBorderData(show: false),
          lineBarsData: [
            LineChartBarData(
              spots: [
                const FlSpot(0, 3),
                const FlSpot(1, 1),
                const FlSpot(2, 4),
                const FlSpot(3, 2),
                const FlSpot(4, 5),
                const FlSpot(5, 3),
                const FlSpot(6, 4),
              ],
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
                    '\$${(touchedSpot.y * 500).toStringAsFixed(2)}',
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

  Widget _buildIncomeVsExpensesChart() {
    return SizedBox(
      height: 200,
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: 5000,
          titlesData: FlTitlesData(
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  const titles = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun'];
                  if (value.toInt() < titles.length) {
                    return Text(
                      titles[value.toInt()],
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
            leftTitles:
                const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles:
                const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles:
                const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          gridData: const FlGridData(show: false),
          borderData: FlBorderData(show: false),
          barGroups: [0, 1, 2, 3, 4, 5].map((i) {
            return BarChartGroupData(
              x: i,
              barRods: [
                BarChartRodData(
                  toY: [3200, 3500, 2800, 3800, 3100, 4200][i].toDouble(),
                  color: const Color(0xFF10B981),
                  width: 12,
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(3)),
                ),
                BarChartRodData(
                  toY: [2100, 2350, 1890, 2680, 2400, 2847][i].toDouble(),
                  color: const Color(0xFF6366F1),
                  width: 12,
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(3)),
                ),
              ],
            );
          }).toList(),
          barTouchData: BarTouchData(
            touchTooltipData: BarTouchTooltipData(
              tooltipBgColor: const Color(0xFF6366F1),
              getTooltipItem: (group, groupIndex, rod, rodIndex) {
                return BarTooltipItem(
                  '\$${rod.toY.toString()}',
                  const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
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
    final categories = [
      {
        'name': l10n.foodDining,
        'amount': 842.30,
        'percentage': 29.6,
        'color': const Color(0xFF10B981)
      },
      {
        'name': l10n.transportation,
        'amount': 456.20,
        'percentage': 16.0,
        'color': const Color(0xFF3B82F6)
      },
      {
        'name': l10n.shopping,
        'amount': 623.45,
        'percentage': 21.9,
        'color': const Color(0xFFF59E0B)
      },
      {
        'name': l10n.entertainment,
        'amount': 289.70,
        'percentage': 10.2,
        'color': const Color(0xFFEF4444)
      },
      {
        'name': l10n.billsUtilities,
        'amount': 636.00,
        'percentage': 22.3,
        'color': const Color(0xFF8B5CF6)
      },
    ];

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
                  onPressed: () {},
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
                      sections: categories.map((category) {
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
                    children: categories.map((category) {
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
                              '\$${(category['amount'] as double).toStringAsFixed(0)}',
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
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun'];
    final amounts = [2100, 2350, 1890, 2680, 2400, 2847];

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
                  maxY: 3000,
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
                    leftTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false)),
                    topTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false)),
                    rightTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false)),
                  ),
                  gridData: const FlGridData(show: false),
                  borderData: FlBorderData(show: false),
                  barGroups: amounts.asMap().entries.map((entry) {
                    return BarChartGroupData(
                      x: entry.key,
                      barRods: [
                        BarChartRodData(
                          toY: entry.value.toDouble(),
                          gradient: const LinearGradient(
                            colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                          ),
                          width: 24,
                          borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(4)),
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
    final transactions = [
      {
        'name': l10n.groceryShopping,
        'amount': -89.30,
        'date': l10n.yesterday,
        'icon': Icons.shopping_bag,
        'color': const Color(0xFFF59E0B),
      },
      {
        'name': l10n.salaryDeposit,
        'amount': 2750.00,
        'date': '3 ${l10n.daysAgo}',
        'icon': Icons.account_balance_wallet,
        'color': const Color(0xFF10B981),
      },
      {
        'name': l10n.electricityBill,
        'amount': -125.00,
        'date': '5 ${l10n.daysAgo}',
        'icon': Icons.receipt_long,
        'color': const Color(0xFF8B5CF6),
      },
    ];

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
                      MaterialPageRoute(
                          builder: (context) => ExpenseListScreen()),
                    );
                  },
                  child: Text(l10n.viewAll),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...transactions
                .map((tx) => Container(
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
                                ? '+\$${((tx['amount'] ?? 0) as num).toStringAsFixed(2)}'
                                : '-\$${(-((tx['amount'] ?? 0) as double)).toStringAsFixed(2)}',
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
                    ))
                .toList(),
          ],
        ),
      ),
    );
  }
}
