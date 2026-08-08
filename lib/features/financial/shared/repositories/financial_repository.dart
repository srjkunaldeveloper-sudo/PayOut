import 'package:payout/features/financial/shared/models/financial_models.dart';
import 'package:payout/features/financial/shared/dummy/dummy_financial_data.dart';
import 'package:payout/features/financial/shared/services/financial_logger.dart';
import 'package:payout/features/financial/shared/services/financial_service.dart';
import 'package:payout/features/notifications/models/notification_models.dart';
import 'package:payout/features/notifications/repositories/notification_repository.dart';
import 'package:payout/features/transactions/models/transaction_models.dart';
import 'package:payout/features/transactions/repositories/transaction_repository.dart';
import 'package:payout/features/user/repositories/user_repository.dart';

abstract class FinancialRepository {
  Future<List<LoanModel>> getLoans();
  Future<LoanModel?> getLoanById(String id);
  Future<LoanApplicationModel> submitLoanApplication(LoanApplicationModel application);
  Future<LoanApplicationModel> getLoanApplicationStatus(String applicationId);

  Future<List<InsurancePolicyModel>> getPolicies();
  Future<InsurancePolicyModel?> getPolicyById(String id);
  Future<InsuranceQuoteModel> getInsuranceQuote(String policyId, int age, {int memberCount = 1});
  Future<InsurancePurchaseModel> purchaseInsurance(InsurancePurchaseModel purchase);

  Future<List<InvestmentModel>> getInvestments();
  Future<PortfolioModel> getPortfolio();
  Future<InvestmentOrderModel> createInvestmentOrder(InvestmentOrderModel order);

  // Backward compatibility signatures
  Future<bool> applyLoan(String id, double amount);
  Future<bool> buyPolicy(String id);
  Future<bool> investFund(String id, double amount);
}

class MockFinancialRepository implements FinancialRepository {
  final TransactionRepository? transactionRepository;
  final NotificationRepository? notificationRepository;
  final UserRepository? userRepository;

  MockFinancialRepository({
    this.transactionRepository,
    this.notificationRepository,
    this.userRepository,
  });

  @override
  Future<List<LoanModel>> getLoans() async {
    // TODO(api): GET /loans/products
    await Future.delayed(const Duration(milliseconds: 300));
    return List.from(DummyFinancialData.dummyLoans);
  }

