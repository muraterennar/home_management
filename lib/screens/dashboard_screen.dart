import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:home_management/screens/create_family_profile_screen.dart';
import 'package:home_management/screens/family_profile_edit_screen.dart';
import 'package:provider/provider.dart';
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

class DashboardHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return SafeArea(
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
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context, AppLocalizations l10n,
      ThemeProvider themeProvider) {
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
                  Row(
                    children: [
                      _buildHeaderAction(Icons.notifications_outlined, () {}),
                      const SizedBox(width: 12),
                      _buildHeaderAction(Icons.person_outline, () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              // builder: (context) =>
                              //     CreateFamilyProfileScreen()),

                              builder: (context) =>
                                  FamilyProfileEditScreen()),
                        );
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
                child: const Row(
                  children: [
                    Icon(Icons.calendar_today_outlined,
                        color: Colors.white, size: 20),
                    SizedBox(width: 12),
                    Text(
                      'December 2024',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Spacer(),
                    Text(
                      '15 days left',
                      style: TextStyle(
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
                Text(
                  'Budget Overview',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: themeProvider.primaryTextColor,
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: themeProvider.successColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'On Track',
                    style: TextStyle(
                      color: themeProvider.successColor,
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
                    'Total Income',
                    '\$5,400',
                    Icons.trending_up,
                    themeProvider.successColor,
                    '+8.2%',
                    themeProvider,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildBudgetItem(
                    'Total Expenses',
                    '\$3,247',
                    Icons.trending_down,
                    themeProvider.errorColor,
                    '+12.5%',
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
                      color: themeProvider.successColor,
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
                          'Remaining Balance',
                          style: TextStyle(
                            color: themeProvider.secondaryTextColor,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '\$2,153',
                          style: TextStyle(
                            color: themeProvider.primaryTextColor,
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
                        '60%',
                        style: TextStyle(
                          color: themeProvider.successColor,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'of income',
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
                  'Monthly Progress',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: themeProvider.primaryTextColor,
                  ),
                ),
                Text(
                  '15 days left',
                  style: TextStyle(
                    color: themeProvider.secondaryTextColor,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            LinearProgressIndicator(
              value: 0.6,
              backgroundColor: themeProvider.borderColor,
              valueColor:
                  AlwaysStoppedAnimation<Color>(themeProvider.primaryColor),
              minHeight: 8,
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildProgressItem('Days Passed', '15', themeProvider),
                _buildProgressItem('Budget Used', '60%', themeProvider),
                _buildProgressItem('Avg. Daily', '\$216', themeProvider),
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
            'Quick Actions',
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
                  'Add Expense',
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
                  'View Analytics',
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
                  'All Expenses',
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
    final transactions = [
      {
        'title': 'Grocery Shopping',
        'amount': '-\$89.30',
        'category': 'Shopping',
        'time': '2 hours ago',
        'icon': Icons.shopping_bag,
        'color': themeProvider.warningColor
      },
      {
        'title': 'Monthly Salary',
        'amount': '+\$2,700',
        'category': 'Income',
        'time': '1 day ago',
        'icon': Icons.account_balance_wallet,
        'color': themeProvider.successColor
      },
      {
        'title': 'Restaurant Dinner',
        'amount': '-\$45.50',
        'category': 'Food',
        'time': '2 days ago',
        'icon': Icons.restaurant,
        'color': themeProvider.errorColor
      },
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
                  'Recent Transactions',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: themeProvider.primaryTextColor,
                  ),
                ),
                GestureDetector(
                  onTap: () {},
                  child: Text(
                    'View All',
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
            ...transactions
                .map((transaction) =>
                    _buildTransactionItem(transaction, themeProvider))
                .toList(),
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
    if (hour < 12) return 'Good Morning!';
    if (hour < 17) return 'Good Afternoon!';
    return 'Good Evening!';
  }
}
