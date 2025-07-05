// Harcama kategorileri için enum tanımı
enum ExpenseCategory {
  foodDining,   // Yemek ve Restoran
  transportation,  // Ulaşım
  shopping,     // Alışveriş
  entertainment,  // Eğlence
  billsUtilities,  // Faturalar ve Hizmetler
  healthcare,   // Sağlık
  education,    // Eğitim
  other;        // Diğer

  // String'ten enum'a dönüşüm
  static ExpenseCategory fromString(String value) {
    return ExpenseCategory.values.firstWhere(
      (category) => category.name == value,
      orElse: () => ExpenseCategory.other,
    );
  }

  // Enum'dan string'e dönüşüm
  String toShortString() {
    return this.name;
  }

  // UI'da gösterilecek çeviriye uygun isim
  String getTranslationKey() {
    switch (this) {
      case ExpenseCategory.foodDining:
        return 'foodDining';
      case ExpenseCategory.transportation:
        return 'transportation';
      case ExpenseCategory.shopping:
        return 'shopping';
      case ExpenseCategory.entertainment:
        return 'entertainment';
      case ExpenseCategory.billsUtilities:
        return 'billsUtilities';
      case ExpenseCategory.healthcare:
        return 'healthcare';
      case ExpenseCategory.education:
        return 'education';
      case ExpenseCategory.other:
        return 'other';
    }
  }

  // Kategori için uygun icon bilgisini döndürür
  String getIconKey() {
    switch (this) {
      case ExpenseCategory.foodDining:
        return 'restaurant';
      case ExpenseCategory.transportation:
        return 'directions_car';
      case ExpenseCategory.shopping:
        return 'shopping_bag';
      case ExpenseCategory.entertainment:
        return 'movie';
      case ExpenseCategory.billsUtilities:
        return 'receipt_long';
      case ExpenseCategory.healthcare:
        return 'local_hospital';
      case ExpenseCategory.education:
        return 'school';
      case ExpenseCategory.other:
        return 'more_horiz';
    }
  }
}

// ExpenseCategory extension metotlar
extension ExpenseCategoryExtension on ExpenseCategory {
  // Kategoriyi DB'ye kaydetmek için string olarak çevirme
  String toDatabaseValue() {
    return this.name;
  }

  // DB'den alınan string değerini enum'a çevirme
  static ExpenseCategory fromDatabaseValue(String value) {
    try {
      return ExpenseCategory.values.firstWhere(
        (element) => element.name == value,
        orElse: () => ExpenseCategory.other,
      );
    } catch (e) {
      return ExpenseCategory.other;
    }
  }
}
