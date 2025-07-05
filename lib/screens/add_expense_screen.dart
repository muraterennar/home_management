import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:provider/provider.dart';
import '../providers/currency_provider.dart';
import '../providers/theme_provider.dart';
import 'package:home_management/l10n/app_localizations.dart';
import '../services/expense_service.dart';
import '../models/espenses/create_expense_dto.dart';
import '../models/espenses/expense_category.dart';
import '../services/sync_service.dart';
import 'settings_screen.dart';
import 'dart:developer' as developer;
import 'dart:convert';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class AddExpenseScreen extends StatefulWidget {
  @override
  _AddExpenseScreenState createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  final _formKey = GlobalKey<FormState>();
  final _expenseNameController = TextEditingController();
  final _amountController = TextEditingController();
  final _dateController = TextEditingController();
  ExpenseCategory _selectedCategory = ExpenseCategory.foodDining; // String yerine ExpenseCategory
  bool _hasReceiptImage = false;
  bool _isRecurring = false;
  String _recurringFrequency = 'monthly';
  DateTime _selectedDate = DateTime.now();
  final _expenseService = ExpenseService();
  final _syncService = SyncService.instance;
  String? _imageId; // Local image ID
  String? _localImagePath; // Local image path
  String? _onlineImageUrl; // Online image URL
  final ImagePicker _picker = ImagePicker();
  bool _isUploading = false;
  double _uploadProgress = 0.0; // Yükleme ilerleme yüzdesi

  @override
  void initState() {
    super.initState();
    _dateController.text = _formatDate(_selectedDate);
  }

  @override
  void dispose() {
    _expenseNameController.dispose();
    _amountController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  Future<void> _selectDate(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(DateTime.now().year - 1),
      lastDate: DateTime.now().add(const Duration(days: 365)),
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

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _dateController.text = _formatDate(_selectedDate);
      });
    }
  }

  // Kameradan resim çekme
  Future<void> _getImageFromCamera() async {
    try {
      developer.log('Kameradan fotoğraf çekme başlatıldı', name: 'AddExpenseScreen');
      await _pickAndUploadImage(ImageSource.camera);
    } catch (e, stack) {
      developer.log('Kameradan fotoğraf çekme hatası', name: 'AddExpenseScreen', error: e, stackTrace: stack);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Kamera hatası: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  // Galeriden resim seçme
  Future<void> _getImageFromGallery() async {
    try {
      developer.log('Galeriden fotoğraf seçme başlatıldı', name: 'AddExpenseScreen');
      await _pickAndUploadImage(ImageSource.gallery);
    } catch (e, stack) {
      developer.log('Galeriden fotoğraf seçme hatası', name: 'AddExpenseScreen', error: e, stackTrace: stack);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Galeri hatası: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  // Hibrit resim yükleme fonksiyonu
  Future<void> _pickAndUploadImage(ImageSource source) async {
    final l10n = AppLocalizations.of(context)!;
    try {
      final picked = await _picker.pickImage(source: source, imageQuality: 80);
      developer.log('ImagePicker sonucu: ${picked?.path}', name: 'AddExpenseScreen');

      if (picked == null) {
        developer.log('Kullanıcı fotoğraf seçmedi veya çekmedi', name: 'AddExpenseScreen');
        return;
      }

      final file = File(picked.path);
      developer.log('File exists: ${await file.exists()} - Path: ${file.path}', name: 'AddExpenseScreen');

      setState(() {
        _isUploading = true;
        _uploadProgress = 0.0;
      });

      final fileName = '${DateTime.now().millisecondsSinceEpoch}_${picked.name}';

      try {
        // Hibrit resim kaydetme: önce local, sonra Supabase
        final results = await _syncService.saveImageHybrid(file, fileName);

        setState(() {
          _uploadProgress = 0.5; // Local kayıt tamamlandı
          _imageId = results['imageId'];
          _localImagePath = results['localPath'];
          _onlineImageUrl = results['onlineUrl']; // Varsa online URL
          _hasReceiptImage = true;
        });

        // UI güncellemesi için kısa animasyon
        for (int i = 50; i <= 100; i += 10) {
          await Future.delayed(const Duration(milliseconds: 100));
          if (mounted) {
            setState(() {
              _uploadProgress = i / 100;
            });
          }
        }

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(_onlineImageUrl != null
                  ? l10n.imageUploadedSuccess
                  : 'Resim local\'e kaydedildi, internet bağlantısı kurulduğunda sync edilecek'),
              backgroundColor: Colors.green,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }

      } catch (e, stack) {
        developer.log('Hibrit resim kaydetme hatası', name: 'AddExpenseScreen', error: e, stackTrace: stack);

        String errorMessage;
        if (e.toString().contains('Failed host lookup') || e.toString().contains('SocketException')) {
          errorMessage = 'Resim local\'e kaydedildi. İnternet bağlantısı kurulduğunda sync edilecek.';
        } else {
          errorMessage = 'Resim kaydetme hatası: ${e.toString()}';
        }

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(errorMessage),
              backgroundColor: e.toString().contains('Failed host lookup') ? Colors.orange : Colors.red,
              behavior: SnackBarBehavior.floating,
              duration: const Duration(seconds: 5),
              action: SnackBarAction(
                label: 'Tekrar Dene',
                textColor: Colors.white,
                onPressed: () => _pickAndUploadImage(source),
              ),
            ),
          );
        }
      } finally {
        setState(() {
          _isUploading = false;
        });
      }
    } catch (e, stack) {
      developer.log('Resim seçme/yükleme genel hatası', name: 'AddExpenseScreen', error: e, stackTrace: stack);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Resim seçme/yükleme hatası: $e'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Consumer2<ThemeProvider, CurrencyProvider>(
      builder: (context, themeProvider, currencyProvider, child) {
        // Kategori listesini enum değerlerine dayalı olarak oluştur
        final List<Map<String, dynamic>> _categories = [
          {
            'category': ExpenseCategory.foodDining,
            'name': l10n.foodDining,
            'icon': Icons.restaurant,
            'color': themeProvider.successColor
          },
          {
            'category': ExpenseCategory.transportation,
            'name': l10n.transportation,
            'icon': Icons.directions_car,
            'color': themeProvider.infoColor
          },
          {
            'category': ExpenseCategory.shopping,
            'name': l10n.shopping,
            'icon': Icons.shopping_bag,
            'color': themeProvider.warningColor
          },
          {
            'category': ExpenseCategory.entertainment,
            'name': l10n.entertainment,
            'icon': Icons.movie,
            'color': themeProvider.errorColor
          },
          {
            'category': ExpenseCategory.billsUtilities,
            'name': l10n.billsUtilities,
            'icon': Icons.receipt_long,
            'color': themeProvider.primaryVariant
          },
          {
            'category': ExpenseCategory.healthcare,
            'name': l10n.healthcare,
            'icon': Icons.local_hospital,
            'color': const Color(0xFF06B6D4)
          },
          {
            'category': ExpenseCategory.education,
            'name': l10n.education,
            'icon': Icons.school,
            'color': const Color(0xFFF97316)
          },
          {
            'category': ExpenseCategory.other,
            'name': l10n.other,
            'icon': Icons.more_horiz,
            'color': themeProvider.iconColor
          },
        ];


        return Scaffold(
          backgroundColor: themeProvider.backgroundColor,
          appBar: AppBar(
            backgroundColor: themeProvider.surfaceColor,
            elevation: 0,
            leading: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: Icon(Icons.arrow_back_ios, color: themeProvider.iconColor),
            ),
            title: Text(
              l10n.addExpense,
              style: TextStyle(
                color: themeProvider.primaryTextColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            actions: [
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
          body: Form(
            key: _formKey,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FadeInUp(
                    child: _buildExpenseNameField(l10n, themeProvider),
                  ),
                  const SizedBox(height: 24),
                  FadeInUp(
                    delay: const Duration(milliseconds: 200),
                    child: _buildAmountField(
                        l10n, themeProvider, currencyProvider),
                  ),
                  const SizedBox(height: 24),
                  FadeInUp(
                    delay: const Duration(milliseconds: 300),
                    child: _buildDateField(l10n, themeProvider),
                  ),
                  const SizedBox(height: 32),
                  FadeInUp(
                    delay: const Duration(milliseconds: 400),
                    child: _buildCategorySelector(
                        l10n, _categories, themeProvider),
                  ),
                  const SizedBox(height: 32),
                  FadeInUp(
                    delay: const Duration(milliseconds: 500),
                    child: _buildRecurringOptions(l10n, themeProvider),
                  ),
                  const SizedBox(height: 32),
                  FadeInUp(
                    delay: const Duration(milliseconds: 600),
                    child: _buildReceiptUpload(l10n, themeProvider),
                  ),
                  const SizedBox(height: 32),
                  FadeInUp(
                    delay: const Duration(milliseconds: 700),
                    child: _buildSummaryCard(
                        l10n, _categories, themeProvider, currencyProvider),
                  ),
                  const SizedBox(height: 32),
                  FadeInUp(
                    delay: const Duration(milliseconds: 800),
                    child: _buildActionButtons(l10n, themeProvider),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildExpenseNameField(
      AppLocalizations l10n, ThemeProvider themeProvider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.expenseName,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: themeProvider.primaryTextColor,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: themeProvider.inputBackgroundColor,
            borderRadius: BorderRadius.circular(12),
            boxShadow: themeProvider.cardShadow,
          ),
          child: TextFormField(
            controller: _expenseNameController,
            style: TextStyle(color: themeProvider.primaryTextColor),
            decoration: InputDecoration(
              hintText: l10n.lunchRestaurant,
              prefixIcon: Icon(Icons.receipt, color: themeProvider.iconColor),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.all(16),
              hintStyle: TextStyle(color: themeProvider.hintTextColor),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return l10n.pleaseEnterExpenseName;
              }
              return null;
            },
          ),
        ),
      ],
    );
  }

  Widget _buildDateField(AppLocalizations l10n, ThemeProvider themeProvider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.save,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: themeProvider.primaryTextColor,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: themeProvider.inputBackgroundColor,
            borderRadius: BorderRadius.circular(12),
            boxShadow: themeProvider.cardShadow,
          ),
          child: TextFormField(
            controller: _dateController,
            readOnly: true,
            style: TextStyle(color: themeProvider.primaryTextColor),
            decoration: InputDecoration(
              hintText: l10n.selectDate,
              prefixIcon:
                  Icon(Icons.calendar_today, color: themeProvider.iconColor),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.all(16),
              hintStyle: TextStyle(color: themeProvider.hintTextColor),
              suffixIcon: IconButton(
                icon: Icon(Icons.edit_calendar, color: themeProvider.iconColor),
                onPressed: () => _selectDate(context),
              ),
            ),
            onTap: () => _selectDate(context),
          ),
        ),
      ],
    );
  }

  Widget _buildAmountField(AppLocalizations l10n, ThemeProvider themeProvider,
      CurrencyProvider currencyProvider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.amount,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: themeProvider.primaryTextColor,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: themeProvider.inputBackgroundColor,
            borderRadius: BorderRadius.circular(12),
            boxShadow: themeProvider.cardShadow,
          ),
          child: TextFormField(
            controller: _amountController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: themeProvider.primaryTextColor,
            ),
            decoration: InputDecoration(
              hintText: '0.00',
              prefixIcon: Container(
                margin: const EdgeInsets.all(12),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: themeProvider.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  l10n.currencySymbol ?? '₺',
                  style: TextStyle(
                    color: themeProvider.primaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.all(16),
              hintStyle: TextStyle(color: themeProvider.hintTextColor),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return l10n.pleaseEnterAmount;
              }
              return null;
            },
          ),
        ),
      ],
    );
  }

  Widget _buildCategorySelector(AppLocalizations l10n,
      List<Map<String, dynamic>> categories, ThemeProvider themeProvider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.category,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: themeProvider.primaryTextColor,
          ),
        ),
        const SizedBox(height: 12),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 3,
          ),
          itemCount: categories.length,
          itemBuilder: (context, index) {
            final category = categories[index];
            final enumCategory = category['category'] as ExpenseCategory;
            final isSelected = _selectedCategory == enumCategory;

            return GestureDetector(
              onTap: () => setState(() => _selectedCategory = enumCategory),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isSelected
                      ? category['color'].withOpacity(0.1)
                      : Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected
                        ? category['color']
                        : const Color(0xFFE5E7EB),
                    width: isSelected ? 2 : 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Icon(
                      category['icon'],
                      color: isSelected
                          ? category['color']
                          : const Color(0xFF6B7280),
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        category['name'],
                        style: TextStyle(
                          color: isSelected
                              ? category['color']
                              : const Color(0xFF6B7280),
                          fontWeight:
                              isSelected ? FontWeight.w600 : FontWeight.normal,
                          fontSize: 12,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildRecurringOptions(
      AppLocalizations l10n, ThemeProvider themeProvider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              l10n.recurringExpense,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: themeProvider.primaryTextColor,
              ),
            ),
            Switch(
              value: _isRecurring,
              onChanged: (value) => setState(() => _isRecurring = value),
              activeColor: themeProvider.primaryColor,
            ),
          ],
        ),
        if (_isRecurring) ...[
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildFrequencyOption(
                    'weekly', l10n.week, Icons.view_week, themeProvider),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildFrequencyOption(
                    'monthly', l10n.month, Icons.calendar_month, themeProvider),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildFrequencyOption(
                    'yearly', l10n.year, Icons.calendar_today, themeProvider),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            l10n.recurringExpenseNote,
            style: TextStyle(
              fontSize: 12,
              color: themeProvider.secondaryTextColor,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildFrequencyOption(
      String value, String label, IconData icon, ThemeProvider themeProvider) {
    final isSelected = _recurringFrequency == value;

    return GestureDetector(
      onTap: () => setState(() => _recurringFrequency = value),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color:
              isSelected ? themeProvider.primaryColor : themeProvider.cardColor,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected
                ? themeProvider.primaryColor
                : const Color(0xFFE5E7EB),
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.white : themeProvider.iconColor,
              size: 20,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: isSelected
                    ? Colors.white
                    : themeProvider.secondaryTextColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReceiptUpload(
      AppLocalizations l10n, ThemeProvider themeProvider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.receiptOptional,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: themeProvider.primaryTextColor,
          ),
        ),
        const SizedBox(height: 12),
        if (!_hasReceiptImage)
          GestureDetector(
            onTap: _isUploading ? null : () => _pickAndUploadImage(ImageSource.gallery),
            child: DottedBorder(
              borderType: BorderType.RRect,
              radius: const Radius.circular(12),
              dashPattern: const [8, 4],
              color: _isUploading ? Colors.grey : const Color(0xFF6366F1),
              child: Container(
                height: 120,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: _isUploading
                    ? Colors.grey.withOpacity(0.05)
                    : const Color(0xFF6366F1).withOpacity(0.05),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: _isUploading
                    ? _buildUploadingIndicator(themeProvider)
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.camera_alt,
                            size: 32,
                            color: Color(0xFF6366F1),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            l10n.takePhotoOrUpload,
                            style: const TextStyle(
                              color: Color(0xFF6366F1),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            l10n.tapToAdd,
                            style: const TextStyle(
                              color: Color(0xFF6B7280),
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
              ),
            ),
          )
        else
          Container(
            height: 120,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: (_onlineImageUrl != null || _localImagePath != null)
                      ? (_onlineImageUrl != null
                          ? Image.network(
                              _onlineImageUrl!,
                              width: double.infinity,
                              height: double.infinity,
                              fit: BoxFit.cover,
                              loadingBuilder: (context, child, loadingProgress) {
                                if (loadingProgress == null) return child;
                                return Center(
                                  child: CircularProgressIndicator(
                                    value: loadingProgress.expectedTotalBytes != null
                                        ? loadingProgress.cumulativeBytesLoaded /
                                            loadingProgress.expectedTotalBytes!
                                        : null,
                                    color: const Color(0xFF6366F1),
                                  ),
                                );
                              },
                              errorBuilder: (context, error, stackTrace) {
                                // Online resim yüklenemezse local'i dene
                                return _localImagePath != null
                                    ? Image.file(
                                        File(_localImagePath!),
                                        width: double.infinity,
                                        height: double.infinity,
                                        fit: BoxFit.cover,
                                      )
                                    : Container(
                                        width: double.infinity,
                                        height: double.infinity,
                                        color: const Color(0xFFF3F4F6),
                                        child: const Icon(
                                          Icons.receipt_long,
                                          size: 48,
                                          color: Color(0xFF6B7280),
                                        ),
                                      );
                              },
                            )
                          : Image.file(
                              File(_localImagePath!),
                              width: double.infinity,
                              height: double.infinity,
                              fit: BoxFit.cover,
                            ))
                      : Container(
                          width: double.infinity,
                          height: double.infinity,
                          color: const Color(0xFFF3F4F6),
                          child: const Icon(
                            Icons.receipt_long,
                            size: 48,
                            color: Color(0xFF6B7280),
                          ),
                        ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: GestureDetector(
                    onTap: _isUploading
                      ? null
                      : () => setState(() {
                          _hasReceiptImage = false;
                          _onlineImageUrl = null;
                          _localImagePath = null;
                          _imageId = null;
                        }),
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: _isUploading ? Colors.grey : Colors.red,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        _isUploading ? Icons.hourglass_empty : Icons.close,
                        size: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                if (_isUploading)
                  Positioned.fill(
                    child: _buildUploadingIndicator(themeProvider),
                  ),
              ],
            ),
          ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: _isUploading ? null : () => _pickAndUploadImage(ImageSource.camera),
                icon: Icon(_isUploading ? Icons.hourglass_empty : Icons.camera_alt, size: 18),
                label: Text(_isUploading ? l10n.uploading ?? 'Yükleniyor...' : l10n.camera),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: _isUploading ? Colors.grey : const Color(0xFF6366F1),
                  elevation: 0,
                  side: BorderSide(color: _isUploading ? Colors.grey : const Color(0xFF6366F1)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: _isUploading ? null : () => _pickAndUploadImage(ImageSource.gallery),
                icon: Icon(_isUploading ? Icons.hourglass_empty : Icons.photo_library, size: 18),
                label: Text(_isUploading ? l10n.uploading ?? 'Yükleniyor...' : l10n.gallery),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: _isUploading ? Colors.grey : const Color(0xFF6366F1),
                  elevation: 0,
                  side: BorderSide(color: _isUploading ? Colors.grey : const Color(0xFF6366F1)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // Yükleme göstergesi için yeni widget
  Widget _buildUploadingIndicator(ThemeProvider themeProvider) {
    final l10n = AppLocalizations.of(context)!; // l10n değişkenini tanımla

    return Container(
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 60,
            height: 60,
            child: Stack(
              alignment: Alignment.center,
              children: [
                CircularProgressIndicator(
                  value: _uploadProgress,
                  backgroundColor: Colors.white.withOpacity(0.3),
                  valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF6366F1)),
                  strokeWidth: 6,
                ),
                Text(
                  "${(_uploadProgress * 100).toInt()}%",
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          FadeIn(
            child: Text(
              l10n.imageUploading,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(
      AppLocalizations l10n,
      List<Map<String, dynamic>> categories,
      ThemeProvider themeProvider,
      CurrencyProvider currencyProvider) {
    return Consumer<CurrencyProvider>(
      builder: (context, currencyProvider, child) {
        // Seçilen kategoriyi bul
        final selectedCategoryData = categories.firstWhere(
          (cat) => cat['category'] == _selectedCategory,
          orElse: () => categories.first,
        );

        final currencySymbol = l10n.currencySymbol ?? '₺';

        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.summarize, color: Colors.white, size: 24),
                  const SizedBox(width: 8),
                  Text(
                    l10n.expenseSummary,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      selectedCategoryData['icon'],
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          selectedCategoryData['name'], // Yerelleştirilmiş kategori adı
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          _expenseNameController.text.isEmpty
                              ? l10n.enterExpenseName
                              : _expenseNameController.text,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    _amountController.text.isEmpty
                        ? '$currencySymbol 0.00'
                        : '$currencySymbol${_amountController.text}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildActionButtons(
      AppLocalizations l10n, ThemeProvider themeProvider) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: () => Navigator.pop(context),
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: themeProvider.primaryColor),
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              l10n.cancel,
              style: TextStyle(color: themeProvider.primaryColor),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: ElevatedButton(
            onPressed: _saveExpense,
            style: ElevatedButton.styleFrom(
              backgroundColor: themeProvider.primaryColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(l10n.save),
          ),
        ),
      ],
    );
  }

  void _saveExpense() async {
    if (_formKey.currentState!.validate()) {
      try {
        // Hibrit yapıda resim URL'ini belirle: önce online, sonra local
        String? imageUrl;
        if (_onlineImageUrl != null) {
          imageUrl = _onlineImageUrl; // Online URL varsa onu kullan
        } else if (_localImagePath != null) {
          imageUrl = _localImagePath; // Yoksa local path'i kullan
        }

        final createExpenseDto = CreateExpenseDto(
          name: _expenseNameController.text,
          amount: double.tryParse(_amountController.text) ?? 0.0,
          category: _selectedCategory!,
          date: _selectedDate,
          isActive: true,
          voucherUrl: imageUrl, // Hibrit resim URL'i
        );

        developer.log("Kaydedilecek harcama: ${createExpenseDto.toJson()}", name: 'ExpenseCreation');

        final result = await _expenseService.createExpense(createExpenseDto);

        developer.log("Harcama başarıyla kaydedildi: ${result.toJson()}", name: 'ExpenseCreation');

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context)!.expenseSaved)),
        );

        Navigator.pop(context);
      } catch (e) {
        developer.log("Harcama kaydedilirken hata oluştu: $e", name: 'ExpenseCreation', error: e);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("${AppLocalizations.of(context)!.error}: $e")),
        );
      }
    }
  }
}
