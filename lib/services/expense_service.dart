import 'dart:convert';
import 'package:home_management/models/espenses/create_expense_dto.dart';
import 'package:home_management/models/espenses/expense_dto.dart';
import 'package:home_management/services/user_service.dart';
import 'package:home_management/services/local_storage_service.dart';
import 'package:home_management/services/sync_service.dart';
import 'dart:developer' as developer;

import 'auth_service.dart';
import 'database_service.dart';

class ExpenseService {
  final _authService = AuthService();
  final databaseService = DataBaseService();
  final _userService = UserService();
  final _localStorage = LocalStorageService.instance;
  final _syncService = SyncService.instance;

  get _getCurrentUser => _authService.getCurrentUser();
  get _getCurrentUserProfile => _userService.getCurrentUserProfile();

  // Create a new expense (hibrit yaklaşım)
  Future<ExpenseDto> createExpense(CreateExpenseDto createExpenseDto) async {
    final user = await _getCurrentUserProfile;
    final currentUser = await _getCurrentUser;
    if (user == null) {
      throw Exception("User not authenticated");
    }

    createExpenseDto.createdBy = currentUser.uid;
    createExpenseDto.tenantId = user.tenantId;
    createExpenseDto.createdAt = databaseService.getCurrentDate();
    createExpenseDto.isActive = true;

    try {
      // Önce Firebase'e kaydet
      final ref = databaseService.database.ref("expenses/${createExpenseDto.id}");
      await ref.set(createExpenseDto.toJson());

      developer.log('Harcama Firebase\'e kaydedildi: ${createExpenseDto.id}', name: 'ExpenseService');

    } catch (e) {
      developer.log('Firebase kaydetme hatası, local\'e kaydediliyor: $e', name: 'ExpenseService');

      // Firebase başarısız olursa sync queue'ya ekle
      await _localStorage.addToSyncQueue(
        id: createExpenseDto.id,
        tableName: 'expenses',
        operation: 'create',
        data: jsonEncode(createExpenseDto.toJson()),
      );
    }

    return ExpenseDto.fromJson(createExpenseDto.toJson());
  }

  // Get all expenses for the tenant Id (hibrit yaklaşım)
  Future<List<ExpenseDto>> getAllExpenses() async {
    try {
      final user = await _getCurrentUserProfile;
      final tenantId = user?.tenantId;
      developer.log("Getting expenses for tenantId: $tenantId", name: 'ExpenseService');

      if (tenantId == null) {
        developer.log("tenantId is null, returning empty list", name: 'ExpenseService');
        return [];
      }

      // İnternet bağlantısı varsa Firebase'den al
      if (await _syncService.hasInternetConnection()) {
        try {
          final ref = databaseService.database.ref("expenses");
          final snapshot = await ref.orderByChild("tenantId").equalTo(tenantId).get();

          developer.log("Firebase snapshot exists: ${snapshot.exists}", name: 'ExpenseService');

          if (snapshot.exists) {
            final expenses = <ExpenseDto>[];
            for (var child in snapshot.children) {
              try {
                final rawData = child.value as Map<Object?, Object?>;
                final expenseData = Map<String, dynamic>.from(rawData);

                // Tarih alanını kontrol et
                if (expenseData['date'] != null) {
                  if (expenseData['date'] is String) {
                    try {
                      final dateStr = expenseData['date'] as String;
                      expenseData['date'] = DateTime.parse(dateStr);
                    } catch (e) {
                      developer.log("Date parsing error: $e", name: 'ExpenseService');
                      expenseData['date'] = DateTime.now().toIso8601String();
                    }
                  }
                } else {
                  expenseData['date'] = DateTime.now().toIso8601String();
                }

                final expense = ExpenseDto.fromJson(expenseData);
                expenses.add(expense);
              } catch (e) {
                developer.log('Expense conversion error: $e', name: 'ExpenseService');
              }
            }

            developer.log("Firebase'den ${expenses.length} harcama alındı", name: 'ExpenseService');

            // Bekleyen sync işlemlerini gerçekleştir
            await _syncService.processPendingSyncs();

            return expenses;
          }
        } catch (e) {
          developer.log('Firebase\'den veri alma hatası: $e', name: 'ExpenseService');
        }
      }

      // İnternet yoksa veya Firebase hatası varsa boş liste döndür
      // (Gelecekte local cache eklenebilir)
      developer.log("İnternet bağlantısı yok veya Firebase hatası, boş liste döndürülüyor", name: 'ExpenseService');
      return [];

    } catch (e) {
      developer.log('Error getting expenses: $e', name: 'ExpenseService');
      return [];
    }
  }

  // Delete an expense
  Future<void> deleteExpense(String expenseId) async {
    try {
      if (expenseId.isEmpty) {
        throw Exception("Expense ID cannot be empty");
      }

      if (await _syncService.hasInternetConnection()) {
        final ref = databaseService.database.ref("expenses/$expenseId");
        final snapshot = await ref.get();

        if (!snapshot.exists) {
          throw Exception("Expense with ID $expenseId not found");
        }

        await ref.remove();
        developer.log("Expense with ID $expenseId successfully deleted from Firebase", name: 'ExpenseService');
      } else {
        // İnternet yoksa sync queue'ya delete işlemi ekle
        await _localStorage.addToSyncQueue(
          id: expenseId,
          tableName: 'expenses',
          operation: 'delete',
          data: '{"expenseId": "$expenseId"}',
        );
        developer.log("Expense with ID $expenseId added to delete queue", name: 'ExpenseService');
      }
    } catch (e) {
      developer.log('Error deleting expense: $e', name: 'ExpenseService');
      rethrow;
    }
  }
}
