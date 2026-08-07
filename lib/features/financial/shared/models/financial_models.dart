class LoanModel {
  final String id;
  final String title;
  final String category;
  final double interestRate;
  final int tenureMonths;

  const LoanModel({
    required this.id,
    required this.title,
    required this.category,
    required this.interestRate,
    required this.tenureMonths,
  });

  LoanModel copyWith({
    String? id,
    String? title,
    String? category,
    double? interestRate,
    int? tenureMonths,
  }) {
    return LoanModel(
      id: id ?? this.id,
      title: title ?? this.title,
      category: category ?? this.category,
      interestRate: interestRate ?? this.interestRate,
      tenureMonths: tenureMonths ?? this.tenureMonths,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'category': category,
      'interestRate': interestRate,
      'tenureMonths': tenureMonths,
    };
  }

  factory LoanModel.fromJson(Map<String, dynamic> json) {
    return LoanModel(
      id: json['id'] as String,
      title: json['title'] as String,
      category: json['category'] as String,
      interestRate: (json['interestRate'] as num).toDouble(),
      tenureMonths: json['tenureMonths'] as int,
    );
  }
}

class InsurancePolicyModel {
  final String id;
  final String name;
  final String type;
  final double premium;
  final double coverage;

  const InsurancePolicyModel({
    required this.id,
    required this.name,
    required this.type,
    required this.premium,
    required this.coverage,
  });

  InsurancePolicyModel copyWith({
    String? id,
    String? name,
    String? type,
    double? premium,
    double? coverage,
  }) {
    return InsurancePolicyModel(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      premium: premium ?? this.premium,
      coverage: coverage ?? this.coverage,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'premium': premium,
      'coverage': coverage,
    };
  }

  factory InsurancePolicyModel.fromJson(Map<String, dynamic> json) {
    return InsurancePolicyModel(
      id: json['id'] as String,
      name: json['name'] as String,
      type: json['type'] as String,
      premium: (json['premium'] as num).toDouble(),
      coverage: (json['coverage'] as num).toDouble(),
    );
  }
}

class InvestmentModel {
  final String id;
  final String fundName;
  final String type;
  final double nav;
  final double returnPercentage;

  const InvestmentModel({
    required this.id,
    required this.fundName,
    required this.type,
    required this.nav,
    required this.returnPercentage,
  });

  InvestmentModel copyWith({
    String? id,
    String? fundName,
    String? type,
    double? nav,
    double? returnPercentage,
  }) {
    return InvestmentModel(
      id: id ?? this.id,
      fundName: fundName ?? this.fundName,
      type: type ?? this.type,
      nav: nav ?? this.nav,
      returnPercentage: returnPercentage ?? this.returnPercentage,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fundName': fundName,
      'type': type,
      'nav': nav,
      'returnPercentage': returnPercentage,
    };
  }

  factory InvestmentModel.fromJson(Map<String, dynamic> json) {
    return InvestmentModel(
      id: json['id'] as String,
      fundName: json['fundName'] as String,
      type: json['type'] as String,
      nav: (json['nav'] as num).toDouble(),
      returnPercentage: (json['returnPercentage'] as num).toDouble(),
    );
  }
}

class PortfolioModel {
  final double totalValue;
  final double returnsValue;
  final double returnPercentage;

  const PortfolioModel({
    required this.totalValue,
    required this.returnsValue,
    required this.returnPercentage,
  });
}
