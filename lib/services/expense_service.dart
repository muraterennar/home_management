import 'package:home_management/models/espenses/create_expense_dto.dart';
import 'package:home_management/models/espenses/expense_dto.dart';
import 'package:home_management/services/user_service.dart';

import 'auth_service.dart';
import 'database_service.dart';

class ExpenseService {
  final _authService = AuthService();
  final databaseService = DataBaseService();
  final _userService = UserService();

  get _getCurrentUser => _authService.getCurrentUser();

  get _getCurrentUserProfile => _userService.getCurrentUserProfile();

  // Create a new expense
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

    final ref = databaseService.database.ref("expenses/${createExpenseDto.id}");
    await ref.set(createExpenseDto.toJson());

    return ExpenseDto.fromJson(createExpenseDto.toJson());
  }

  // Get all expenses for the tenant Id
  Future<List<ExpenseDto>> getAllExpenses() async {
    try {
      final user = await _getCurrentUserProfile;
      final tenantId = user?.tenantId;
      print("Getting expenses for tenantId: $tenantId"); // Debug bilgisi

      if (tenantId == null) {
        print("tenantId is null, returning empty list");
        return [];
      }

      final ref = databaseService.database.ref("expenses");
      final snapshot = await ref.orderByChild("tenantId").equalTo(tenantId).get();

      print("Firebase snapshot exists: ${snapshot.exists}"); // Debug bilgisi
      if (!snapshot.exists) {
        return [];
      }

      print("Child count: ${snapshot.children.length}"); // Debug bilgisi

      final expenses = <ExpenseDto>[];
      for (var child in snapshot.children) {
        try {
          // Burada doğru dönüşümü yapıyoruz
          final rawData = child.value as Map<Object?, Object?>;
          print("Raw data for expense: $rawData"); // Debug için tüm ham veriyi göster

          final expenseData = Map<String, dynamic>.from(rawData);

          // Tarih alanını kontrol et
          if (expenseData['date'] != null) {
            // Tarih formatı doğru mu kontrol et
            if (expenseData['date'] is String) {
              try {
                final dateStr = expenseData['date'] as String;
                expenseData['date'] = DateTime.parse(dateStr);
              } catch (e) {
                print("Date parsing error: $e");
                // Geçerli bir tarih yoksa bugünü kullan
                expenseData['date'] = DateTime.now().toIso8601String();
              }
            }
          } else {
            expenseData['date'] = DateTime.now().toIso8601String();
          }

          final expense = ExpenseDto.fromJson(expenseData);
          print("Successfully converted expense: ${expense.name} - ${expense.amount}");
          expenses.add(expense);
        } catch (e) {
          print('Expense conversion error: $e');
          // Hatalı olan veriyi atlıyoruz
        }
      }

      print("Returning ${expenses.length} expenses");
      return expenses;
    } catch (e) {
      print('Error getting expenses: $e');
      rethrow; // Hatayı yukarı fırlat
    }
  }

  // Delete an expense
  Future<void> deleteExpense(String expenseId) async {
    try {
      if (expenseId.isEmpty) {
        throw Exception("Expense ID cannot be empty");
      }

      final ref = databaseService.database.ref("expenses/$expenseId");

      // Önce belirtilen ID'ye sahip harcamanın var olduğunu kontrol edelim
      final snapshot = await ref.get();
      if (!snapshot.exists) {
        throw Exception("Expense with ID $expenseId not found");
      }

      // Harcamayı sil
      await ref.remove();
      print("Expense with ID $expenseId successfully deleted");
    } catch (e) {
      print('Error deleting expense: $e');
      rethrow; // Hatayı yukarıya fırlat
    }
  }
}