  @override
  Future<LoanModel?> getLoanById(String id) async {
    // TODO(api): GET /loans/products/{id}
    await Future.delayed(const Duration(milliseconds: 200));
    try {
      return DummyFinancialData.dummyLoans.firstWhere((l) => l.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<LoanApplicationModel> submitLoanApplication(LoanApplicationModel application) async {
    // TODO(api): POST /loans/applications
    await Future.delayed(const Duration(milliseconds: 800));

    // Deterministic Mock Outcome: ₹100 = REJECTED, ₹200 = PENDING, other = APPROVED
    String outcomeStatus = 'APPROVED';
    String? reason;

    if (application.requestedAmount == 100.0) {
      outcomeStatus = 'REJECTED';
      reason = 'Credit bureau score does not meet minimum risk criteria for instant approval.';
    } else if (application.requestedAmount == 200.0) {
      outcomeStatus = 'PENDING';
      reason = 'Underwriting team is conducting manual verification of submitted income records.';
    }

    final finalized = application.copyWith(
      id: 'APP-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
      status: outcomeStatus,
      submittedAt: 'Today, Just Now',
      rejectionReason: reason,
    );

    FinancialLogger.logLoanApplied(application.loanTitle, application.requestedAmount);
    return finalized;
  }

  @override
  Future<LoanApplicationModel> getLoanApplicationStatus(String applicationId) async {
    // TODO(api): GET /loans/applications/{id}/status
    await Future.delayed(const Duration(milliseconds: 300));
    return LoanApplicationModel(
      id: applicationId,
      loanId: 'LON-101',
      loanTitle: 'Instant Personal Loan',
      applicantName: 'Applicant',
      dob: '15/08/1995',
      employmentType: 'Salaried',
      monthlyIncome: 65000.0,
      panNumber: 'ABCDE1234F',
      requestedAmount: 150000.0,
      tenureMonths: 24,
      monthlyEmi: 6958.0,
      processingFee: 2250.0,
      totalRepayment: 167000.0,
      status: 'APPROVED',
      submittedAt: 'Today',
    );
  }

  @override
  Future<List<InsurancePolicyModel>> getPolicies() async {
    // TODO(api): GET /insurance/policies
    await Future.delayed(const Duration(milliseconds: 300));
    return List.from(DummyFinancialData.dummyPolicies);
  }

  @override
  Future<InsurancePolicyModel?> getPolicyById(String id) async {
    // TODO(api): GET /insurance/policies/{id}
    await Future.delayed(const Duration(milliseconds: 200));
    try {
      return DummyFinancialData.dummyPolicies.firstWhere((p) => p.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<InsuranceQuoteModel> getInsuranceQuote(String policyId, int age, {int memberCount = 1}) async {
    // TODO(api): POST /insurance/quotes
    await Future.delayed(const Duration(milliseconds: 250));
    final policy = await getPolicyById(policyId);
    final base = policy?.premium ?? 450.0;
    return FinancialService.calculateInsurancePremium(
      policyId: policyId,
      basePremium: base,
      age: age,
      memberCount: memberCount,
    );
  }

  @override
  Future<InsurancePurchaseModel> purchaseInsurance(InsurancePurchaseModel purchase) async {
    // TODO(api): POST /insurance/purchases
    await Future.delayed(const Duration(milliseconds: 500));

    // 1. Transaction creation
    if (transactionRepository != null) {
      final tx = TransactionModel(
        id: purchase.transactionId,
        title: purchase.policyName,
        upiId: 'insurance@payout',
        amount: purchase.premiumAmount,
        type: 'DEBIT',
        status: 'SUCCESS',
        category: 'Insurance',
        date: 'Today, Just Now',
        paymentMethod: 'Bank Account',
        utr: 'UTR${DateTime.now().millisecondsSinceEpoch}',
        referenceNumber: 'REF${DateTime.now().millisecondsSinceEpoch}',
      );
      await transactionRepository!.addTransaction(tx);
    }

    // 2. Notification creation
    if (notificationRepository != null) {
      final notif = NotificationModel(
        id: 'NOT-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
        title: 'Insurance Policy Issued',
        description: 'Your ${purchase.policyName} policy cover of ₹${(purchase.coverageAmount / 100000).toStringAsFixed(1)}L is now active.',
        time: 'Just now',
        category: 'Insurance',
        isRead: false,
        actionRoute: '/insurance',
        relatedTransactionId: purchase.transactionId,
      );
      await notificationRepository!.addNotification(notif);
    }

    FinancialLogger.logPolicyPurchased(purchase.policyName, purchase.premiumAmount);
    return purchase;
  }

  @override
  Future<List<InvestmentModel>> getInvestments() async {
    // TODO(api): GET /investments/products
    await Future.delayed(const Duration(milliseconds: 300));
    return List.from(DummyFinancialData.dummyInvestments);
  }

  @override
  Future<PortfolioModel> getPortfolio() async {
    // TODO(api): GET /investments/portfolio
    await Future.delayed(const Duration(milliseconds: 300));
    return DummyFinancialData.dummyPortfolio;
  }

  @override
  Future<InvestmentOrderModel> createInvestmentOrder(InvestmentOrderModel order) async {
    // TODO(api): POST /investments/orders
    await Future.delayed(const Duration(milliseconds: 600));

    // 1. Transaction creation
    if (transactionRepository != null) {
      final tx = TransactionModel(
        id: order.transactionId,
        title: order.fundName,
        upiId: 'investments@payout',
        amount: order.amount,
        type: 'DEBIT',
        status: 'SUCCESS',
        category: 'Investment',
        date: 'Today, Just Now',
        paymentMethod: 'Bank Account',
        utr: 'UTR${DateTime.now().millisecondsSinceEpoch}',
        referenceNumber: 'REF${DateTime.now().millisecondsSinceEpoch}',
      );
      await transactionRepository!.addTransaction(tx);
    }

    // 2. Notification creation
    if (notificationRepository != null) {
      final notif = NotificationModel(
        id: 'NOT-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
        title: 'Investment Confirmed',
        description: 'Order of ₹${order.amount.toStringAsFixed(2)} for ${order.fundName} executed successfully.',
        time: 'Just now',
        category: 'Investment',
        isRead: false,
        actionRoute: '/investments',
        relatedTransactionId: order.transactionId,
      );
      await notificationRepository!.addNotification(notif);
    }

    // 3. Dynamic Portfolio update
    final currentPortfolio = DummyFinancialData.dummyPortfolio;
    final updatedHoldings = List<PortfolioHoldingModel>.from(currentPortfolio.holdings);
    final existingIndex = updatedHoldings.indexWhere((h) => h.fundId == order.fundId);

    if (existingIndex != -1) {
      final existing = updatedHoldings[existingIndex];
      final newInvested = existing.investedAmount + order.amount;
      final newCurrent = existing.currentValue + order.amount;
      updatedHoldings[existingIndex] = PortfolioHoldingModel(
        id: existing.id,
        fundId: existing.fundId,
        fundName: existing.fundName,
        category: existing.category,
        investedAmount: newInvested,
        currentValue: newCurrent,
        returnsValue: existing.returnsValue,
        returnPercentage: existing.returnPercentage,
        investmentDate: 'Updated Today',
      );
    } else {
      updatedHoldings.add(
        PortfolioHoldingModel(
          id: 'HLD-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
          fundId: order.fundId,
          fundName: order.fundName,
          category: 'Equity',
          investedAmount: order.amount,
          currentValue: order.amount,
          returnsValue: 0.0,
          returnPercentage: 0.0,
          investmentDate: 'Today',
        ),
      );
    }

    final newTotalInvested = currentPortfolio.totalInvested + order.amount;
    final newCurrentValue = currentPortfolio.currentValue + order.amount;
    DummyFinancialData.dummyPortfolio = PortfolioModel(
      totalInvested: newTotalInvested,
      currentValue: newCurrentValue,
      returnsValue: currentPortfolio.returnsValue,
      returnPercentage: currentPortfolio.returnPercentage,
      holdings: updatedHoldings,
    );

    FinancialLogger.logInvestmentExecuted(order.fundName, order.amount);
    return order;
  }

  @override
  Future<bool> applyLoan(String id, double amount) async {
    final loan = await getLoanById(id);
    if (loan != null) {
      await submitLoanApplication(
        LoanApplicationModel(
          id: 'APP-${DateTime.now().millisecondsSinceEpoch}',
          loanId: loan.id,
          loanTitle: loan.title,
          applicantName: 'User',
          dob: '15/08/1995',
          employmentType: 'Salaried',
          monthlyIncome: 50000.0,
          panNumber: 'ABCDE1234F',
          requestedAmount: amount,
          tenureMonths: loan.tenureMonths,
          monthlyEmi: 3000.0,
          processingFee: 500.0,
          totalRepayment: amount + 2000.0,
          status: 'APPROVED',
          submittedAt: 'Today',
        ),
      );
      return true;
    }
    return false;
  }

  @override
  Future<bool> buyPolicy(String id) async {
    final policy = await getPolicyById(id);
    if (policy != null) {
      await purchaseInsurance(
        InsurancePurchaseModel(
          id: 'POL-${DateTime.now().millisecondsSinceEpoch}',
          policyId: policy.id,
          policyName: policy.name,
          providerName: policy.providerName,
          applicantName: 'User',
          age: 28,
          coverageAmount: policy.coverage,
          premiumAmount: policy.premium,
          duration: policy.duration,
          transactionId: 'TXN-${DateTime.now().millisecondsSinceEpoch}',
          status: 'ACTIVE',
          purchasedAt: 'Today',
        ),
      );
      return true;
    }
    return false;
  }

  @override
  Future<bool> investFund(String id, double amount) async {
    final fund = DummyFinancialData.dummyInvestments.firstWhere((i) => i.id == id);
    await createInvestmentOrder(
      InvestmentOrderModel(
        id: 'ORD-${DateTime.now().millisecondsSinceEpoch}',
        fundId: fund.id,
        fundName: fund.fundName,
        orderType: 'One-Time',
        amount: amount,
        unitsAllocated: amount / fund.nav,
        transactionId: 'TXN-${DateTime.now().millisecondsSinceEpoch}',
        status: 'CONFIRMED',
        orderedAt: 'Today',
      ),
    );
    return true;
  }
}
