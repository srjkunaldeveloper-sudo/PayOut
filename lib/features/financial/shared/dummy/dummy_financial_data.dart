import 'package:payout/features/financial/shared/models/financial_models.dart';

class DummyFinancialData {
  static final List<LoanModel> dummyLoans = [
    const LoanModel(id: 'LON-112', title: 'Pre-Approved Personal Loan', category: 'Personal', interestRate: 10.5, tenureMonths: 36),
    const LoanModel(id: 'LON-113', title: 'Low-Interest Home Loan', category: 'Home', interestRate: 8.45, tenureMonths: 180),
    const LoanModel(id: 'LON-114', title: 'Elite Business Expansion Loan', category: 'Business', interestRate: 12.0, tenureMonths: 60),
  ];

  static final List<InsurancePolicyModel> dummyPolicies = [
    const InsurancePolicyModel(id: 'INS-201', name: 'Premium Health Guard Cover', type: 'Health', premium: 450.0, coverage: 500000.0),
    const InsurancePolicyModel(id: 'INS-202', name: 'Comprehensive Term Life Plan', type: 'Life', premium: 750.0, coverage: 10000000.0),
    const InsurancePolicyModel(id: 'INS-203', name: 'Secure Motor Insurance Shield', type: 'Motor', premium: 350.0, coverage: 300000.0),
  ];

  static final List<InvestmentModel> dummyInvestments = [
    const InvestmentModel(id: 'INV-301', fundName: 'Axis Bluechip Equity Mutual Fund', type: 'Mutual Fund', nav: 45.20, returnPercentage: 15.4),
    const InvestmentModel(id: 'INV-302', fundName: 'SBI Small Cap Dynamic Growth Fund', type: 'Mutual Fund', nav: 110.80, returnPercentage: 21.20),
    const InvestmentModel(id: 'INV-303', fundName: 'HDFC High Yield Gold & Silver Fund', type: 'Gold Fund', nav: 25.40, returnPercentage: 12.80),
  ];

  static const PortfolioModel dummyPortfolio = PortfolioModel(
    totalValue: 125430.00,
    returnsValue: 18450.00,
    returnPercentage: 17.2,
  );
}
