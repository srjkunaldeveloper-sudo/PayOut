import 'package:payout/features/financial/shared/models/financial_models.dart';
import 'package:payout/features/financial/shared/dummy/dummy_financial_data.dart';
import 'package:payout/features/financial/shared/services/financial_logger.dart';

abstract class FinancialRepository {
  Future<List<LoanModel>> getLoans();
  Future<List<InsurancePolicyModel>> getPolicies();
  Future<List<InvestmentModel>> getInvestments();
  Future<PortfolioModel> getPortfolio();
  Future<bool> applyLoan(String id, double amount);
  Future<bool> buyPolicy(String id);
  Future<bool> investFund(String id, double amount);
}

class MockFinancialRepository implements FinancialRepository {
  @override
  Future<List<LoanModel>> getLoans() async {
    // TODO: Connect loans database lookup API endpoint
    await Future.delayed(const Duration(milliseconds: 400));
    return List.from(DummyFinancialData.dummyLoans);
  }

  @override
  Future<List<InsurancePolicyModel>> getPolicies() async {
    // TODO: Connect commercial insurance provider feeds
    await Future.delayed(const Duration(milliseconds: 350));
    return List.from(DummyFinancialData.dummyPolicies);
  }

  @override
  Future<List<InvestmentModel>> getInvestments() async {
    // TODO: Connect mutual funds NAV listing API
    await Future.delayed(const Duration(milliseconds: 450));
    return List.from(DummyFinancialData.dummyInvestments);
  }

  @override
  Future<PortfolioModel> getPortfolio() async {
    // TODO: Connect active investments dashboard aggregation engine
    await Future.delayed(const Duration(milliseconds: 300));
    return DummyFinancialData.dummyPortfolio;
  }

  @override
  Future<bool> applyLoan(String id, double amount) async {
    // TODO: Connect loan application submission workflow API
    await Future.delayed(const Duration(milliseconds: 600));
    final index = DummyFinancialData.dummyLoans.indexWhere((l) => l.id == id);
    if (index != -1) {
      final loan = DummyFinancialData.dummyLoans[index];
      FinancialLogger.logLoanApplied(loan.category, amount);
      return true;
    }
    return false;
  }

  @override
  Future<bool> buyPolicy(String id) async {
    // TODO: Connect premium checkout processing engine
    await Future.delayed(const Duration(milliseconds: 550));
    final index = DummyFinancialData.dummyPolicies.indexWhere((p) => p.id == id);
    if (index != -1) {
      final policy = DummyFinancialData.dummyPolicies[index];
      FinancialLogger.logPolicyPurchased(policy.name, policy.premium);
      return true;
    }
    return false;
  }

  @override
  Future<bool> investFund(String id, double amount) async {
    // TODO: Connect investment mutual order checkout gateway
    await Future.delayed(const Duration(milliseconds: 650));
    final index = DummyFinancialData.dummyInvestments.indexWhere((i) => i.id == id);
    if (index != -1) {
      final fund = DummyFinancialData.dummyInvestments[index];
      FinancialLogger.logInvestmentExecuted(fund.fundName, amount);
      return true;
    }
    return false;
  }
}
