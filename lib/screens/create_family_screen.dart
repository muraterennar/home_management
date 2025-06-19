import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import 'dashboard_screen.dart';

class CreateFamilyScreen extends StatefulWidget {
  const CreateFamilyScreen({super.key});

  @override
  _CreateFamilyScreenState createState() => _CreateFamilyScreenState();
}

class _CreateFamilyScreenState extends State<CreateFamilyScreen> {
  final _familyNameController = TextEditingController();
  final _addressController = TextEditingController();
  String _selectedOption = 'create';

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return Scaffold(
          backgroundColor: themeProvider.backgroundColor,
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  FadeInDown(
                    child: Text(
                      'Family Setup',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: themeProvider.primaryTextColor,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  FadeInDown(
                    delay: const Duration(milliseconds: 200),
                    child: Text(
                      'Set up your family to start managing your home together',
                      style: TextStyle(
                        fontSize: 16,
                        color: themeProvider.secondaryTextColor,
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  FadeInUp(
                    delay: const Duration(milliseconds: 400),
                    child: Container(
                      decoration: BoxDecoration(
                        color: themeProvider.cardColor,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: themeProvider.borderColor),
                      ),
                      child: Column(
                        children: [
                          _buildOptionTile(
                            title: 'Create New Family',
                            subtitle: 'Start fresh with a new family group',
                            icon: Icons.home_outlined,
                            value: 'create',
                            themeProvider: themeProvider,
                          ),
                          Divider(height: 1, color: themeProvider.dividerColor),
                          _buildOptionTile(
                            title: 'Join Existing Family',
                            subtitle: 'Join a family group with an invitation code',
                            icon: Icons.group_add_outlined,
                            value: 'join',
                            themeProvider: themeProvider,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  if (_selectedOption == 'create') ...[
                    FadeInUp(
                      delay: const Duration(milliseconds: 600),
                      child: _buildTextField(
                        controller: _familyNameController,
                        label: 'Family Name',
                        icon: Icons.family_restroom,
                        hint: 'e.g., The Smiths',
                        themeProvider: themeProvider,
                      ),
                    ),
                    const SizedBox(height: 20),
                    FadeInUp(
                      delay: const Duration(milliseconds: 700),
                      child: _buildTextField(
                        controller: _addressController,
                        label: 'Home Address',
                        icon: Icons.location_on_outlined,
                        hint: 'Enter your home address',
                        themeProvider: themeProvider,
                      ),
                    ),
                  ] else ...[
                    FadeInUp(
                      delay: const Duration(milliseconds: 600),
                      child: _buildTextField(
                        controller: _familyNameController,
                        label: 'Invitation Code',
                        icon: Icons.vpn_key_outlined,
                        hint: 'Enter the invitation code',
                        themeProvider: themeProvider,
                      ),
                    ),
                  ],
                  const SizedBox(height: 40),
                  FadeInUp(
                    delay: const Duration(milliseconds: 800),
                    child: SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: () => Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => DashboardScreen()),
                        ),
                        child: Text(
                          _selectedOption == 'create' ? 'Create Family' : 'Join Family',
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  ),
                  if (_selectedOption == 'create') ...[
                    const SizedBox(height: 24),
                    FadeInUp(
                      delay: const Duration(milliseconds: 1000),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF0F9FF),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFFBAE6FD)),
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.info_outline, color: Color(0xFF0EA5E9)),
                            SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                'You can invite family members later from the dashboard',
                                style: TextStyle(
                                  color: Color(0xFF0C4A6E),
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildOptionTile({
    required String title,
    required String subtitle,
    required IconData icon,
    required String value,
    required ThemeProvider themeProvider,
  }) {
    return RadioListTile<String>(
      value: value,
      groupValue: _selectedOption,
      onChanged: (value) => setState(() => _selectedOption = value!),
      activeColor: themeProvider.primaryColor,
      title: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: themeProvider.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: themeProvider.primaryColor, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: themeProvider.primaryTextColor,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 12,
                    color: themeProvider.secondaryTextColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    String? hint,
    required ThemeProvider themeProvider,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: themeProvider.cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: themeProvider.borderColor),
      ),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          prefixIcon: Icon(icon, color: themeProvider.secondaryTextColor),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.all(16),
          labelStyle: TextStyle(color: themeProvider.primaryTextColor),
          hintStyle: TextStyle(color: themeProvider.secondaryTextColor),
        ),
      ),
    );
  }
}
