import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import 'add_expense_screen.dart';
import 'package:home_management/l10n/app_localizations.dart';
import 'settings_screen.dart';
import 'expense_dashboard_screen.dart'; // Add this import

class ExpenseListScreen extends StatefulWidget {
  @override
  _ExpenseListScreenState createState() => _ExpenseListScreenState();
}

class _ExpenseListScreenState extends State<ExpenseListScreen> {
  String _selectedFilter = 'All';
  bool _isSearching = false;
  bool _showFilterPanel = false;
  TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  List<String> _selectedCategories = [];
  double _minAmount = 0;
  double _maxAmount = 200;

  final List<String> _filters = ['All', 'Today', 'This Week', 'This Month'];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        // Localized categories
        final List<String> _categories = [
          l10n.foodDining,
          l10n.transportation,
          l10n.shopping,
          l10n.entertainment,
          l10n.billsUtilities,
          l10n.healthcare,
          l10n.education,
          l10n.other
        ];

        final List<Map<String, dynamic>> _expenses = [
          {
            'name': 'Lunch at Italian Restaurant',
            'amount': 45.50,
            'category': l10n.foodDining,
            'date': 'Today, 2:30 PM',
            'icon': Icons.restaurant,
            'color': const Color(0xFF10B981),
            'hasReceipt': true,
          },
          {
            'name': 'Uber Ride to Office',
            'amount': 12.75,
            'category': l10n.transportation,
            'date': 'Today, 9:15 AM',
            'icon': Icons.directions_car,
            'color': const Color(0xFF3B82F6),
            'hasReceipt': false,
          },
          {
            'name': 'Grocery Shopping',
            'amount': 89.30,
            'category': l10n.shopping,
            'date': 'Yesterday, 6:45 PM',
            'icon': Icons.shopping_bag,
            'color': const Color(0xFFF59E0B),
            'hasReceipt': true,
          },
          {
            'name': 'Netflix Subscription',
            'amount': 15.99,
            'category': l10n.entertainment,
            'date': 'Yesterday, 12:00 PM',
            'icon': Icons.movie,
            'color': const Color(0xFFEF4444),
            'hasReceipt': false,
          },
          {
            'name': 'Electricity Bill',
            'amount': 125.00,
            'category': l10n.billsUtilities,
            'date': '2 days ago',
            'icon': Icons.receipt_long,
            'color': const Color(0xFF8B5CF6),
            'hasReceipt': true,
          },
        ];

