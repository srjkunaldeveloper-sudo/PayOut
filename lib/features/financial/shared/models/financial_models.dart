class LoanModel {
  final String id;
  final String title;
  final String category;
  final double interestRate;
  final int tenureMonths;
  final double minAmount;
  final double maxAmount;
  final int minTenureMonths;
  final int maxTenureMonths;
  final double processingFeePercent;
  final String eligibilityCriteria;
  final String approvalTime;
  final List<String> benefits;
  final String terms;

  const LoanModel({
    required this.id,
    required this.title,
    required this.category,
    required this.interestRate,
    required this.tenureMonths,
    this.minAmount = 10000.0,
    this.maxAmount = 500000.0,
    this.minTenureMonths = 6,
    this.maxTenureMonths = 60,
    this.processingFeePercent = 1.5,
    this.eligibilityCriteria = 'Indian citizen, Age 21-58, Min. Income ₹25,000/mo',
    this.approvalTime = 'Instant in 2 minutes',
    this.benefits = const ['Zero collateral required', 'Flexible repayment tenure', 'Direct bank disbursement'],
    this.terms = 'Subject to credit assessment and KYC verification.',
  });

  LoanModel copyWith({
    String? id,
    String? title,
    String? category,
    double? interestRate,
    int? tenureMonths,
    double? minAmount,
    double? maxAmount,
    int? minTenureMonths,
    int? maxTenureMonths,
    double? processingFeePercent,
    String? eligibilityCriteria,
    String? approvalTime,
    List<String>? benefits,
    String? terms,
  }) {
    return LoanModel(
      id: id ?? this.id,
      title: title ?? this.title,
      category: category ?? this.category,
      interestRate: interestRate ?? this.interestRate,
      tenureMonths: tenureMonths ?? this.tenureMonths,
      minAmount: minAmount ?? this.minAmount,
      maxAmount: maxAmount ?? this.maxAmount,
      minTenureMonths: minTenureMonths ?? this.minTenureMonths,
      maxTenureMonths: maxTenureMonths ?? this.maxTenureMonths,
      processingFeePercent: processingFeePercent ?? this.processingFeePercent,
      eligibilityCriteria: eligibilityCriteria ?? this.eligibilityCriteria,
      approvalTime: approvalTime ?? this.approvalTime,
      benefits: benefits ?? this.benefits,
      terms: terms ?? this.terms,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'category': category,
      'interestRate': interestRate,
      'tenureMonths': tenureMonths,
      'minAmount': minAmount,
      'maxAmount': maxAmount,
      'minTenureMonths': minTenureMonths,
      'maxTenureMonths': maxTenureMonths,
      'processingFeePercent': processingFeePercent,
      'eligibilityCriteria': eligibilityCriteria,
      'approvalTime': approvalTime,
      'benefits': benefits,
      'terms': terms,
    };
  }

  factory LoanModel.fromJson(Map<String, dynamic> json) {
    return LoanModel(
      id: json['id'] as String,
      title: json['title'] as String,
      category: json['category'] as String,
      interestRate: (json['interestRate'] as num).toDouble(),
      tenureMonths: json['tenureMonths'] as int,
      minAmount: (json['minAmount'] as num?)?.toDouble() ?? 10000.0,
      maxAmount: (json['maxAmount'] as num?)?.toDouble() ?? 500000.0,
      minTenureMonths: json['minTenureMonths'] as int? ?? 6,
      maxTenureMonths: json['maxTenureMonths'] as int? ?? 60,
      processingFeePercent: (json['processingFeePercent'] as num?)?.toDouble() ?? 1.5,
      eligibilityCriteria: json['eligibilityCriteria'] as String? ?? 'Age 21-58, Min. Income ₹25,000/mo',
      approvalTime: json['approvalTime'] as String? ?? 'Instant in 2 minutes',
      benefits: (json['benefits'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? const [],
      terms: json['terms'] as String? ?? 'Subject to verification',
    );
  }
}

class LoanEmiCalculation {
  final double monthlyEmi;
  final double totalInterest;
  final double totalRepayment;
  final double processingFee;

  const LoanEmiCalculation({
    required this.monthlyEmi,
    required this.totalInterest,
    required this.totalRepayment,
    required this.processingFee,
  });
}

class LoanApplicationModel {
  final String id;
  final String loanId;
  final String loanTitle;
  final String applicantName;
  final String dob;
  final String employmentType;
  final double monthlyIncome;
  final String panNumber;
  final double requestedAmount;
  final int tenureMonths;
  final double monthlyEmi;
  final double processingFee;
  final double totalRepayment;
  final String status; // APPROVED, PENDING, REJECTED
  final String submittedAt;
  final String? rejectionReason;

  const LoanApplicationModel({
    required this.id,
    required this.loanId,
    required this.loanTitle,
    required this.applicantName,
    required this.dob,
    required this.employmentType,
    required this.monthlyIncome,
    required this.panNumber,
    required this.requestedAmount,
    required this.tenureMonths,
    required this.monthlyEmi,
    required this.processingFee,
    required this.totalRepayment,
    required this.status,
    required this.submittedAt,
    this.rejectionReason,
  });

  LoanApplicationModel copyWith({
    String? id,
    String? loanId,
    String? loanTitle,
    String? applicantName,
    String? dob,
    String? employmentType,
    double? monthlyIncome,
    String? panNumber,
    double? requestedAmount,
    int? tenureMonths,
    double? monthlyEmi,
    double? processingFee,
    double? totalRepayment,
    String? status,
    String? submittedAt,
    String? rejectionReason,
  }) {
    return LoanApplicationModel(
      id: id ?? this.id,
      loanId: loanId ?? this.loanId,
      loanTitle: loanTitle ?? this.loanTitle,
      applicantName: applicantName ?? this.applicantName,
      dob: dob ?? this.dob,
      employmentType: employmentType ?? this.employmentType,
      monthlyIncome: monthlyIncome ?? this.monthlyIncome,
      panNumber: panNumber ?? this.panNumber,
      requestedAmount: requestedAmount ?? this.requestedAmount,
      tenureMonths: tenureMonths ?? this.tenureMonths,
      monthlyEmi: monthlyEmi ?? this.monthlyEmi,
      processingFee: processingFee ?? this.processingFee,
      totalRepayment: totalRepayment ?? this.totalRepayment,
      status: status ?? this.status,
      submittedAt: submittedAt ?? this.submittedAt,
      rejectionReason: rejectionReason ?? this.rejectionReason,
    );
  }
}

class InsurancePolicyModel {
  final String id;
  final String providerName;
  final String name;
  final String type; // Health, Life, Motor, Travel
  final double premium;
  final double coverage;
  final String duration;
  final List<String> benefits;
  final List<String> exclusions;
  final String eligibility;
  final double claimSettlementRatio;
  final String terms;

  const InsurancePolicyModel({
    required this.id,
    required this.providerName,
    required this.name,
    required this.type,
    required this.premium,
    required this.coverage,
    this.duration = '1 Year',
    this.benefits = const ['Cashless hospitalisation', '24/7 Claim Assistance', 'Instant digital policy issuance'],
    this.exclusions = const ['Pre-existing ailments for 30 days', 'Cosmetic treatments'],
    this.eligibility = 'Ages 18 to 65 years',
    this.claimSettlementRatio = 98.4,
    this.terms = 'Standard IRDAI terms apply.',
  });

  InsurancePolicyModel copyWith({
    String? id,
    String? providerName,
    String? name,
    String? type,
    double? premium,
    double? coverage,
    String? duration,
    List<String>? benefits,
    List<String>? exclusions,
    String? eligibility,
    double? claimSettlementRatio,
    String? terms,
  }) {
    return InsurancePolicyModel(
      id: id ?? this.id,
      providerName: providerName ?? this.providerName,
      name: name ?? this.name,
      type: type ?? this.type,
      premium: premium ?? this.premium,
      coverage: coverage ?? this.coverage,
      duration: duration ?? this.duration,
      benefits: benefits ?? this.benefits,
      exclusions: exclusions ?? this.exclusions,
      eligibility: eligibility ?? this.eligibility,
      claimSettlementRatio: claimSettlementRatio ?? this.claimSettlementRatio,
      terms: terms ?? this.terms,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'providerName': providerName,
      'name': name,
      'type': type,
      'premium': premium,
      'coverage': coverage,
      'duration': duration,
      'benefits': benefits,
      'exclusions': exclusions,
      'eligibility': eligibility,
      'claimSettlementRatio': claimSettlementRatio,
      'terms': terms,
    };
  }

  factory InsurancePolicyModel.fromJson(Map<String, dynamic> json) {
    return InsurancePolicyModel(
      id: json['id'] as String,
      providerName: json['providerName'] as String? ?? 'Care Health Insurance',
      name: json['name'] as String,
      type: json['type'] as String,
      premium: (json['premium'] as num).toDouble(),
      coverage: (json['coverage'] as num).toDouble(),
      duration: json['duration'] as String? ?? '1 Year',
      benefits: (json['benefits'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? const [],
      exclusions: (json['exclusions'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? const [],
      eligibility: json['eligibility'] as String? ?? 'Ages 18 to 65 years',
      claimSettlementRatio: (json['claimSettlementRatio'] as num?)?.toDouble() ?? 98.4,
      terms: json['terms'] as String? ?? 'Standard terms apply',
    );
  }
}

class InsuranceQuoteModel {
  final String policyId;
  final double basePremium;
  final double ageFactor;
  final double taxAmount;
  final double finalPremium;

  const InsuranceQuoteModel({
    required this.policyId,
    required this.basePremium,
    required this.ageFactor,
    required this.taxAmount,
    required this.finalPremium,
  });
}

class InsurancePurchaseModel {
  final String id;
  final String policyId;
  final String policyName;
  final String providerName;
  final String applicantName;
  final int age;
  final double coverageAmount;
  final double premiumAmount;
  final String duration;
  final String transactionId;
  final String status;
  final String purchasedAt;

  const InsurancePurchaseModel({
    required this.id,
    required this.policyId,
    required this.policyName,
    required this.providerName,
    required this.applicantName,
    required this.age,
    required this.coverageAmount,
    required this.premiumAmount,
    required this.duration,
    required this.transactionId,
    required this.status,
    required this.purchasedAt,
  });
}

class InvestmentModel {
  final String id;
  final String fundName;
  final String category; // Large Cap, Small Cap, Gold, Debt
  final String type; // Mutual Fund, Gold, Fixed Income
  final double nav;
  final double returnPercentage; // Indicative/historical
  final String riskLevel; // Low, Moderate, High, Very High
  final double minInvestment;
  final double minSip;
  final double expenseRatio;
  final String exitLoad;
  final String lockInPeriod;
  final String description;

  const InvestmentModel({
    required this.id,
    required this.fundName,
    required this.category,
    required this.type,
    required this.nav,
    required this.returnPercentage,
    this.riskLevel = 'Moderate',
    this.minInvestment = 500.0,
    this.minSip = 500.0,
    this.expenseRatio = 0.85,
    this.exitLoad = '1% for redemption within 365 days',
    this.lockInPeriod = 'None',
    this.description = 'Diversified equity fund focusing on high-growth companies across India.',
  });

  InvestmentModel copyWith({
    String? id,
    String? fundName,
    String? category,
    String? type,
    double? nav,
    double? returnPercentage,
    String? riskLevel,
    double? minInvestment,
    double? minSip,
    double? expenseRatio,
    String? exitLoad,
    String? lockInPeriod,
    String? description,
  }) {
    return InvestmentModel(
      id: id ?? this.id,
      fundName: fundName ?? this.fundName,
      category: category ?? this.category,
      type: type ?? this.type,
      nav: nav ?? this.nav,
      returnPercentage: returnPercentage ?? this.returnPercentage,
      riskLevel: riskLevel ?? this.riskLevel,
      minInvestment: minInvestment ?? this.minInvestment,
      minSip: minSip ?? this.minSip,
      expenseRatio: expenseRatio ?? this.expenseRatio,
      exitLoad: exitLoad ?? this.exitLoad,
      lockInPeriod: lockInPeriod ?? this.lockInPeriod,
      description: description ?? this.description,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fundName': fundName,
      'category': category,
      'type': type,
      'nav': nav,
      'returnPercentage': returnPercentage,
      'riskLevel': riskLevel,
      'minInvestment': minInvestment,
      'minSip': minSip,
      'expenseRatio': expenseRatio,
      'exitLoad': exitLoad,
      'lockInPeriod': lockInPeriod,
      'description': description,
    };
  }

  factory InvestmentModel.fromJson(Map<String, dynamic> json) {
    return InvestmentModel(
      id: json['id'] as String,
      fundName: json['fundName'] as String,
      category: json['category'] as String? ?? 'Equity',
      type: json['type'] as String,
      nav: (json['nav'] as num).toDouble(),
      returnPercentage: (json['returnPercentage'] as num).toDouble(),
      riskLevel: json['riskLevel'] as String? ?? 'Moderate',
      minInvestment: (json['minInvestment'] as num?)?.toDouble() ?? 500.0,
      minSip: (json['minSip'] as num?)?.toDouble() ?? 500.0,
      expenseRatio: (json['expenseRatio'] as num?)?.toDouble() ?? 0.85,
      exitLoad: json['exitLoad'] as String? ?? '1% within 1 year',
      lockInPeriod: json['lockInPeriod'] as String? ?? 'None',
      description: json['description'] as String? ?? 'Growth fund',
    );
  }
}

class InvestmentOrderModel {
  final String id;
  final String fundId;
  final String fundName;
  final String orderType; // One-Time, Monthly SIP
  final double amount;
  final String? sipDate;
  final double unitsAllocated;
  final String transactionId;
  final String status;
  final String orderedAt;

  const InvestmentOrderModel({
    required this.id,
    required this.fundId,
    required this.fundName,
    required this.orderType,
    required this.amount,
    this.sipDate,
    required this.unitsAllocated,
    required this.transactionId,
    required this.status,
    required this.orderedAt,
  });
}

class PortfolioHoldingModel {
  final String id;
  final String fundId;
  final String fundName;
  final String category;
  final double investedAmount;
  final double currentValue;
  final double returnsValue;
  final double returnPercentage;
  final String investmentDate;

  const PortfolioHoldingModel({
    required this.id,
    required this.fundId,
    required this.fundName,
    required this.category,
    required this.investedAmount,
    required this.currentValue,
    required this.returnsValue,
    required this.returnPercentage,
    required this.investmentDate,
  });
}

class PortfolioModel {
  final double totalInvested;
  final double currentValue;
  final double returnsValue;
  final double returnPercentage;
  final List<PortfolioHoldingModel> holdings;

  const PortfolioModel({
    required this.totalInvested,
    required this.currentValue,
    required this.returnsValue,
    required this.returnPercentage,
    this.holdings = const [],
  });

  // Backward compatibility alias
  double get totalValue => currentValue;
}
