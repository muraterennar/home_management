import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  bool _isDarkMode = false;
  
  bool get isDarkMode => _isDarkMode;
  bool get isLightMode => !_isDarkMode;

  ThemeProvider() {
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    _isDarkMode = prefs.getBool('is_dark_mode') ?? false;
    notifyListeners();
  }

  Future<void> toggleTheme() async {
    _isDarkMode = !_isDarkMode;
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('is_dark_mode', _isDarkMode);
    
    notifyListeners();
  }

  // Colors
  Color get backgroundColor => _isDarkMode ? const Color(0xFF0F1419) : const Color(0xFFF8FAFC);
  Color get surfaceColor => _isDarkMode ? const Color(0xFF1A202C) : Colors.white;
  Color get cardColor => _isDarkMode ? const Color(0xFF2D3748) : Colors.white;
  Color get primaryColor => const Color(0xFF6366F1);
  Color get primaryVariant => const Color(0xFF8B5CF6);
  
  // Text Colors
  Color get primaryTextColor => _isDarkMode ? Colors.white : const Color(0xFF1F2937);
  Color get secondaryTextColor => _isDarkMode ? const Color(0xFFE2E8F0) : const Color(0xFF6B7280);
  Color get subtitleTextColor => _isDarkMode ? const Color(0xFFA0AEC0) : const Color(0xFF9CA3AF);
  
  // Border Colors
  Color get borderColor => _isDarkMode ? const Color(0xFF4A5568) : const Color(0xFFE5E7EB);
  Color get dividerColor => _isDarkMode ? const Color(0xFF2D3748) : const Color(0xFFF3F4F6);
  
  // Status Colors
  Color get successColor => const Color(0xFF10B981);
  Color get errorColor => const Color(0xFFEF4444);
  Color get warningColor => const Color(0xFFF59E0B);
  Color get infoColor => const Color(0xFF3B82F6);
  
  // Icon Colors
  Color get iconColor => _isDarkMode ? const Color(0xFFE2E8F0) : const Color(0xFF6B7280);
  Color get activeIconColor => primaryColor;
  
  // Input Colors
  Color get inputBackgroundColor => _isDarkMode ? const Color(0xFF2D3748) : const Color(0xFFF9FAFB);
  Color get inputBorderColor => _isDarkMode ? const Color(0xFF4A5568) : const Color(0xFFE5E7EB);
  Color get hintTextColor => _isDarkMode ? const Color(0xFFA0AEC0) : const Color(0xFF9CA3AF);
  
  // Shadow
  List<BoxShadow> get cardShadow => _isDarkMode 
    ? [BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 10, offset: const Offset(0, 4))]
    : [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))];
    
  List<BoxShadow> get elevatedShadow => _isDarkMode 
    ? [BoxShadow(color: Colors.black.withOpacity(0.4), blurRadius: 20, offset: const Offset(0, 8))]
    : [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 20, offset: const Offset(0, 8))];

  // Gradient
  LinearGradient get primaryGradient => LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primaryColor, primaryVariant],
  );
  
  LinearGradient get cardGradient => _isDarkMode 
    ? LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [const Color(0xFF2D3748), const Color(0xFF1A202C)],
      )
    : LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Colors.white, const Color(0xFFF8FAFC)],
      );

  // Material Theme Data
  ThemeData get themeData => ThemeData(
    brightness: _isDarkMode ? Brightness.dark : Brightness.light,
    primaryColor: primaryColor,
    scaffoldBackgroundColor: backgroundColor,
    cardColor: cardColor,
    dividerColor: dividerColor,
    appBarTheme: AppBarTheme(
      backgroundColor: surfaceColor,
      elevation: 0,
      iconTheme: IconThemeData(color: iconColor),
      titleTextStyle: TextStyle(
        color: primaryTextColor,
        fontSize: 18,
        fontWeight: FontWeight.w600,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: inputBackgroundColor,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: inputBorderColor),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: inputBorderColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: primaryColor, width: 2),
      ),
      hintStyle: TextStyle(color: hintTextColor),
    ),
    switchTheme: SwitchThemeData(
      thumbColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.selected)) {
          return primaryColor;
        }
        return _isDarkMode ? const Color(0xFF4A5568) : const Color(0xFFE5E7EB);
      }),
      trackColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.selected)) {
          return primaryColor.withOpacity(0.5);
        }
        return _isDarkMode ? const Color(0xFF2D3748) : const Color(0xFFF3F4F6);
      }),
    ),
  );
}
