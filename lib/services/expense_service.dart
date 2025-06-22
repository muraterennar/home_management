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
}
