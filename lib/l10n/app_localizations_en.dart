// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Home Management';

  @override
  String get welcomeBack => 'Welcome Back!';

  @override
  String get signInToContinue => 'Sign in to continue';

  @override
  String get email => 'Email';

  @override
  String get password => 'Password';

  @override
  String get forgotPassword => 'Forgot Password?';

  @override
  String get signIn => 'Sign In';

  @override
  String get dontHaveAccount => 'Don\'t have an account? ';

  @override
  String get signUp => 'Sign Up';

  @override
  String get createAccount => 'Create Account';

  @override
  String get joinUs => 'Join us and start managing your financial life';

  @override
  String get fullName => 'Full Name';

  @override
  String get confirmPassword => 'Confirm Password';

  @override
  String get agreeToTerms =>
      'I agree to the terms of service and privacy policy';

  @override
  String get alreadyHaveAAccount => 'Already have an account? ';

  @override
  String get selectLanguage => 'Select Language';

  @override
  String get cancel => 'Cancel';

  @override
  String get languageChanged => 'Language changed successfully';

  @override
  String get fillAllFields => 'Please fill in all fields';

  @override
  String get passwordsDoNotMatch => 'Passwords do not match';

  @override
  String get registrationSuccess => 'Registration successful';

  @override
  String get registrationFailed => 'Registration failed';

  @override
  String get userAlreadyExists => 'This email is already in use';

  @override
  String get verifyEmailFirst => 'Please verify your email first';

  @override
  String get error => 'Error';

  @override
  String get errorOccurred => 'An error occurred';

  @override
  String get settings => 'Settings';

  @override
  String get dashboard => 'Dashboard';

  @override
  String get expenses => 'Expenses';

  @override
  String get analytics => 'Analytics';

  @override
  String get addExpense => 'Add Expense';

  @override
  String get save => 'Save';

  @override
  String get currencySymbol => '\$';

  @override
  String get category => 'Category';

  @override
  String get amount => 'Amount';

  @override
  String get date => 'Date';

  @override
  String get expenseSaved => 'Expense successfully saved';

  @override
  String get pleaseEnterExpenseName => 'Please enter an expense name';

  @override
  String get pleaseEnterAmount => 'Please enter an amount';

  @override
  String get expenseName => 'Expense Name';

  @override
  String get lunchRestaurant => 'Lunch (Restaurant)';

  @override
  String get selectDate => 'Select Date';

  @override
  String get foodDining => 'Food & Dining';

  @override
  String get transportation => 'Transportation';

  @override
  String get shopping => 'Shopping';

  @override
  String get entertainment => 'Entertainment';

  @override
  String get billsUtilities => 'Bills & Utilities';

  @override
  String get healthcare => 'Healthcare';

  @override
  String get education => 'Education';

  @override
  String get other => 'Other';

  @override
  String get recurringExpense => 'Recurring Expense';

  @override
  String get receiptOptional => 'Receipt (Optional)';

  @override
  String get takePhotoOrUpload => 'Take a photo or upload';

  @override
  String get tapToAdd => 'Tap to add';

  @override
  String get expenseSummary => 'Expense Summary';

  @override
  String get enterExpenseName => 'Enter expense name';

  @override
  String get week => 'Week';

  @override
  String get month => 'Month';

  @override
  String get year => 'Year';

  @override
  String get camera => 'Camera';

  @override
  String get gallery => 'Gallery';

  @override
  String get recurringExpenseNote =>
      'This expense will automatically repeat at the selected frequency';

  @override
  String get uploading => 'Uploading...';

  @override
  String get familySetup => 'Family Setup';

  @override
  String get createFamilyProfile => 'Create Family Profile';

  @override
  String get welcomeToFamilyFinance => 'Welcome to Family Finance';

  @override
  String get familyFinanceDesc =>
      'View, manage, and improve your family\'s financial situation';

  @override
  String get familyName => 'Family Name';

  @override
  String get theFamilyName => 'Enter your family name';

  @override
  String get monthlyFamilyIncome => 'Monthly Family Income';

  @override
  String get fixedMonthlyExpenses => 'Fixed Monthly Expenses';

  @override
  String get addMore => 'Add More';

  @override
  String get rent => 'Rent';

  @override
  String get utilities => 'Utilities';

  @override
  String get internet => 'Internet';

  @override
  String get insurance => 'Insurance';

  @override
  String get delete => 'Delete';

  @override
  String get createNewFamily => 'Create New Family';

  @override
  String get createNewFamilyDesc =>
      'Create a new family profile to manage your family finances';

  @override
  String get joinExistingFamily => 'Join Existing Family';

  @override
  String get joinExistingFamilyDesc =>
      'Join an existing family using a family code';

  @override
  String get invitationCode => 'Invitation Code';

  @override
  String get joinFamily => 'Join Family';

  @override
  String get resetPassword => 'Reset Password';

  @override
  String get forgotYourPassword => 'Forgot Your Password?';

  @override
  String get resetPasswordMessage =>
      'Enter your email address to reset your password. We\'ll send you an email with instructions to reset your password.';

  @override
  String get emailAddress => 'Email Address';

  @override
  String get sendResetLink => 'Send Reset Link';

  @override
  String get checkYourEmail => 'Check Your Email';

  @override
  String get resetLinkSent => 'Password reset link has been sent to:';

  @override
  String get backToLogin => 'Back to Login';

  @override
  String get resendEmail => 'Resend Email';

  @override
  String get editFamilyProfile => 'Edit Family Profile';

  @override
  String get profileSummary => 'Profile Summary';

  @override
  String get updateFamilyInfo => 'Update your family information';

  @override
  String get monthlyIncome => 'Monthly Income';

  @override
  String get fixedExpenses => 'Fixed Expenses';

  @override
  String get saveChanges => 'Save Changes';

  @override
  String get cancelChanges => 'Cancel Changes';

  @override
  String get familyProfile => 'Family Profile';

  @override
  String get copy => 'Copy';

  @override
  String get share => 'Share';

  @override
  String familyCodeShareMessage(String appName, String familyCode) {
    return 'Hello! Join me on $appName with this family code:\n\n$familyCode';
  }

  @override
  String get searchExpenses => 'Search Expenses';

  @override
  String get searchingFor => 'Searching for:';

  @override
  String get results => 'results';

  @override
  String get filterOptions => 'Filter Options';

  @override
  String get clearAll => 'Clear All';

  @override
  String get categories => 'Categories';

  @override
  String get amountRange => 'Amount Range';

  @override
  String get expensesFound => 'expenses found';

  @override
  String get applyFilters => 'Apply Filters';

  @override
  String get filteredTotal => 'Filtered Total';

  @override
  String get totalExpenses => 'Total Expenses';

  @override
  String get transactions => 'transactions';

  @override
  String get all => 'All';

  @override
  String get today => 'Today';

  @override
  String get thisWeek => 'This Week';

  @override
  String get thisMonth => 'This Month';

  @override
  String get deleteExpense => 'Delete Expense';

  @override
  String get deleteConfirmation =>
      'Are you sure you want to delete this expense?';

  @override
  String get deleting => 'Deleting...';

  @override
  String get removed => 'removed';

  @override
  String get undo => 'Undo';

  @override
  String get noExpensesFound => 'No Expenses Found';

  @override
  String get trySearchingElse => 'Try a different search term or clear filters';

  @override
  String get noExpensesYet => 'No Expenses Yet';

  @override
  String get addYourFirstExpense =>
      'Click the plus button to add your first expense';

  @override
  String get viewAll => 'View All';

  @override
  String get totalSpendingText => 'Total Spending';

  @override
  String get vsLastWeek => 'vs Last Week';

  @override
  String get vsLastMonth => 'vs Last Month';

  @override
  String get vsLastYear => 'vs Last Year';

  @override
  String get vsPreviousPeriod => 'vs Previous Period';

  @override
  String get averageDaily => 'Daily Average';

  @override
  String get monthlyBudget => 'Monthly Budget';

  @override
  String get remaining => 'Remaining';

  @override
  String get budgetExceeded => 'Budget Exceeded';

  @override
  String get spendingTrend => 'Spending Trend';

  @override
  String get incomeVsExpenses => 'Income vs Expenses';

  @override
  String get savingsGoals => 'Savings Goals';

  @override
  String get categoryBreakdown => 'Category Breakdown';

  @override
  String get monthlyComparison => 'Monthly Comparison';

  @override
  String get recentTransactions => 'Recent Transactions';

  @override
  String get goal => 'Goal';

  @override
  String get yesterday => 'Yesterday';

  @override
  String daysAgo(Object days) {
    return 'days ago';
  }

  @override
  String get budget => 'Budget';

  @override
  String get budgetOverview => 'Budget Overview';

  @override
  String get spent => 'Spent';

  @override
  String get spentSoFar => 'Spent So Far';

  @override
  String get allocatedBudget => 'Allocated Budget';

  @override
  String get overBudget => 'Over Budget';

  @override
  String get adjust => 'Adjust';

  @override
  String get edit => 'Edit';

  @override
  String get monthlyBudgetOverview => 'Monthly Budget Overview';

  @override
  String get uncategorized => 'Uncategorized';

  @override
  String get amountPaid => 'Amount Paid';

  @override
  String get receiptDetails => 'Receipt Details';

  @override
  String get subtotal => 'Subtotal';

  @override
  String get tax => 'Tax';

  @override
  String get total => 'Total';

  @override
  String get familyCodeCopied => 'Family code copied to clipboard!';

  @override
  String get familyCodeNotFound => 'No family code found to share!';

  @override
  String get familyProfileUpdated => 'Family profile updated';

  @override
  String updateError(String error) {
    return 'Update error: $error';
  }

  @override
  String familyDataError(String error) {
    return 'Failed to load family data: $error';
  }

  @override
  String get tenantIdNotFound => 'Tenant ID not found';

  @override
  String get goodMorning => 'Good Morning!';

  @override
  String get goodAfternoon => 'Good Afternoon!';

  @override
  String get goodEvening => 'Good Evening!';

  @override
  String get familySuffix => 'Family';

  @override
  String daysLeft(Object days) {
    return '$days days left';
  }

  @override
  String get quickActions => 'Quick Actions';

  @override
  String get addExpenseAction => 'Add Expense';

  @override
  String get viewAnalyticsAction => 'View Analytics';

  @override
  String get allExpensesAction => 'All Expenses';

  @override
  String get imageUploadedSuccess => 'Image uploaded successfully.';

  @override
  String get uploadError => 'Image upload failed';

  @override
  String uploadErrorWithMessage(String error) {
    return 'Image upload failed: $error';
  }

  @override
  String get imageUploading => 'Image Uploading...';

  @override
  String get noFamilyFound => 'No family information found';

  @override
  String get tryAgain => 'Try Again';

  @override
  String get createFamilyProfileAction => 'Create Family Profile';

  @override
  String get sharingFor => 'Code copied for sharing';

  @override
  String get invalidInvitationCode => 'Invalid invitation code';

  @override
  String ofIncome(Object percentage) {
    return 'of Income';
  }

  @override
  String firebaseAuthError(Object error) {
    return 'Firebase authentication error: $error';
  }

  @override
  String get noRecentTransactions => 'No recent transactions found';

  @override
  String get general => 'General';

  @override
  String get darkMode => 'Dark Mode';

  @override
  String get switchThemes => 'Switch Themes';

  @override
  String get currency => 'Currency';

  @override
  String get selectCurrency => 'Select Currency';

  @override
  String get language => 'Language';

  @override
  String get notifications => 'Notifications';

  @override
  String get pushNotifications => 'Push Notifications';

  @override
  String get receivePushNotifications => 'Receive Push Notifications';

  @override
  String get emailNotifications => 'Email Notifications';

  @override
  String get receiveEmailNotifications => 'Receive Email Notifications';

  @override
  String get about => 'About';

  @override
  String get version => 'Version';

  @override
  String get privacyPolicy => 'Privacy Policy';

  @override
  String get readPrivacyPolicy => 'Read our Privacy Policy';

  @override
  String get termsOfService => 'Terms of Service';

  @override
  String get readTermsOfService => 'Read our Terms of Service';

  @override
  String get account => 'Account';

  @override
  String get logout => 'Logout';

  @override
  String get logoutDescription =>
      'Are you sure you want to log out? You will need to sign in again to access your account.';

  @override
  String get usd => '\$';

  @override
  String get tr => '₺';

  @override
  String get currencyChanged => 'Currency changed successfully';

  @override
  String get logoutConfirmation => 'Logout Confirmation';

  @override
  String get logoutMessage =>
      'Are you sure you want to log out? You will need to sign in again to access your account.';

  @override
  String get remainingBalance => 'Remaining Balance';

  @override
  String get totalSpending => 'Total Spending';

  @override
  String get totalIncome => 'Total Income';

  @override
  String get onTrack => 'On Track';

  @override
  String get budgetOverflow => 'Budget Overflow';

  @override
  String get goodDay => 'Good Day';

  @override
  String get monthlyProgress => 'Monthly Progress';

  @override
  String get daysPassed => 'Days Passed';

  @override
  String get budgetUsed => 'Budget Used';

  @override
  String get dailyAverage => 'Daily Avg.';

  @override
  String get expenseDetails => 'Expense Details';

  @override
  String get details => 'Details';

  @override
  String get notes => 'Notes';

  @override
  String get receipt => 'Receipt';

  @override
  String get location => 'Location';

  @override
  String get viewFullscreen => 'View Fullscreen';

  @override
  String get editExpense => 'Edit Expense';

  @override
  String get locationServicesDisabled => 'Location services are disabled';

  @override
  String get locationPermissionDenied => 'Location permission denied';

  @override
  String get locationPermissionPermanentlyDenied =>
      'Location permission permanently denied. Please enable from settings';

  @override
  String get getCurrentLocation => 'Get Current Location';

  @override
  String get onBoardingOneTitle => 'Welcome to Home Management App';

  @override
  String get onBoardingOneDesc =>
      'Designed to simplify home management. Manage your income, expenses, and family budget.';

  @override
  String get onBoardingTwoTitle => 'Create a Family Profile';

  @override
  String get onBoardingTwoDesc =>
      'Add your family members and start home management together. Share your family budget and track your expenses.';

  @override
  String get onBoardingThreeTitle => 'Track Your Income and Expenses';

  @override
  String get onBoardingThreeDesc =>
      'Easily track your income and expenses. Manage your monthly budget and achieve your savings goals.';

  @override
  String get getStarted => 'Get Started';

  @override
  String get skip => 'Skip';

  @override
  String get go => 'Next';

  @override
  String get back => 'Back';
}
