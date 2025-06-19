import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import 'add_expense_screen.dart';
import 'expense_list_screen.dart';
import 'family_profile_edit_screen.dart';
import 'package:home_management/l10n/app_localizations.dart';

class FamilyDashboardScreen extends StatefulWidget {
  @override
  _FamilyDashboardScreenState createState() => _FamilyDashboardScreenState();
}

class _FamilyDashboardScreenState extends State<FamilyDashboardScreen> {
  int _selectedIndex = 0;
  int _selectedTimeframe = 0; // 0: Week, 1: Month, 2: Year

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return Scaffold(
          backgroundColor: themeProvider.backgroundColor,
          body: SafeArea(
            child: CustomScrollView(
              slivers: [
                _buildHeader(l10n, themeProvider),
                SliverPadding(
                  padding: const EdgeInsets.all(20),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      _buildFinancialSummary(l10n, themeProvider),
                      const SizedBox(height: 24),
                      _buildTimeframSelector(l10n, themeProvider),
                      const SizedBox(height: 24),
                      _buildBudgetAnalysis(l10n, themeProvider),
                      const SizedBox(height: 24),
                      _buildCategoryBreakdown(l10n, themeProvider),
                      const SizedBox(height: 24),
                      _buildFamilyInsights(l10n, themeProvider),
                      const SizedBox(height: 24),
                      _buildQuickActions(context, l10n, themeProvider),
                      const SizedBox(height: 100),
                    ]),
                  ),
                ),
              ],
            ),
          ),
          bottomNavigationBar: _buildBottomNavBar(l10n, themeProvider),
        );
      },
    );
  }

  Widget _buildHeader(AppLocalizations l10n, ThemeProvider themeProvider) {
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
                        'Family Finance',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Smith Family',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
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
                    child: Icon(Icons.family_restroom, color: Colors.white, size: 24),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.white.withOpacity(0.2)),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.people_outline, color: Colors.white, size: 20),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '4 Members',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                'Active this month',
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.white.withOpacity(0.2)),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.calendar_today_outlined, color: Colors.white, size: 20),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'December',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                '15 days left',
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFinancialSummary(AppLocalizations l10n, ThemeProvider themeProvider) {
    return FadeInUp(
      delay: const Duration(milliseconds: 200),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: themeProvider.cardColor,
          borderRadius: BorderRadius.circular(24),
          boxShadow: themeProvider.elevatedShadow,
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Financial Summary',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: themeProvider.primaryTextColor,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: themeProvider.successColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.trending_up, size: 14, color: themeProvider.successColor),
                      const SizedBox(width: 4),
                      Text(
                        'Healthy',
                        style: TextStyle(
                          color: themeProvider.successColor,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: _buildSummaryCard(
                    'Monthly Income',
                    '\$5,400',
                    Icons.arrow_upward,
                    themeProvider.successColor,
                    '+8.2%',
                    true,
                    themeProvider,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildSummaryCard(
                    'Total Expenses',
                    '\$3,247',
                    Icons.arrow_downward,
                    themeProvider.errorColor,
                    '+12.5%',
                    false,
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
                    themeProvider.primaryColor.withOpacity(0.1),
                    themeProvider.primaryVariant.withOpacity(0.05),
                  ],
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: themeProvider.primaryColor.withOpacity(0.2)),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Available Budget',
                        style: TextStyle(
                          color: themeProvider.secondaryTextColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Icon(Icons.visibility_outlined, color: themeProvider.primaryColor, size: 20),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '\$2,153',
                        style: TextStyle(
                          color: themeProvider.primaryTextColor,
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: themeProvider.successColor.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '60% remaining',
                          style: TextStyle(
                            color: themeProvider.successColor,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  LinearProgressIndicator(
                    value: 0.4,
                    backgroundColor: themeProvider.borderColor,
                    valueColor: AlwaysStoppedAnimation<Color>(themeProvider.primaryColor),
                    minHeight: 8,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Spent: \$3,247',
                        style: TextStyle(
                          color: themeProvider.secondaryTextColor,
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        'Budget: \$5,400',
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

  Widget _buildSummaryCard(String title, String amount, IconData icon, Color color, String change, bool isPositive, ThemeProvider themeProvider) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, color: color, size: 20),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
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
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeframSelector(AppLocalizations l10n, ThemeProvider themeProvider) {
    final timeframes = ['Week', 'Month', 'Year'];
    
    return FadeInUp(
      delay: const Duration(milliseconds: 300),
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: themeProvider.cardColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: themeProvider.cardShadow,
        ),
        child: Row(
          children: timeframes.asMap().entries.map((entry) {
            final index = entry.key;
            final timeframe = entry.value;
            final isSelected = _selectedTimeframe == index;
            
            return Expanded(
              child: GestureDetector(
                onTap: () => setState(() => _selectedTimeframe = index),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: isSelected ? themeProvider.primaryColor : Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    timeframe,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: isSelected ? Colors.white : themeProvider.secondaryTextColor,
                      fontSize: 14,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
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

  Widget _buildBudgetAnalysis(AppLocalizations l10n, ThemeProvider themeProvider) {
    return FadeInUp(
      delay: const Duration(milliseconds: 400),
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
            Text(
              'Budget Analysis',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: themeProvider.primaryTextColor,
              ),
            ),
            const SizedBox(height: 20),
            Container(
              height: 200,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    horizontalInterval: 1000,
                    getDrawingHorizontalLine: (value) {
                      return FlLine(
                        color: themeProvider.borderColor,
                        strokeWidth: 1,
                      );
                    },
                  ),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
                          if (value.toInt() < days.length) {
                            return Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Text(
                                days[value.toInt()],
                                style: TextStyle(
                                  color: themeProvider.secondaryTextColor,
                                  fontSize: 12,
                                ),
                              ),
                            );
                          }
                          return const Text('');
                        },
                      ),
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  lineBarsData: [
                    LineChartBarData(
                      spots: [
                        const FlSpot(0, 1000),
                        const FlSpot(1, 1500),
                        const FlSpot(2, 1200),
                        const FlSpot(3, 1800),
                        const FlSpot(4, 1400),
                        const FlSpot(5, 2200),
                        const FlSpot(6, 1900),
                      ],
                      isCurved: true,
                      gradient: LinearGradient(
                        colors: [themeProvider.primaryColor, themeProvider.primaryVariant],
                      ),
                      barWidth: 3,
                      dotData: FlDotData(
                        show: true,
                        getDotPainter: (spot, percent, barData, index) {
                          return FlDotCirclePainter(
                            radius: 4,
                            color: themeProvider.primaryColor,
                            strokeWidth: 2,
                            strokeColor: Colors.white,
                          );
                        },
                      ),
                      belowBarData: BarAreaData(
                        show: true,
                        gradient: LinearGradient(
                          colors: [
                            themeProvider.primaryColor.withOpacity(0.3),
                            themeProvider.primaryColor.withOpacity(0.05),
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryBreakdown(AppLocalizations l10n, ThemeProvider themeProvider) {
    final categories = [
      {'name': 'Food & Dining', 'amount': 1120, 'percentage': 35, 'color': themeProvider.successColor, 'icon': Icons.restaurant},
      {'name': 'Transportation', 'amount': 800, 'percentage': 25, 'color': themeProvider.infoColor, 'icon': Icons.directions_car},
      {'name': 'Shopping', 'amount': 640, 'percentage': 20, 'color': themeProvider.warningColor, 'icon': Icons.shopping_bag},
      {'name': 'Utilities', 'amount': 687, 'percentage': 20, 'color': themeProvider.errorColor, 'icon': Icons.flash_on},
    ];

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
                  'Category Breakdown',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: themeProvider.primaryTextColor,
                  ),
                ),
                GestureDetector(
                  onTap: () {},
                  child: Text(
                    'View Details',
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
            ...categories.map((category) => _buildCategoryItem(category, themeProvider)).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryItem(Map<String, dynamic> category, ThemeProvider themeProvider) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: (category['color'] as Color).withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: (category['color'] as Color).withOpacity(0.1)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: category['color'],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              category['icon'] as IconData,
              color: Colors.white,
              size: 16,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  category['name'] as String,
                  style: TextStyle(
                    color: themeProvider.primaryTextColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Expanded(
                      child: LinearProgressIndicator(
                        value: (category['percentage'] as int) / 100,
                        backgroundColor: themeProvider.borderColor,
                        valueColor: AlwaysStoppedAnimation<Color>(category['color']),
                        minHeight: 6,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      '${category['percentage']}%',
                      style: TextStyle(
                        color: themeProvider.secondaryTextColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Text(
            '\$${category['amount']}',
            style: TextStyle(
              color: themeProvider.primaryTextColor,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFamilyInsights(AppLocalizations l10n, ThemeProvider themeProvider) {
    return FadeInUp(
      delay: const Duration(milliseconds: 600),
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
            Text(
              'Family Insights',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: themeProvider.primaryTextColor,
              ),
            ),
            const SizedBox(height: 20),
            _buildInsightItem(
              'Top Spender',
              'John Smith',
              '\$1,247 this month',
              Icons.person,
              themeProvider.primaryColor,
              themeProvider,
            ),
            const SizedBox(height: 16),
            _buildInsightItem(
              'Most Used Category',
              'Food & Dining',
              '35% of total expenses',
              Icons.restaurant,
              themeProvider.successColor,
              themeProvider,
            ),
            const SizedBox(height: 16),
            _buildInsightItem(
              'Savings Rate',
              '40% of Income',
              'Above family average',
              Icons.savings,
              themeProvider.warningColor,
              themeProvider,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInsightItem(String title, String value, String subtitle, IconData icon, Color color, ThemeProvider themeProvider) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: themeProvider.secondaryTextColor,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: TextStyle(
                  color: themeProvider.primaryTextColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                subtitle,
                style: TextStyle(
                  color: themeProvider.secondaryTextColor,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildQuickActions(BuildContext context, AppLocalizations l10n, ThemeProvider themeProvider) {
    return FadeInUp(
      delay: const Duration(milliseconds: 700),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Quick Actions',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: themeProvider.primaryTextColor,
            ),
          ),
          const SizedBox(height: 16),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1.5,
            children: [
              _buildActionButton(
                'Add Expense',
                Icons.add_circle_outline,
                themeProvider.primaryColor,
                () => Navigator.push(context, MaterialPageRoute(builder: (context) => AddExpenseScreen())),
                themeProvider,
              ),
              _buildActionButton(
                'View All Expenses',
                Icons.receipt_long_outlined,
                themeProvider.successColor,
                () => Navigator.push(context, MaterialPageRoute(builder: (context) => ExpenseListScreen())),
                themeProvider,
              ),
              _buildActionButton(
                'Edit Profile',
                Icons.edit_outlined,
                themeProvider.warningColor,
                () => Navigator.push(context, MaterialPageRoute(builder: (context) => FamilyProfileEditScreen())),
                themeProvider,
              ),
              _buildActionButton(
                'Generate Report',
                Icons.analytics_outlined,
                themeProvider.infoColor,
                () {},
                themeProvider,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(String title, IconData icon, Color color, VoidCallback onTap, ThemeProvider themeProvider) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color.withOpacity(0.2)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 12),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: themeProvider.primaryTextColor,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNavBar(AppLocalizations l10n, ThemeProvider themeProvider) {
    return Container(
      decoration: BoxDecoration(
        color: themeProvider.surfaceColor,
        boxShadow: themeProvider.elevatedShadow,
      ),
      child: SafeArea(
        child: Container(
          height: 70,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(Icons.dashboard_outlined, Icons.dashboard, l10n.dashboard, 0, themeProvider),
              _buildNavItem(Icons.receipt_long_outlined, Icons.receipt_long, l10n.expenses, 1, themeProvider),
              _buildNavItem(Icons.analytics_outlined, Icons.analytics, l10n.analytics, 2, themeProvider),
              _buildNavItem(Icons.person_outline, Icons.person, l10n.editProfile, 3, themeProvider),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData outlinedIcon, IconData filledIcon, String label, int index, ThemeProvider themeProvider) {
    final isSelected = _selectedIndex == index;
    
    return GestureDetector(
      onTap: () => setState(() => _selectedIndex = index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? themeProvider.primaryColor.withOpacity(0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isSelected ? filledIcon : outlinedIcon,
              color: isSelected ? themeProvider.primaryColor : themeProvider.iconColor,
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? themeProvider.primaryColor : themeProvider.secondaryTextColor,
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}