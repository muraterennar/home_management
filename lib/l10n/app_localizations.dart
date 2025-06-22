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
  /// **'Sign in to continue managing your home'**
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
  /// **'Join us and start managing your home efficiently'**
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
  /// **'I agree to the Terms of Service and Privacy Policy'**
  String get agreeToTerms;

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
  /// **'Don\'t worry! Enter your email address and we\'ll send you a link to reset your password.'**
  String get resetPasswordMessage;

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
  /// **'We have sent a password reset link to'**
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

  /// No description provided for @familySetup.
  ///
  /// In en, this message translates to:
  /// **'Family Setup'**
  String get familySetup;

  /// No description provided for @familySetupMessage.
  ///
  /// In en, this message translates to:
  /// **'Set up your family to start managing your home together'**
  String get familySetupMessage;

  /// No description provided for @createNewFamily.
  ///
  /// In en, this message translates to:
  /// **'Create New Family'**
  String get createNewFamily;

  /// No description provided for @createNewFamilyDesc.
  ///
  /// In en, this message translates to:
  /// **'Start fresh with a new family group'**
  String get createNewFamilyDesc;

  /// No description provided for @joinExistingFamily.
  ///
  /// In en, this message translates to:
  /// **'Join Existing Family'**
  String get joinExistingFamily;

  /// No description provided for @joinExistingFamilyDesc.
  ///
  /// In en, this message translates to:
  /// **'Join a family group with an invitation code'**
  String get joinExistingFamilyDesc;

  /// No description provided for @familyName.
  ///
  /// In en, this message translates to:
  /// **'Family Name'**
  String get familyName;

  /// No description provided for @homeAddress.
  ///
  /// In en, this message translates to:
  /// **'Home Address'**
  String get homeAddress;

  /// No description provided for @invitationCode.
  ///
  /// In en, this message translates to:
  /// **'Invitation Code'**
  String get invitationCode;

  /// No description provided for @createFamily.
  ///
  /// In en, this message translates to:
  /// **'Create Family'**
  String get createFamily;

  /// No description provided for @joinFamily.
  ///
  /// In en, this message translates to:
  /// **'Join Family'**
  String get joinFamily;

  /// No description provided for @inviteMessage.
  ///
  /// In en, this message translates to:
  /// **'You can invite family members later from the dashboard'**
  String get inviteMessage;

  /// No description provided for @goodMorning.
  ///
  /// In en, this message translates to:
  /// **'Good Morning!'**
  String get goodMorning;

  /// No description provided for @dashboard.
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get dashboard;

  /// No description provided for @tasks.
  ///
  /// In en, this message translates to:
  /// **'Tasks'**
  String get tasks;

  /// No description provided for @expenses.
  ///
  /// In en, this message translates to:
  /// **'Expenses'**
  String get expenses;

  /// No description provided for @events.
  ///
  /// In en, this message translates to:
  /// **'Events'**
  String get events;

  /// No description provided for @quickActions.
  ///
  /// In en, this message translates to:
  /// **'Quick Actions'**
  String get quickActions;

  /// No description provided for @addExpense.
  ///
  /// In en, this message translates to:
  /// **'Add Expense'**
  String get addExpense;

  /// No description provided for @viewExpenses.
  ///
  /// In en, this message translates to:
  /// **'View Expenses'**
  String get viewExpenses;

  /// No description provided for @analytics.
  ///
  /// In en, this message translates to:
  /// **'Analytics'**
  String get analytics;

  /// No description provided for @addTask.
  ///
  /// In en, this message translates to:
  /// **'Add Task'**
  String get addTask;

  /// No description provided for @recentActivity.
  ///
  /// In en, this message translates to:
  /// **'Recent Activity'**
  String get recentActivity;

  /// No description provided for @viewAll.
  ///
  /// In en, this message translates to:
  /// **'View All'**
  String get viewAll;

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

  /// No description provided for @expenseName.
  ///
  /// In en, this message translates to:
  /// **'Expense Name'**
  String get expenseName;

  /// No description provided for @amount.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get amount;

  /// No description provided for @category.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get category;

  /// No description provided for @receiptOptional.
  ///
  /// In en, this message translates to:
  /// **'Receipt (Optional)'**
  String get receiptOptional;

  /// No description provided for @takePhotoOrUpload.
  ///
  /// In en, this message translates to:
  /// **'Take Photo or Upload Receipt'**
  String get takePhotoOrUpload;

  /// No description provided for @tapToAdd.
  ///
  /// In en, this message translates to:
  /// **'Tap to add receipt image'**
  String get tapToAdd;

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

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @searchExpenses.
  ///
  /// In en, this message translates to:
  /// **'Search expenses...'**
  String get searchExpenses;

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

  /// No description provided for @noExpensesFound.
  ///
  /// In en, this message translates to:
  /// **'No expenses found'**
  String get noExpensesFound;

  /// No description provided for @noExpensesMatch.
  ///
  /// In en, this message translates to:
  /// **'No expenses match your filters'**
  String get noExpensesMatch;

  /// No description provided for @trySearchingElse.
  ///
  /// In en, this message translates to:
  /// **'Try searching for something else'**
  String get trySearchingElse;

  /// No description provided for @tryAdjustingFilters.
  ///
  /// In en, this message translates to:
  /// **'Try adjusting your filter criteria'**
  String get tryAdjustingFilters;

  /// No description provided for @searchingFor.
  ///
  /// In en, this message translates to:
  /// **'Searching for'**
  String get searchingFor;

  /// No description provided for @results.
  ///
  /// In en, this message translates to:
  /// **'results'**
  String get results;

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

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @selectLanguage.
  ///
  /// In en, this message translates to:
  /// **'Select Language'**
  String get selectLanguage;

  /// No description provided for @turkish.
  ///
  /// In en, this message translates to:
  /// **'Türkçe'**
  String get turkish;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @general.
  ///
  /// In en, this message translates to:
  /// **'General'**
  String get general;

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

  /// No description provided for @termsOfService.
  ///
  /// In en, this message translates to:
  /// **'Terms of Service'**
  String get termsOfService;

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

  /// No description provided for @emailNotifications.
  ///
  /// In en, this message translates to:
  /// **'Email Notifications'**
  String get emailNotifications;

  /// No description provided for @darkMode.
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get darkMode;

  /// No description provided for @currency.
  ///
  /// In en, this message translates to:
  /// **'Currency'**
  String get currency;

  /// No description provided for @changeLanguage.
  ///
  /// In en, this message translates to:
  /// **'Change Language'**
  String get changeLanguage;

  /// No description provided for @languageChanged.
  ///
  /// In en, this message translates to:
  /// **'Language changed successfully'**
  String get languageChanged;

  /// No description provided for @restartRequired.
  ///
  /// In en, this message translates to:
  /// **'Please restart the app to apply changes'**
  String get restartRequired;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @totalIncome.
  ///
  /// In en, this message translates to:
  /// **'Total Income'**
  String get totalIncome;

  /// No description provided for @totalSpending.
  ///
  /// In en, this message translates to:
  /// **'Total Spending'**
  String get totalSpending;

  /// No description provided for @remainingBalance.
  ///
  /// In en, this message translates to:
  /// **'Remaining Balance'**
  String get remainingBalance;

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

  /// No description provided for @spendingByCategory.
  ///
  /// In en, this message translates to:
  /// **'Spending by Category'**
  String get spendingByCategory;

  /// No description provided for @monthlySpendingTrends.
  ///
  /// In en, this message translates to:
  /// **'Monthly Spending Trends'**
  String get monthlySpendingTrends;

  /// No description provided for @addMore.
  ///
  /// In en, this message translates to:
  /// **'Add More'**
  String get addMore;

  /// No description provided for @editProfile.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get editProfile;

  /// No description provided for @reports.
  ///
  /// In en, this message translates to:
  /// **'Reports'**
  String get reports;

  /// No description provided for @profileSummary.
  ///
  /// In en, this message translates to:
  /// **'Profile Summary'**
  String get profileSummary;

  /// No description provided for @updateFamilyInfo.
  ///
  /// In en, this message translates to:
  /// **'Update your family financial information'**
  String get updateFamilyInfo;

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

  /// No description provided for @addNewFixedExpense.
  ///
  /// In en, this message translates to:
  /// **'Add New Fixed Expense'**
  String get addNewFixedExpense;

  /// No description provided for @welcomeToFamilyFinance.
  ///
  /// In en, this message translates to:
  /// **'Welcome to Family Finance'**
  String get welcomeToFamilyFinance;

  /// No description provided for @familyFinanceDesc.
  ///
  /// In en, this message translates to:
  /// **'Set up your family profile to start tracking your income and expenses together.'**
  String get familyFinanceDesc;

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

  /// No description provided for @createFamilyProfile.
  ///
  /// In en, this message translates to:
  /// **'Create Family Profile'**
  String get createFamilyProfile;

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

  /// No description provided for @spendingTrend.
  ///
  /// In en, this message translates to:
  /// **'Spending Trend'**
  String get spendingTrend;

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

  /// No description provided for @vsLastMonth.
  ///
  /// In en, this message translates to:
  /// **'vs Last Month'**
  String get vsLastMonth;

  /// No description provided for @averageDaily.
  ///
  /// In en, this message translates to:
  /// **'Average Daily'**
  String get averageDaily;

  /// No description provided for @emailAddress.
  ///
  /// In en, this message translates to:
  /// **'Email Address'**
  String get emailAddress;

  /// No description provided for @switchThemes.
  ///
  /// In en, this message translates to:
  /// **'Switch between light and dark themes'**
  String get switchThemes;

  /// No description provided for @receivePushNotifications.
  ///
  /// In en, this message translates to:
  /// **'Receive push notifications'**
  String get receivePushNotifications;

  /// No description provided for @receiveEmailNotifications.
  ///
  /// In en, this message translates to:
  /// **'Receive email notifications'**
  String get receiveEmailNotifications;

  /// No description provided for @readPrivacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Read our privacy policy'**
  String get readPrivacyPolicy;

  /// No description provided for @readTermsOfService.
  ///
  /// In en, this message translates to:
  /// **'Read our terms of service'**
  String get readTermsOfService;

  /// No description provided for @lunchRestaurant.
  ///
  /// In en, this message translates to:
  /// **'e.g., Lunch at restaurant'**
  String get lunchRestaurant;

  /// No description provided for @addedExpense.
  ///
  /// In en, this message translates to:
  /// **'Added expense:'**
  String get addedExpense;

  /// No description provided for @taskCompleted.
  ///
  /// In en, this message translates to:
  /// **'Task completed:'**
  String get taskCompleted;

  /// No description provided for @newExpense.
  ///
  /// In en, this message translates to:
  /// **'New expense:'**
  String get newExpense;

  /// No description provided for @theFamilyName.
  ///
  /// In en, this message translates to:
  /// **'The Smith Family'**
  String get theFamilyName;

  /// No description provided for @membersTasksActive.
  ///
  /// In en, this message translates to:
  /// **'4 members • 12 tasks active'**
  String get membersTasksActive;

  /// No description provided for @daysLeft.
  ///
  /// In en, this message translates to:
  /// **'15 days left'**
  String get daysLeft;

  /// No description provided for @percentRemaining.
  ///
  /// In en, this message translates to:
  /// **'60% of monthly income remaining'**
  String get percentRemaining;

  /// No description provided for @family.
  ///
  /// In en, this message translates to:
  /// **'Family'**
  String get family;

  /// No description provided for @totalSpendingText.
  ///
  /// In en, this message translates to:
  /// **'Total Spending'**
  String get totalSpendingText;

  /// No description provided for @editFamilyProfile.
  ///
  /// In en, this message translates to:
  /// **'Edit Family Profile'**
  String get editFamilyProfile;

  /// No description provided for @addFamilyMember.
  ///
  /// In en, this message translates to:
  /// **'Add Family Member'**
  String get addFamilyMember;

  /// No description provided for @aprilMonth.
  ///
  /// In en, this message translates to:
  /// **'April'**
  String get aprilMonth;

  /// No description provided for @augustMonth.
  ///
  /// In en, this message translates to:
  /// **'August'**
  String get augustMonth;

  /// No description provided for @decemberMonth.
  ///
  /// In en, this message translates to:
  /// **'December'**
  String get decemberMonth;

  /// No description provided for @editFamilyMemberProfile.
  ///
  /// In en, this message translates to:
  /// **'Edit Family Member Profile'**
  String get editFamilyMemberProfile;

  /// No description provided for @entertainmentExpenses.
  ///
  /// In en, this message translates to:
  /// **'Entertainment Expenses'**
  String get entertainmentExpenses;

  /// No description provided for @familyMemberAdded.
  ///
  /// In en, this message translates to:
  /// **'Family member added'**
  String get familyMemberAdded;

  /// No description provided for @familyMemberEmail.
  ///
  /// In en, this message translates to:
  /// **'Family Member Email'**
  String get familyMemberEmail;

  /// No description provided for @familyMemberName.
  ///
  /// In en, this message translates to:
  /// **'Family Member Name'**
  String get familyMemberName;

  /// No description provided for @familyMemberPhone.
  ///
  /// In en, this message translates to:
  /// **'Family Member Phone'**
  String get familyMemberPhone;

  /// No description provided for @familyMemberProfile.
  ///
  /// In en, this message translates to:
  /// **'Family Member Profile'**
  String get familyMemberProfile;

  /// No description provided for @familyMemberProfileDesc.
  ///
  /// In en, this message translates to:
  /// **'View and edit the profile of your family member.'**
  String get familyMemberProfileDesc;

  /// No description provided for @familyMemberProfileUpdated.
  ///
  /// In en, this message translates to:
  /// **'Family member profile updated'**
  String get familyMemberProfileUpdated;

  /// No description provided for @familyMemberProfileUpdatedDesc.
  ///
  /// In en, this message translates to:
  /// **'The family member\'s profile has been updated successfully.'**
  String get familyMemberProfileUpdatedDesc;

  /// No description provided for @familyMemberRemoved.
  ///
  /// In en, this message translates to:
  /// **'Family member removed'**
  String get familyMemberRemoved;

  /// No description provided for @familyMemberRole.
  ///
  /// In en, this message translates to:
  /// **'Family Member Role'**
  String get familyMemberRole;

  /// No description provided for @familyMemberUpdated.
  ///
  /// In en, this message translates to:
  /// **'Family member updated'**
  String get familyMemberUpdated;

  /// No description provided for @familyMembers.
  ///
  /// In en, this message translates to:
  /// **'Family Members'**
  String get familyMembers;

  /// No description provided for @familyProfile.
  ///
  /// In en, this message translates to:
  /// **'Family Profile'**
  String get familyProfile;

  /// No description provided for @familyProfileDesc.
  ///
  /// In en, this message translates to:
  /// **'Manage your family\'s information and members.'**
  String get familyProfileDesc;

  /// No description provided for @februaryMonth.
  ///
  /// In en, this message translates to:
  /// **'February'**
  String get februaryMonth;

  /// No description provided for @goodMorningFamily.
  ///
  /// In en, this message translates to:
  /// **'Good Morning, Family!'**
  String get goodMorningFamily;

  /// No description provided for @groceries.
  ///
  /// In en, this message translates to:
  /// **'Groceries'**
  String get groceries;

  /// No description provided for @insurance.
  ///
  /// In en, this message translates to:
  /// **'Insurance'**
  String get insurance;

  /// No description provided for @internet.
  ///
  /// In en, this message translates to:
  /// **'Internet'**
  String get internet;

  /// No description provided for @januaryMonth.
  ///
  /// In en, this message translates to:
  /// **'January'**
  String get januaryMonth;

  /// No description provided for @julyMonth.
  ///
  /// In en, this message translates to:
  /// **'July'**
  String get julyMonth;

  /// No description provided for @juneMonth.
  ///
  /// In en, this message translates to:
  /// **'June'**
  String get juneMonth;

  /// No description provided for @marchMonth.
  ///
  /// In en, this message translates to:
  /// **'March'**
  String get marchMonth;

  /// No description provided for @mayMonth.
  ///
  /// In en, this message translates to:
  /// **'May'**
  String get mayMonth;

  /// No description provided for @novemberMonth.
  ///
  /// In en, this message translates to:
  /// **'November'**
  String get novemberMonth;

  /// No description provided for @octoberMonth.
  ///
  /// In en, this message translates to:
  /// **'October'**
  String get octoberMonth;

  /// No description provided for @remainingBalanceAmount.
  ///
  /// In en, this message translates to:
  /// **'Remaining Balance Amount'**
  String get remainingBalanceAmount;

  /// No description provided for @rent.
  ///
  /// In en, this message translates to:
  /// **'Rent'**
  String get rent;

  /// No description provided for @septemberMonth.
  ///
  /// In en, this message translates to:
  /// **'September'**
  String get septemberMonth;

  /// No description provided for @totalExpensesAmount.
  ///
  /// In en, this message translates to:
  /// **'Total Expenses Amount'**
  String get totalExpensesAmount;

  /// No description provided for @totalIncomeAmount.
  ///
  /// In en, this message translates to:
  /// **'Total Income Amount'**
  String get totalIncomeAmount;

  /// No description provided for @transportationExpenses.
  ///
  /// In en, this message translates to:
  /// **'Transportation Expenses'**
  String get transportationExpenses;

  /// No description provided for @utilities.
  ///
  /// In en, this message translates to:
  /// **'Utilities'**
  String get utilities;

  /// No description provided for @alreadyHaveAAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account? '**
  String get alreadyHaveAAccount;

  /// No description provided for @usd.
  ///
  /// In en, this message translates to:
  /// **'US Dollar (\$)'**
  String get usd;

  /// No description provided for @tr.
  ///
  /// In en, this message translates to:
  /// **'Turkish Lira (₺)'**
  String get tr;

  /// No description provided for @selectCurrency.
  ///
  /// In en, this message translates to:
  /// **'Select Currency'**
  String get selectCurrency;

  /// No description provided for @currencyChanged.
  ///
  /// In en, this message translates to:
  /// **'Currency changed successfully'**
  String get currencyChanged;

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

  /// No description provided for @remaining.
  ///
  /// In en, this message translates to:
  /// **'Remaining'**
  String get remaining;

  /// No description provided for @monthlyBudget.
  ///
  /// In en, this message translates to:
  /// **'Monthly Budget'**
  String get monthlyBudget;

  /// No description provided for @goal.
  ///
  /// In en, this message translates to:
  /// **'Goal'**
  String get goal;

  /// No description provided for @groceryShopping.
  ///
  /// In en, this message translates to:
  /// **'Grocery Shopping'**
  String get groceryShopping;

  /// No description provided for @yesterday.
  ///
  /// In en, this message translates to:
  /// **'Yesterday'**
  String get yesterday;

  /// No description provided for @salaryDeposit.
  ///
  /// In en, this message translates to:
  /// **'Salary Deposit'**
  String get salaryDeposit;

  /// No description provided for @daysAgo.
  ///
  /// In en, this message translates to:
  /// **'{days} days ago'**
  String daysAgo(Object days);

  /// No description provided for @electricityBill.
  ///
  /// In en, this message translates to:
  /// **'Electricity Bill'**
  String get electricityBill;

  /// No description provided for @recentTransactions.
  ///
  /// In en, this message translates to:
  /// **'Recent Transactions'**
  String get recentTransactions;

  /// No description provided for @dateRangeSelected.
  ///
  /// In en, this message translates to:
  /// **'Date Range Selected'**
  String get dateRangeSelected;

  /// No description provided for @removed.
  ///
  /// In en, this message translates to:
  /// **'Removed'**
  String get removed;

  /// No description provided for @remove.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get remove;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @undo.
  ///
  /// In en, this message translates to:
  /// **'Undo'**
  String get undo;

  /// No description provided for @noExpensesYet.
  ///
  /// In en, this message translates to:
  /// **'No expenses yet'**
  String get noExpensesYet;

  /// No description provided for @addYourFirstExpense.
  ///
  /// In en, this message translates to:
  /// **'Add your first expense'**
  String get addYourFirstExpense;

  /// No description provided for @recurringExpenseNote.
  ///
  /// In en, this message translates to:
  /// **'This is a recurring expense'**
  String get recurringExpenseNote;

  /// No description provided for @recurringExpense.
  ///
  /// In en, this message translates to:
  /// **'Recurring Expense'**
  String get recurringExpense;

  /// No description provided for @pleaseEnterAmount.
  ///
  /// In en, this message translates to:
  /// **'Please enter an amount'**
  String get pleaseEnterAmount;

  /// No description provided for @selectDate.
  ///
  /// In en, this message translates to:
  /// **'Select Date'**
  String get selectDate;

  /// No description provided for @pleaseEnterExpenseName.
  ///
  /// In en, this message translates to:
  /// **'Please enter an expense name'**
  String get pleaseEnterExpenseName;

  /// No description provided for @expenseSaved.
  ///
  /// In en, this message translates to:
  /// **'Expense saved'**
  String get expenseSaved;

  /// No description provided for @loginFailed.
  ///
  /// In en, this message translates to:
  /// **'Login failed. Please check your credentials.'**
  String get loginFailed;

  /// No description provided for @invalidEmailOrPassword.
  ///
  /// In en, this message translates to:
  /// **'Invalid email or password'**
  String get invalidEmailOrPassword;

  /// No description provided for @fillAllFields.
  ///
  /// In en, this message translates to:
  /// **'Please fill all fields'**
  String get fillAllFields;

  /// No description provided for @firebaseAuthError.
  ///
  /// In en, this message translates to:
  /// **'Firebase Authentication error: '**
  String get firebaseAuthError;

  /// No description provided for @networkError.
  ///
  /// In en, this message translates to:
  /// **'Network error: Please check your internet connection.'**
  String get networkError;

  /// No description provided for @firebaseConnectionError.
  ///
  /// In en, this message translates to:
  /// **'Firebase connection error: '**
  String get firebaseConnectionError;

  /// No description provided for @unknownError.
  ///
  /// In en, this message translates to:
  /// **'Unknown error: '**
  String get unknownError;

  /// No description provided for @userNotLoggedIn.
  ///
  /// In en, this message translates to:
  /// **'User is not logged in.'**
  String get userNotLoggedIn;

  /// No description provided for @profileUpdateError.
  ///
  /// In en, this message translates to:
  /// **'Error updating profile: '**
  String get profileUpdateError;

  /// No description provided for @emailAlreadyVerified.
  ///
  /// In en, this message translates to:
  /// **'User is not logged in or email is already verified.'**
  String get emailAlreadyVerified;

  /// No description provided for @emailVerificationError.
  ///
  /// In en, this message translates to:
  /// **'Error sending email verification: '**
  String get emailVerificationError;

  /// No description provided for @userInfoError.
  ///
  /// In en, this message translates to:
  /// **'Error getting user information: '**
  String get userInfoError;

  /// No description provided for @logoutError.
  ///
  /// In en, this message translates to:
  /// **'Error during logout: '**
  String get logoutError;

  /// No description provided for @passwordRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter your password'**
  String get passwordRequired;

  /// No description provided for @passwordsDoNotMatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get passwordsDoNotMatch;

  /// No description provided for @registrationFailed.
  ///
  /// In en, this message translates to:
  /// **'Registration failed. Please try again.'**
  String get registrationFailed;

  /// No description provided for @registrationSuccess.
  ///
  /// In en, this message translates to:
  /// **'Registration successful! You can now login.'**
  String get registrationSuccess;

  /// No description provided for @verifyEmailFirst.
  ///
  /// In en, this message translates to:
  /// **'Please verify your email address first.'**
  String get verifyEmailFirst;

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
  /// **'Sign out from your account'**
  String get logoutDescription;

  /// No description provided for @logoutConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Logout Confirmation'**
  String get logoutConfirmation;

  /// No description provided for @logoutMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to logout from your account?'**
  String get logoutMessage;

  /// No description provided for @logoutSuccess.
  ///
  /// In en, this message translates to:
  /// **'You have been logged out successfully'**
  String get logoutSuccess;

  /// No description provided for @userAlreadyExists.
  ///
  /// In en, this message translates to:
  /// **'User already exists with this email address.'**
  String get userAlreadyExists;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// No description provided for @currencySymbol.
  ///
  /// In en, this message translates to:
  /// **'\$'**
  String get currencySymbol;
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
