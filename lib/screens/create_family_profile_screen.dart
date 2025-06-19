import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'family_dashboard_screen.dart';

class CreateFamilyProfileScreen extends StatefulWidget {
  @override
  _CreateFamilyProfileScreenState createState() => _CreateFamilyProfileScreenState();
}

class _CreateFamilyProfileScreenState extends State<CreateFamilyProfileScreen> {
  final _familyNameController = TextEditingController();
  final _monthlyIncomeController = TextEditingController();
  
  final List<Map<String, dynamic>> _fixedExpenses = [
    {'name': 'Rent', 'controller': TextEditingController(), 'icon': Icons.home},
    {'name': 'Utilities', 'controller': TextEditingController(), 'icon': Icons.flash_on},
    {'name': 'Internet', 'controller': TextEditingController(), 'icon': Icons.wifi},
    {'name': 'Insurance', 'controller': TextEditingController(), 'icon': Icons.security},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back_ios, color: Color(0xFF1F2937)),
        ),
        title: Text(
          'Create Family Profile',
          style: TextStyle(
            color: Color(0xFF1F2937),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FadeInUp(
              child: _buildWelcomeCard(),
            ),
            SizedBox(height: 32),
            FadeInUp(
              delay: Duration(milliseconds: 200),
              child: _buildFamilyNameField(),
            ),
            SizedBox(height: 24),
            FadeInUp(
              delay: Duration(milliseconds: 400),
              child: _buildMonthlyIncomeField(),
            ),
            SizedBox(height: 32),
            FadeInUp(
              delay: Duration(milliseconds: 600),
              child: _buildFixedExpensesSection(),
            ),
            SizedBox(height: 40),
            FadeInUp(
              delay: Duration(milliseconds: 800),
              child: _buildCreateButton(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWelcomeCard() {
    return Container(
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.family_restroom, color: Colors.white, size: 32),
          SizedBox(height: 16),
          Text(
            'Welcome to Family Finance',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Set up your family profile to start tracking your income and expenses together.',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFamilyNameField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Family Name',
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
              hintText: 'e.g., The Smith Family',
              prefixIcon: Icon(Icons.family_restroom, color: Color(0xFF6B7280)),
              border: InputBorder.none,
              contentPadding: EdgeInsets.all(16),
              hintStyle: TextStyle(color: Color(0xFF9CA3AF)),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMonthlyIncomeField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Monthly Family Income',
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
              hintText: '0.00',
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
              hintStyle: TextStyle(color: Color(0xFF9CA3AF)),
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

  Widget _buildFixedExpensesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Fixed Monthly Expenses',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF374151),
              ),
            ),
            Spacer(),
            TextButton.icon(
              onPressed: () {}, // Non-functional
              icon: Icon(Icons.add, size: 16),
              label: Text('Add More'),
              style: TextButton.styleFrom(
                foregroundColor: Color(0xFF6366F1),
              ),
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
          );
        }),
      ],
    );
  }

  Widget _buildCreateButton() {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: () => Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => FamilyDashboardScreen()),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFF6366F1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          'Create Family Profile',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