        return Scaffold(
          backgroundColor: themeProvider.backgroundColor,
          appBar: _buildAppBar(l10n, themeProvider),
          body: Column(
            children: [
              if (_isSearching) _buildSearchBar(l10n, themeProvider),
              if (_showFilterPanel)
                _buildFilterPanel(l10n, _categories, themeProvider),
              if (!_isSearching) _buildFilterTabs(l10n, themeProvider),
              _buildSummaryHeader(l10n, _expenses, themeProvider),
              Expanded(
                  child: _buildExpenseList(l10n, _expenses, themeProvider)),
            ],
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

  PreferredSizeWidget _buildAppBar(
      AppLocalizations l10n, ThemeProvider themeProvider) {
    return AppBar(
      backgroundColor: themeProvider.surfaceColor,
      elevation: 0,
      title: _isSearching
          ? TextField(
              controller: _searchController,
              autofocus: true,
              style: TextStyle(color: themeProvider.primaryTextColor),
              decoration: InputDecoration(
                hintText: l10n.searchExpenses,
                border: InputBorder.none,
                hintStyle: TextStyle(color: themeProvider.hintTextColor),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value.toLowerCase();
                });
              },
            )
          : Text(
              l10n.expenses,
              style: TextStyle(
                color: themeProvider.primaryTextColor,
                fontWeight: FontWeight.bold,
              ),
            ),
      leading: _isSearching
          ? IconButton(
              onPressed: () {
                setState(() {
                  _isSearching = false;
                  _searchController.clear();
                  _searchQuery = '';
                });
              },
              icon: Icon(Icons.arrow_back, color: themeProvider.iconColor),
            )
          : null,
      actions: [
        if (!_isSearching) ...[
          IconButton(
            onPressed: () {
              setState(() {
                _isSearching = true;
              });
            },
            icon: Icon(Icons.search, color: themeProvider.iconColor),
          ),
          IconButton(
            onPressed: () {
              setState(() {
                _showFilterPanel = !_showFilterPanel;
              });
            },
            icon: Icon(
              _showFilterPanel ? Icons.filter_list_off : Icons.filter_list,
              color: _showFilterPanel
                  ? themeProvider.primaryColor
                  : themeProvider.iconColor,
            ),
          ),
          IconButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SettingsScreen()),
            ),
            icon: Icon(Icons.settings, color: themeProvider.iconColor),
          ),
        ] else ...[
          if (_searchController.text.isNotEmpty)
            IconButton(
              onPressed: () {
                setState(() {
                  _searchController.clear();
                  _searchQuery = '';
                });
              },
              icon: Icon(Icons.clear, color: themeProvider.iconColor),
            ),
        ],
      ],
    );
  }

  Widget _buildSearchBar(AppLocalizations l10n, ThemeProvider themeProvider) {
    return FadeInDown(
      child: Container(
        padding: const EdgeInsets.all(16),
        color: Colors.white,
        child: Row(
          children: [
            const Icon(Icons.search, color: Color(0xFF6B7280)),
            const SizedBox(width: 12),
            Text(
              '${l10n.searchingFor} "${_searchController.text}"',
              style: const TextStyle(
                color: Color(0xFF6B7280),
                fontSize: 14,
              ),
            ),
            const Spacer(),
            Text(
              '${_getFilteredExpenses(context).length} ${l10n.results}',
              style: const TextStyle(
                color: Color(0xFF6366F1),
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterPanel(AppLocalizations l10n, List<String> categories,
      ThemeProvider themeProvider) {
    return FadeInDown(
      child: Container(
        padding: const EdgeInsets.all(20),
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  l10n.filterOptions,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1F2937),
                  ),
                ),
                TextButton(
                  onPressed: _clearFilters,
                  child: Text(l10n.clearAll),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              l10n.categories,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF374151),
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: categories.map((category) {
                final isSelected = _selectedCategories.contains(category);
                return FilterChip(
                  label: Text(
                    category,
                    style: TextStyle(
                      fontSize: 12,
                      color:
                          isSelected ? Colors.white : const Color(0xFF6B7280),
                    ),
                  ),
                  selected: isSelected,
                  onSelected: (selected) {
                    setState(() {
                      if (selected) {
                        _selectedCategories.add(category);
                      } else {
                        _selectedCategories.remove(category);
                      }
                    });
                  },
                  backgroundColor: Colors.grey[100],
                  selectedColor: const Color(0xFF6366F1),
                  checkmarkColor: Colors.white,
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            Text(
              '${l10n.amountRange}: \$${_minAmount.toInt()} - \$${_maxAmount.toInt()}',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF374151),
              ),
            ),
            RangeSlider(
              values: RangeValues(_minAmount, _maxAmount),
              min: 0,
              max: 200,
              divisions: 20,
              activeColor: const Color(0xFF6366F1),
              inactiveColor: const Color(0xFFE5E7EB),
              onChanged: (RangeValues values) {
                setState(() {
                  _minAmount = values.start;
                  _maxAmount = values.end;
                });
              },
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${_getFilteredExpenses(context).length} ${l10n.expensesFound}',
                  style: const TextStyle(
                    color: Color(0xFF6B7280),
                    fontSize: 12,
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _showFilterPanel = false;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6366F1),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  ),
                  child: Text(
                    l10n.applyFilters,
                    style: const TextStyle(fontSize: 12),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _clearFilters() {
    setState(() {
      _selectedCategories.clear();
      _minAmount = 0;
      _maxAmount = 200;
      _selectedFilter = 'All';
    });
  }

  List<Map<String, dynamic>> _getFilteredExpenses(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    final List<Map<String, dynamic>> _expenses = [
      {
        'name': 'Lunch at Italian Restaurant',
        'amount': 45.50,
        'category': l10n.foodDining,
        'date': 'Today, 2:30 PM',
        'icon': Icons.restaurant,
        'color': const Color(0xFF10B981),
        'hasReceipt': true,
      },
      {
        'name': 'Uber Ride to Office',
        'amount': 12.75,
        'category': l10n.transportation,
        'date': 'Today, 9:15 AM',
        'icon': Icons.directions_car,
        'color': const Color(0xFF3B82F6),
        'hasReceipt': false,
      },
      {
        'name': 'Grocery Shopping',
        'amount': 89.30,
        'category': l10n.shopping,
        'date': 'Yesterday, 6:45 PM',
        'icon': Icons.shopping_bag,
        'color': const Color(0xFFF59E0B),
        'hasReceipt': true,
      },
      {
        'name': 'Netflix Subscription',
        'amount': 15.99,
        'category': l10n.entertainment,
        'date': 'Yesterday, 12:00 PM',
        'icon': Icons.movie,
        'color': const Color(0xFFEF4444),
        'hasReceipt': false,
      },
      {
        'name': 'Electricity Bill',
        'amount': 125.00,
        'category': l10n.billsUtilities,
        'date': '2 days ago',
        'icon': Icons.receipt_long,
        'color': const Color(0xFF8B5CF6),
        'hasReceipt': true,
      },
    ];

    List<Map<String, dynamic>> filteredExpenses = List.from(_expenses);

    // Search filter
    if (_searchQuery.isNotEmpty) {
      filteredExpenses = filteredExpenses.where((expense) {
        return expense['name']
                .toString()
                .toLowerCase()
                .contains(_searchQuery) ||
            expense['category'].toString().toLowerCase().contains(_searchQuery);
      }).toList();
    }

    // Category filter
    if (_selectedCategories.isNotEmpty) {
      filteredExpenses = filteredExpenses.where((expense) {
        return _selectedCategories.contains(expense['category']);
      }).toList();
    }

    // Amount range filter
    filteredExpenses = filteredExpenses.where((expense) {
      double amount = expense['amount'].toDouble();
      return amount >= _minAmount && amount <= _maxAmount;
    }).toList();

    // Time filter
    if (_selectedFilter != 'All') {
      if (_selectedFilter == 'Today') {
        filteredExpenses = filteredExpenses.where((expense) {
          return expense['date'].toString().contains('Today');
        }).toList();
      }
    }

    return filteredExpenses;
  }

  Widget _buildSummaryHeader(AppLocalizations l10n,
      List<Map<String, dynamic>> expenses, ThemeProvider themeProvider) {
    final filteredExpenses = _getFilteredExpenses(context);
    final totalAmount = filteredExpenses.fold<double>(
        0, (sum, expense) => sum + expense['amount']);

    return FadeInUp(
      delay: const Duration(milliseconds: 200),
      child: Container(
        margin: const EdgeInsets.all(24),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _isSearching || _showFilterPanel
                        ? l10n.filteredTotal
                        : l10n.totalExpenses,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '\$${totalAmount.toStringAsFixed(2)}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${filteredExpenses.length} ${l10n.transactions}',
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                _isSearching ? Icons.search : Icons.trending_up,
                color: Colors.white,
                size: 24,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExpenseList(AppLocalizations l10n,
      List<Map<String, dynamic>> expenses, ThemeProvider themeProvider) {
    final filteredExpenses = _getFilteredExpenses(context);

    if (filteredExpenses.isEmpty) {
      return _buildEmptyState(l10n, themeProvider);
    }

    return FadeInUp(
      delay: const Duration(milliseconds: 400),
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        itemCount: filteredExpenses.length,
        itemBuilder: (context, index) {
          final expense = filteredExpenses[index];

          return Dismissible(
            key: Key(expense['name']),
            background: Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(12),
              ),
              alignment: Alignment.centerRight,
              child: const Icon(Icons.delete, color: Colors.white),
            ),
            direction: DismissDirection.endToStart,
            onDismissed: (direction) {
              // TODO: Implement delete functionality
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${expense['name']} ${l10n.removed}'),
                  action: SnackBarAction(
                    label: l10n.usd,
                    onPressed: () {
                      // TODO: Implement undo functionality
                    },
                  ),
                ),
              );
            },
            child: _buildExpenseCard(expense, themeProvider),
          );
        },
      ),
    );
  }

  Widget _buildExpenseCard(
      Map<String, dynamic> expense, ThemeProvider themeProvider) {
    return GestureDetector(
      onTap: () {
        // TODO: Navigate to expense details screen
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: themeProvider.cardColor,
          borderRadius: BorderRadius.circular(12),
          boxShadow: themeProvider.cardShadow,
        ),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: expense['color'].withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  expense['icon'],
                  color: expense['color'],
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: RichText(
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            text: _buildHighlightedText(
                              expense['name'],
                              _searchQuery,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        if (expense['hasReceipt'])
                          Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: const Color(0xFF10B981).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Icon(
                              Icons.receipt,
                              size: 12,
                              color: Color(0xFF10B981),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Flexible(
                      child: Row(
                        children: [
                          Flexible(
                            child: Text(
                              expense['category'],
                              style: const TextStyle(
                                color: Color(0xFF6B7280),
                                fontSize: 12,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const Text(
                            ' • ',
                            style: TextStyle(
                              color: Color(0xFF6B7280),
                              fontSize: 12,
                            ),
                          ),
                          Flexible(
                            child: Text(
                              expense['date'],
                              style: const TextStyle(
                                color: Color(0xFF6B7280),
                                fontSize: 12,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Container(
                constraints: const BoxConstraints(minWidth: 80),
                child: Text(
                  '-\$${expense['amount'].toStringAsFixed(2)}',
                  textAlign: TextAlign.right,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFEF4444),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(AppLocalizations l10n, ThemeProvider themeProvider) {
    return Center(
      child: FadeInUp(
        duration: const Duration(milliseconds: 600),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: themeProvider.primaryColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                _isSearching ? Icons.search_off : Icons.receipt_long,
                size: 64,
                color: themeProvider.primaryColor,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              _isSearching ? l10n.noExpensesFound : l10n.noExpensesYet,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: themeProvider.primaryTextColor,
              ),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 48),
              child: Text(
                _isSearching ? l10n.trySearchingElse : l10n.addYourFirstExpense,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: themeProvider.secondaryTextColor,
                ),
              ),
            ),
            const SizedBox(height: 32),
            if (!_isSearching)
              ElevatedButton.icon(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddExpenseScreen()),
                ),
                icon: const Icon(Icons.add),
                label: Text(l10n.addExpense),
                style: ElevatedButton.styleFrom(
                  backgroundColor: themeProvider.primaryColor,
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  TextSpan _buildHighlightedText(String text, String query) {
    if (query.isEmpty) {
      return TextSpan(
        text: text,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          color: Color(0xFF1F2937),
          fontSize: 16,
        ),
      );
    }

    final lowerText = text.toLowerCase();
    final lowerQuery = query.toLowerCase();
    final spans = <TextSpan>[];

    int start = 0;
    int index = lowerText.indexOf(lowerQuery);

    while (index != -1) {
      if (index > start) {
        spans.add(TextSpan(
          text: text.substring(start, index),
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            color: Color(0xFF1F2937),
            fontSize: 16,
          ),
        ));
      }

      spans.add(TextSpan(
        text: text.substring(index, index + query.length),
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: const Color(0xFF6366F1),
          fontSize: 16,
          backgroundColor: const Color(0xFF6366F1).withOpacity(0.1),
        ),
      ));

      start = index + query.length;
      index = lowerText.indexOf(lowerQuery, start);
    }

    if (start < text.length) {
      spans.add(TextSpan(
        text: text.substring(start),
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          color: Color(0xFF1F2937),
          fontSize: 16,
        ),
      ));
    }

    return TextSpan(children: spans);
  }

  Widget _buildFilterTabs(AppLocalizations l10n, ThemeProvider themeProvider) {
    final List<String> localizedFilters = [
      l10n.all,
      l10n.today,
      l10n.thisWeek,
      l10n.thisMonth,
    ];

    return FadeInDown(
      child: Container(
        height: 60,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        color: Colors.white,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: localizedFilters.length,
          itemBuilder: (context, index) {
            final filter = localizedFilters[index];
            final isSelected = _selectedFilter == _filters[index];

            return GestureDetector(
              onTap: () => setState(() => _selectedFilter = _filters[index]),
              child: Container(
                margin: const EdgeInsets.only(right: 12),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                decoration: BoxDecoration(
                  color:
                      isSelected ? const Color(0xFF6366F1) : Colors.transparent,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected
                        ? const Color(0xFF6366F1)
                        : const Color(0xFFE5E7EB),
                  ),
                ),
                child: Text(
                  filter,
                  style: TextStyle(
                    color: isSelected ? Colors.white : const Color(0xFF6B7280),
                    fontWeight:
                        isSelected ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
