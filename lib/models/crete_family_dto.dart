class CreateFamilyDto {
  String name;
  int familyIncome;
  List<Map<String, dynamic>> fixedExpenses;

  CreateFamilyDto({
    required this.name,
    required this.familyIncome,
    required this.fixedExpenses,
  });

  @override
  String toString() {
    return 'CreateFamilyDto(name: $name, familyIncome: $familyIncome, fixedExpenses: $fixedExpenses)';
  }

  @override
  List<Object> get props => [name, familyIncome, fixedExpenses];

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'familyIncome': familyIncome,
      'fixedExpenses': fixedExpenses,
    };
  }

  factory CreateFamilyDto.fromJson(Map<String, dynamic> json) {
    return CreateFamilyDto(
      name: json['name'] as String,
      familyIncome: json['familyIncome'] as int,
      fixedExpenses: List<Map<String, dynamic>>.from(json['fixedExpenses'] ?? []),
    );
  }
}