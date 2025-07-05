import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_tr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('tr')
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Home Management'**
  String get appTitle;

  /// No description provided for @welcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome Back!'**
  String get welcomeBack;

  /// No description provided for @signInToContinue.
  ///
  /// In en, this message translates to:
  /// **'Sign in to continue'**
  String get signInToContinue;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get forgotPassword;

  /// No description provided for @signIn.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get signIn;

  /// No description provided for @dontHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account? '**
  String get dontHaveAccount;

  /// No description provided for @signUp.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get signUp;

  /// No description provided for @createAccount.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get createAccount;

  /// No description provided for @joinUs.
  ///
  /// In en, this message translates to:
  /// **'Join us and start managing your financial life'**
  String get joinUs;

  /// No description provided for @fullName.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get fullName;

  /// No description provided for @confirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirmPassword;

  /// No description provided for @agreeToTerms.
  ///
  /// In en, this message translates to:
  /// **'I agree to the terms of service and privacy policy'**
  String get agreeToTerms;

  /// No description provided for @alreadyHaveAAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account? '**
  String get alreadyHaveAAccount;

  /// No description provided for @selectLanguage.
  ///
  /// In en, this message translates to:
  /// **'Select Language'**
  String get selectLanguage;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @languageChanged.
  ///
  /// In en, this message translates to:
  /// **'Language changed successfully'**
  String get languageChanged;

  /// No description provided for @fillAllFields.
  ///
  /// In en, this message translates to:
  /// **'Please fill in all fields'**
  String get fillAllFields;

  /// No description provided for @passwordsDoNotMatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get passwordsDoNotMatch;

  /// No description provided for @registrationSuccess.
  ///
  /// In en, this message translates to:
  /// **'Registration successful'**
  String get registrationSuccess;

  /// No description provided for @registrationFailed.
  ///
  /// In en, this message translates to:
  /// **'Registration failed'**
  String get registrationFailed;

  /// No description provided for @userAlreadyExists.
  ///
  /// In en, this message translates to:
  /// **'This email is already in use'**
  String get userAlreadyExists;

  /// No description provided for @verifyEmailFirst.
  ///
  /// In en, this message translates to:
  /// **'Please verify your email first'**
  String get verifyEmailFirst;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// No description provided for @errorOccurred.
  ///
  /// In en, this message translates to:
  /// **'An error occurred'**
  String get errorOccurred;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @dashboard.
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get dashboard;

  /// No description provided for @expenses.
  ///
  /// In en, this message translates to:
  /// **'Expenses'**
  String get expenses;

  /// No description provided for @analytics.
  ///
  /// In en, this message translates to:
  /// **'Analytics'**
  String get analytics;

  /// No description provided for @addExpense.
  ///
  /// In en, this message translates to:
  /// **'Add Expense'**
  String get addExpense;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @currencySymbol.
  ///
  /// In en, this message translates to:
  /// **'\$'**
  String get currencySymbol;

  /// No description provided for @category.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get category;

  /// No description provided for @amount.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get amount;

  /// No description provided for @date.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get date;

  /// No description provided for @expenseSaved.
  ///
  /// In en, this message translates to:
  /// **'Expense successfully saved'**
  String get expenseSaved;

  /// No description provided for @pleaseEnterExpenseName.
  ///
  /// In en, this message translates to:
  /// **'Please enter an expense name'**
  String get pleaseEnterExpenseName;

  /// No description provided for @pleaseEnterAmount.
  ///
  /// In en, this message translates to:
  /// **'Please enter an amount'**
  String get pleaseEnterAmount;

  /// No description provided for @expenseName.
  ///
  /// In en, this message translates to:
  /// **'Expense Name'**
  String get expenseName;

  /// No description provided for @lunchRestaurant.
  ///
  /// In en, this message translates to:
  /// **'Lunch (Restaurant)'**
  String get lunchRestaurant;

  /// No description provided for @selectDate.
  ///
  /// In en, this message translates to:
  /// **'Select Date'**
  String get selectDate;

  /// No description provided for @foodDining.
  ///
  /// In en, this message translates to:
  /// **'Food & Dining'**
  String get foodDining;

  /// No description provided for @transportation.
  ///
  /// In en, this message translates to:
  /// **'Transportation'**
  String get transportation;

  /// No description provided for @shopping.
  ///
  /// In en, this message translates to:
  /// **'Shopping'**
  String get shopping;

  /// No description provided for @entertainment.
  ///
  /// In en, this message translates to:
  /// **'Entertainment'**
  String get entertainment;

  /// No description provided for @billsUtilities.
  ///
  /// In en, this message translates to:
  /// **'Bills & Utilities'**
  String get billsUtilities;

  /// No description provided for @healthcare.
  ///
  /// In en, this message translates to:
  /// **'Healthcare'**
  String get healthcare;

  /// No description provided for @education.
  ///
  /// In en, this message translates to:
  /// **'Education'**
  String get education;

  /// No description provided for @other.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get other;

  /// No description provided for @recurringExpense.
  ///
  /// In en, this message translates to:
  /// **'Recurring Expense'**
  String get recurringExpense;

  /// No description provided for @receiptOptional.
  ///
  /// In en, this message translates to:
  /// **'Receipt (Optional)'**
  String get receiptOptional;

  /// No description provided for @takePhotoOrUpload.
  ///
  /// In en, this message translates to:
  /// **'Take a photo or upload'**
  String get takePhotoOrUpload;

  /// No description provided for @tapToAdd.
  ///
  /// In en, this message translates to:
  /// **'Tap to add'**
  String get tapToAdd;

  /// No description provided for @expenseSummary.
  ///
  /// In en, this message translates to:
  /// **'Expense Summary'**
  String get expenseSummary;

  /// No description provided for @enterExpenseName.
  ///
  /// In en, this message translates to:
  /// **'Enter expense name'**
  String get enterExpenseName;

  /// No description provided for @week.
  ///
  /// In en, this message translates to:
  /// **'Week'**
  String get week;

  /// No description provided for @month.
  ///
  /// In en, this message translates to:
  /// **'Month'**
  String get month;

  /// No description provided for @year.
  ///
  /// In en, this message translates to:
  /// **'Year'**
  String get year;

  /// No description provided for @camera.
  ///
  /// In en, this message translates to:
  /// **'Camera'**
  String get camera;

  /// No description provided for @gallery.
  ///
  /// In en, this message translates to:
  /// **'Gallery'**
  String get gallery;

  /// No description provided for @recurringExpenseNote.
  ///
  /// In en, this message translates to:
  /// **'This expense will automatically repeat at the selected frequency'**
  String get recurringExpenseNote;

  /// No description provided for @uploading.
  ///
  /// In en, this message translates to:
  /// **'Uploading...'**
  String get uploading;

  /// No description provided for @familySetup.
  ///
  /// In en, this message translates to:
  /// **'Family Setup'**
  String get familySetup;

  /// No description provided for @createFamilyProfile.
  ///
  /// In en, this message translates to:
  /// **'Create Family Profile'**
  String get createFamilyProfile;

  /// No description provided for @welcomeToFamilyFinance.
  ///
  /// In en, this message translates to:
  /// **'Welcome to Family Finance'**
  String get welcomeToFamilyFinance;

  /// No description provided for @familyFinanceDesc.
  ///
  /// In en, this message translates to:
  /// **'View, manage, and improve your family\'s financial situation'**
  String get familyFinanceDesc;

  /// No description provided for @familyName.
  ///
  /// In en, this message translates to:
  /// **'Family Name'**
  String get familyName;

  /// No description provided for @theFamilyName.
  ///
  /// In en, this message translates to:
  /// **'Enter your family name'**
  String get theFamilyName;

  /// No description provided for @monthlyFamilyIncome.
  ///
  /// In en, this message translates to:
  /// **'Monthly Family Income'**
  String get monthlyFamilyIncome;

  /// No description provided for @fixedMonthlyExpenses.
  ///
  /// In en, this message translates to:
  /// **'Fixed Monthly Expenses'**
  String get fixedMonthlyExpenses;

  /// No description provided for @addMore.
  ///
  /// In en, this message translates to:
  /// **'Add More'**
  String get addMore;

  /// No description provided for @rent.
  ///
  /// In en, this message translates to:
  /// **'Rent'**
  String get rent;

  /// No description provided for @utilities.
  ///
  /// In en, this message translates to:
  /// **'Utilities'**
  String get utilities;

  /// No description provided for @internet.
  ///
  /// In en, this message translates to:
  /// **'Internet'**
  String get internet;

  /// No description provided for @insurance.
  ///
  /// In en, this message translates to:
  /// **'Insurance'**
  String get insurance;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @createNewFamily.
  ///
  /// In en, this message translates to:
  /// **'Create New Family'**
  String get createNewFamily;

  /// No description provided for @createNewFamilyDesc.
  ///
  /// In en, this message translates to:
  /// **'Create a new family profile to manage your family finances'**
  String get createNewFamilyDesc;

  /// No description provided for @joinExistingFamily.
  ///
  /// In en, this message translates to:
  /// **'Join Existing Family'**
  String get joinExistingFamily;

  /// No description provided for @joinExistingFamilyDesc.
  ///
  /// In en, this message translates to:
  /// **'Join an existing family using a family code'**
  String get joinExistingFamilyDesc;

  /// No description provided for @invitationCode.
  ///
  /// In en, this message translates to:
  /// **'Invitation Code'**
  String get invitationCode;

  /// No description provided for @joinFamily.
  ///
  /// In en, this message translates to:
  /// **'Join Family'**
  String get joinFamily;

  /// No description provided for @resetPassword.
  ///
  /// In en, this message translates to:
  /// **'Reset Password'**
  String get resetPassword;

  /// No description provided for @forgotYourPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot Your Password?'**
  String get forgotYourPassword;

  /// No description provided for @resetPasswordMessage.
  ///
  /// In en, this message translates to:
  /// **'Enter your email address to reset your password. We\'ll send you an email with instructions to reset your password.'**
  String get resetPasswordMessage;

  /// No description provided for @emailAddress.
  ///
  /// In en, this message translates to:
  /// **'Email Address'**
  String get emailAddress;

  /// No description provided for @sendResetLink.
  ///
  /// In en, this message translates to:
  /// **'Send Reset Link'**
  String get sendResetLink;

  /// No description provided for @checkYourEmail.
  ///
  /// In en, this message translates to:
  /// **'Check Your Email'**
  String get checkYourEmail;

  /// No description provided for @resetLinkSent.
  ///
  /// In en, this message translates to:
  /// **'Password reset link has been sent to:'**
  String get resetLinkSent;

  /// No description provided for @backToLogin.
  ///
  /// In en, this message translates to:
  /// **'Back to Login'**
  String get backToLogin;

  /// No description provided for @resendEmail.
  ///
  /// In en, this message translates to:
  /// **'Resend Email'**
  String get resendEmail;

  /// No description provided for @editFamilyProfile.
  ///
  /// In en, this message translates to:
  /// **'Edit Family Profile'**
  String get editFamilyProfile;

  /// No description provided for @profileSummary.
  ///
  /// In en, this message translates to:
  /// **'Profile Summary'**
  String get profileSummary;

  /// No description provided for @updateFamilyInfo.
  ///
  /// In en, this message translates to:
  /// **'Update your family information'**
  String get updateFamilyInfo;

  /// No description provided for @monthlyIncome.
  ///
  /// In en, this message translates to:
  /// **'Monthly Income'**
  String get monthlyIncome;

  /// No description provided for @fixedExpenses.
  ///
  /// In en, this message translates to:
  /// **'Fixed Expenses'**
  String get fixedExpenses;

  /// No description provided for @saveChanges.
  ///
  /// In en, this message translates to:
  /// **'Save Changes'**
  String get saveChanges;

  /// No description provided for @cancelChanges.
  ///
  /// In en, this message translates to:
  /// **'Cancel Changes'**
  String get cancelChanges;

  /// No description provided for @familyProfile.
  ///
  /// In en, this message translates to:
  /// **'Family Profile'**
  String get familyProfile;

  /// No description provided for @copy.
  ///
  /// In en, this message translates to:
  /// **'Copy'**
  String get copy;

  /// No description provided for @share.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get share;

  /// No description provided for @familyCodeShareMessage.
  ///
  /// In en, this message translates to:
  /// **'Hello! Join me on {appName} with this family code:\n\n{familyCode}'**
  String familyCodeShareMessage(String appName, String familyCode);

  /// No description provided for @searchExpenses.
  ///
  /// In en, this message translates to:
  /// **'Search Expenses'**
  String get searchExpenses;

  /// No description provided for @searchingFor.
  ///
  /// In en, this message translates to:
  /// **'Searching for:'**
  String get searchingFor;

  /// No description provided for @results.
  ///
  /// In en, this message translates to:
  /// **'results'**
  String get results;

  /// No description provided for @filterOptions.
  ///
  /// In en, this message translates to:
  /// **'Filter Options'**
  String get filterOptions;

  /// No description provided for @clearAll.
  ///
  /// In en, this message translates to:
  /// **'Clear All'**
  String get clearAll;

  /// No description provided for @categories.
  ///
  /// In en, this message translates to:
  /// **'Categories'**
  String get categories;

  /// No description provided for @amountRange.
  ///
  /// In en, this message translates to:
  /// **'Amount Range'**
  String get amountRange;

  /// No description provided for @expensesFound.
  ///
  /// In en, this message translates to:
  /// **'expenses found'**
  String get expensesFound;

  /// No description provided for @applyFilters.
  ///
  /// In en, this message translates to:
  /// **'Apply Filters'**
  String get applyFilters;

  /// No description provided for @filteredTotal.
  ///
  /// In en, this message translates to:
  /// **'Filtered Total'**
  String get filteredTotal;

  /// No description provided for @totalExpenses.
  ///
  /// In en, this message translates to:
  /// **'Total Expenses'**
  String get totalExpenses;

  /// No description provided for @transactions.
  ///
  /// In en, this message translates to:
  /// **'transactions'**
  String get transactions;

  /// No description provided for @all.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get all;

  /// No description provided for @today.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get today;

  /// No description provided for @thisWeek.
  ///
  /// In en, this message translates to:
  /// **'This Week'**
  String get thisWeek;

  /// No description provided for @thisMonth.
  ///
  /// In en, this message translates to:
  /// **'This Month'**
  String get thisMonth;

  /// No description provided for @deleteExpense.
  ///
  /// In en, this message translates to:
  /// **'Delete Expense'**
  String get deleteExpense;

  /// No description provided for @deleteConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this expense?'**
  String get deleteConfirmation;

  /// No description provided for @deleting.
  ///
  /// In en, this message translates to:
  /// **'Deleting...'**
  String get deleting;

  /// No description provided for @removed.
  ///
  /// In en, this message translates to:
  /// **'removed'**
  String get removed;

  /// No description provided for @undo.
  ///
  /// In en, this message translates to:
  /// **'Undo'**
  String get undo;

  /// No description provided for @noExpensesFound.
  ///
  /// In en, this message translates to:
  /// **'No Expenses Found'**
  String get noExpensesFound;

  /// No description provided for @trySearchingElse.
  ///
  /// In en, this message translates to:
  /// **'Try a different search term or clear filters'**
  String get trySearchingElse;

  /// No description provided for @noExpensesYet.
  ///
  /// In en, this message translates to:
  /// **'No Expenses Yet'**
  String get noExpensesYet;

  /// No description provided for @addYourFirstExpense.
  ///
  /// In en, this message translates to:
  /// **'Click the plus button to add your first expense'**
  String get addYourFirstExpense;

  /// No description provided for @viewAll.
  ///
  /// In en, this message translates to:
  /// **'View All'**
  String get viewAll;

  /// No description provided for @totalSpendingText.
  ///
  /// In en, this message translates to:
  /// **'Total Spending'**
  String get totalSpendingText;

  /// No description provided for @vsLastWeek.
  ///
  /// In en, this message translates to:
  /// **'vs Last Week'**
  String get vsLastWeek;

  /// No description provided for @vsLastMonth.
  ///
  /// In en, this message translates to:
  /// **'vs Last Month'**
  String get vsLastMonth;

  /// No description provided for @vsLastYear.
  ///
  /// In en, this message translates to:
  /// **'vs Last Year'**
  String get vsLastYear;

  /// No description provided for @vsPreviousPeriod.
  ///
  /// In en, this message translates to:
  /// **'vs Previous Period'**
  String get vsPreviousPeriod;

  /// No description provided for @averageDaily.
  ///
  /// In en, this message translates to:
  /// **'Daily Average'**
  String get averageDaily;

  /// No description provided for @monthlyBudget.
  ///
  /// In en, this message translates to:
  /// **'Monthly Budget'**
  String get monthlyBudget;

  /// No description provided for @remaining.
  ///
  /// In en, this message translates to:
  /// **'Remaining'**
  String get remaining;

  /// No description provided for @budgetExceeded.
  ///
  /// In en, this message translates to:
  /// **'Budget Exceeded'**
  String get budgetExceeded;

  /// No description provided for @spendingTrend.
  ///
  /// In en, this message translates to:
  /// **'Spending Trend'**
  String get spendingTrend;

  /// No description provided for @incomeVsExpenses.
  ///
  /// In en, this message translates to:
  /// **'Income vs Expenses'**
  String get incomeVsExpenses;

  /// No description provided for @savingsGoals.
  ///
  /// In en, this message translates to:
  /// **'Savings Goals'**
  String get savingsGoals;

  /// No description provided for @categoryBreakdown.
  ///
  /// In en, this message translates to:
  /// **'Category Breakdown'**
  String get categoryBreakdown;

  /// No description provided for @monthlyComparison.
  ///
  /// In en, this message translates to:
  /// **'Monthly Comparison'**
  String get monthlyComparison;

  /// No description provided for @recentTransactions.
  ///
  /// In en, this message translates to:
  /// **'Recent Transactions'**
  String get recentTransactions;

  /// No description provided for @goal.
  ///
  /// In en, this message translates to:
  /// **'Goal'**
  String get goal;

  /// No description provided for @yesterday.
  ///
  /// In en, this message translates to:
  /// **'Yesterday'**
  String get yesterday;

  /// No description provided for @daysAgo.
  ///
  /// In en, this message translates to:
  /// **'days ago'**
  String daysAgo(Object days);

  /// No description provided for @budget.
  ///
  /// In en, this message translates to:
  /// **'Budget'**
  String get budget;

  /// No description provided for @budgetOverview.
  ///
  /// In en, this message translates to:
  /// **'Budget Overview'**
  String get budgetOverview;

  /// No description provided for @spent.
  ///
  /// In en, this message translates to:
  /// **'Spent'**
  String get spent;

  /// No description provided for @spentSoFar.
  ///
  /// In en, this message translates to:
  /// **'Spent So Far'**
  String get spentSoFar;

  /// No description provided for @allocatedBudget.
  ///
  /// In en, this message translates to:
  /// **'Allocated Budget'**
  String get allocatedBudget;

  /// No description provided for @overBudget.
  ///
  /// In en, this message translates to:
  /// **'Over Budget'**
  String get overBudget;

  /// No description provided for @adjust.
  ///
  /// In en, this message translates to:
  /// **'Adjust'**
  String get adjust;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @monthlyBudgetOverview.
  ///
  /// In en, this message translates to:
  /// **'Monthly Budget Overview'**
  String get monthlyBudgetOverview;

  /// No description provided for @uncategorized.
  ///
  /// In en, this message translates to:
  /// **'Uncategorized'**
  String get uncategorized;

  /// No description provided for @amountPaid.
  ///
  /// In en, this message translates to:
  /// **'Amount Paid'**
  String get amountPaid;

  /// No description provided for @receiptDetails.
  ///
  /// In en, this message translates to:
  /// **'Receipt Details'**
  String get receiptDetails;

  /// No description provided for @subtotal.
  ///
  /// In en, this message translates to:
  /// **'Subtotal'**
  String get subtotal;

  /// No description provided for @tax.
  ///
  /// In en, this message translates to:
  /// **'Tax'**
  String get tax;

  /// No description provided for @total.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get total;

  /// No description provided for @familyCodeCopied.
  ///
  /// In en, this message translates to:
  /// **'Family code copied to clipboard!'**
  String get familyCodeCopied;

  /// No description provided for @familyCodeNotFound.
  ///
  /// In en, this message translates to:
  /// **'No family code found to share!'**
  String get familyCodeNotFound;

  /// No description provided for @familyProfileUpdated.
  ///
  /// In en, this message translates to:
  /// **'Family profile updated'**
  String get familyProfileUpdated;

  /// No description provided for @updateError.
  ///
  /// In en, this message translates to:
  /// **'Update error: {error}'**
  String updateError(String error);

  /// No description provided for @familyDataError.
  ///
  /// In en, this message translates to:
  /// **'Failed to load family data: {error}'**
  String familyDataError(String error);

  /// No description provided for @tenantIdNotFound.
  ///
  /// In en, this message translates to:
  /// **'Tenant ID not found'**
  String get tenantIdNotFound;

  /// No description provided for @goodMorning.
  ///
  /// In en, this message translates to:
  /// **'Good Morning!'**
  String get goodMorning;

  /// No description provided for @goodAfternoon.
  ///
  /// In en, this message translates to:
  /// **'Good Afternoon!'**
  String get goodAfternoon;

  /// No description provided for @goodEvening.
  ///
  /// In en, this message translates to:
  /// **'Good Evening!'**
  String get goodEvening;

  /// No description provided for @familySuffix.
  ///
  /// In en, this message translates to:
  /// **'Family'**
  String get familySuffix;

  /// No description provided for @daysLeft.
  ///
  /// In en, this message translates to:
  /// **'{days} days left'**
  String daysLeft(Object days);

  /// No description provided for @quickActions.
  ///
  /// In en, this message translates to:
  /// **'Quick Actions'**
  String get quickActions;

  /// No description provided for @addExpenseAction.
  ///
  /// In en, this message translates to:
  /// **'Add Expense'**
  String get addExpenseAction;

  /// No description provided for @viewAnalyticsAction.
  ///
  /// In en, this message translates to:
  /// **'View Analytics'**
  String get viewAnalyticsAction;

  /// No description provided for @allExpensesAction.
  ///
  /// In en, this message translates to:
  /// **'All Expenses'**
  String get allExpensesAction;

  /// No description provided for @imageUploadedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Image uploaded successfully.'**
  String get imageUploadedSuccess;

  /// No description provided for @uploadError.
  ///
  /// In en, this message translates to:
  /// **'Image upload failed'**
  String get uploadError;

  /// No description provided for @uploadErrorWithMessage.
  ///
  /// In en, this message translates to:
  /// **'Image upload failed: {error}'**
  String uploadErrorWithMessage(String error);

  /// No description provided for @imageUploading.
  ///
  /// In en, this message translates to:
  /// **'Image Uploading...'**
  String get imageUploading;

  /// No description provided for @noFamilyFound.
  ///
  /// In en, this message translates to:
  /// **'No family information found'**
  String get noFamilyFound;

  /// No description provided for @tryAgain.
  ///
  /// In en, this message translates to:
  /// **'Try Again'**
  String get tryAgain;

  /// No description provided for @createFamilyProfileAction.
  ///
  /// In en, this message translates to:
  /// **'Create Family Profile'**
  String get createFamilyProfileAction;

  /// No description provided for @sharingFor.
  ///
  /// In en, this message translates to:
  /// **'Code copied for sharing'**
  String get sharingFor;

  /// No description provided for @invalidInvitationCode.
  ///
  /// In en, this message translates to:
  /// **'Invalid invitation code'**
  String get invalidInvitationCode;

  /// No description provided for @ofIncome.
  ///
  /// In en, this message translates to:
  /// **'of Income'**
  String ofIncome(Object percentage);

  /// No description provided for @firebaseAuthError.
  ///
  /// In en, this message translates to:
  /// **'Firebase authentication error: {error}'**
  String firebaseAuthError(Object error);

  /// No description provided for @noRecentTransactions.
  ///
  /// In en, this message translates to:
  /// **'No recent transactions found'**
  String get noRecentTransactions;

  /// No description provided for @general.
  ///
  /// In en, this message translates to:
  /// **'General'**
  String get general;

  /// No description provided for @darkMode.
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get darkMode;

  /// No description provided for @switchThemes.
  ///
  /// In en, this message translates to:
  /// **'Switch Themes'**
  String get switchThemes;

  /// No description provided for @currency.
  ///
  /// In en, this message translates to:
  /// **'Currency'**
  String get currency;

  /// No description provided for @selectCurrency.
  ///
  /// In en, this message translates to:
  /// **'Select Currency'**
  String get selectCurrency;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @pushNotifications.
  ///
  /// In en, this message translates to:
  /// **'Push Notifications'**
  String get pushNotifications;

  /// No description provided for @receivePushNotifications.
  ///
  /// In en, this message translates to:
  /// **'Receive Push Notifications'**
  String get receivePushNotifications;

  /// No description provided for @emailNotifications.
  ///
  /// In en, this message translates to:
  /// **'Email Notifications'**
  String get emailNotifications;

  /// No description provided for @receiveEmailNotifications.
  ///
  /// In en, this message translates to:
  /// **'Receive Email Notifications'**
  String get receiveEmailNotifications;

  /// No description provided for @about.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// No description provided for @version.
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get version;

  /// No description provided for @privacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicy;

  /// No description provided for @readPrivacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Read our Privacy Policy'**
  String get readPrivacyPolicy;

  /// No description provided for @termsOfService.
  ///
  /// In en, this message translates to:
  /// **'Terms of Service'**
  String get termsOfService;

  /// No description provided for @readTermsOfService.
  ///
  /// In en, this message translates to:
  /// **'Read our Terms of Service'**
  String get readTermsOfService;

  /// No description provided for @account.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get account;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @logoutDescription.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to log out? You will need to sign in again to access your account.'**
  String get logoutDescription;

  /// No description provided for @usd.
  ///
  /// In en, this message translates to:
  /// **'\$'**
  String get usd;

  /// No description provided for @tr.
  ///
  /// In en, this message translates to:
  /// **'₺'**
  String get tr;

  /// No description provided for @currencyChanged.
  ///
  /// In en, this message translates to:
  /// **'Currency changed successfully'**
  String get currencyChanged;

  /// No description provided for @logoutConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Logout Confirmation'**
  String get logoutConfirmation;

  /// No description provided for @logoutMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to log out? You will need to sign in again to access your account.'**
  String get logoutMessage;

  /// No description provided for @remainingBalance.
  ///
  /// In en, this message translates to:
  /// **'Remaining Balance'**
  String get remainingBalance;

  /// No description provided for @totalSpending.
  ///
  /// In en, this message translates to:
  /// **'Total Spending'**
  String get totalSpending;

  /// No description provided for @totalIncome.
  ///
  /// In en, this message translates to:
  /// **'Total Income'**
  String get totalIncome;

  /// No description provided for @onTrack.
  ///
  /// In en, this message translates to:
  /// **'On Track'**
  String get onTrack;

  /// No description provided for @budgetOverflow.
  ///
  /// In en, this message translates to:
  /// **'Budget Overflow'**
  String get budgetOverflow;

  /// No description provided for @goodDay.
  ///
  /// In en, this message translates to:
  /// **'Good Day'**
  String get goodDay;

  /// No description provided for @monthlyProgress.
  ///
  /// In en, this message translates to:
  /// **'Monthly Progress'**
  String get monthlyProgress;

  /// No description provided for @daysPassed.
  ///
  /// In en, this message translates to:
  /// **'Days Passed'**
  String get daysPassed;

  /// No description provided for @budgetUsed.
  ///
  /// In en, this message translates to:
  /// **'Budget Used'**
  String get budgetUsed;

  /// No description provided for @dailyAverage.
  ///
  /// In en, this message translates to:
  /// **'Daily Avg.'**
  String get dailyAverage;

  /// No description provided for @expenseDetails.
  ///
  /// In en, this message translates to:
  /// **'Expense Details'**
  String get expenseDetails;

  /// No description provided for @details.
  ///
  /// In en, this message translates to:
  /// **'Details'**
  String get details;

  /// No description provided for @notes.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get notes;

  /// No description provided for @receipt.
  ///
  /// In en, this message translates to:
  /// **'Receipt'**
  String get receipt;

  /// No description provided for @location.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get location;

  /// No description provided for @viewFullscreen.
  ///
  /// In en, this message translates to:
  /// **'View Fullscreen'**
  String get viewFullscreen;

  /// No description provided for @editExpense.
  ///
  /// In en, this message translates to:
  /// **'Edit Expense'**
  String get editExpense;

  /// No description provided for @locationServicesDisabled.
  ///
  /// In en, this message translates to:
  /// **'Location services are disabled'**
  String get locationServicesDisabled;

  /// No description provided for @locationPermissionDenied.
  ///
  /// In en, this message translates to:
  /// **'Location permission denied'**
  String get locationPermissionDenied;

  /// No description provided for @locationPermissionPermanentlyDenied.
  ///
  /// In en, this message translates to:
  /// **'Location permission permanently denied. Please enable from settings'**
  String get locationPermissionPermanentlyDenied;

  /// No description provided for @getCurrentLocation.
  ///
  /// In en, this message translates to:
  /// **'Get Current Location'**
  String get getCurrentLocation;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'tr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'tr':
      return AppLocalizationsTr();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
