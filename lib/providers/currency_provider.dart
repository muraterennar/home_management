import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CurrencyProvider extends ChangeNotifier {
  String _currentCurrency = 'USD';
  
  String get currentCurrency => _currentCurrency;
  
  String get currencySymbol {
    switch (_currentCurrency) {
      case 'TRY':
        return '₺';
      case 'USD':
        return '\$';
      default:
        return '\$';
    }
  }
  
  bool get isUSD => _currentCurrency == 'USD';
  bool get isTRY => _currentCurrency == 'TRY';

  CurrencyProvider() {
    _loadCurrency();
  }

  Future<void> _loadCurrency() async {
    final prefs = await SharedPreferences.getInstance();
    final currencyCode = prefs.getString('currency_code') ?? 'USD';
    _currentCurrency = currencyCode;
    notifyListeners();
  }

  Future<void> changeCurrency(String currencyCode) async {
    if (_currentCurrency == currencyCode) return;
    
    _currentCurrency = currencyCode;
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('currency_code', currencyCode);
    
    notifyListeners();
  }

  String getCurrencyName(String code) {
    switch (code) {
      case 'TRY':
        return 'Turkish Lira (₺)';
      case 'USD':
        return 'US Dollar (\$)';
      default:
        return 'US Dollar (\$)';
    }
  }

  String formatAmount(double amount) {
    return '${currencySymbol}${amount.toStringAsFixed(2)}';
  }
}
