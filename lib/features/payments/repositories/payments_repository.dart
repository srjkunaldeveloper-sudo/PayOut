import 'dart:math';
import 'package:payout/features/payments/models/payments_models.dart';
import 'package:payout/features/payments/dummy/dummy_payments_data.dart';
import 'package:payout/features/payments/services/payments_logger.dart';
import 'package:payout/features/transactions/models/transaction_models.dart' show TransactionModel;
import 'package:payout/features/transactions/repositories/transaction_repository.dart';
import 'package:payout/features/notifications/models/notification_models.dart';
import 'package:payout/features/notifications/repositories/notification_repository.dart';

abstract class PaymentsRepository {
  Future<List<BeneficiaryModel>> getBeneficiaries();
  Future<List<BeneficiaryModel>> searchBeneficiaries(String query);
  Future<List<RecentPaymentModel>> getRecentPayments();
  Future<List<PaymentMethodModel>> getPaymentMethods();
  Future<bool> verifyUPI(String upi);
  Future<TransferResponseModel> sendMoney(TransferRequestModel request);
  Future<ReceiptModel> getReceipt(String transactionId);
  Future<bool> addBeneficiary(BeneficiaryModel beneficiary);
  Future<bool> deleteBeneficiary(String beneficiaryId);
}

class MockPaymentsRepository implements PaymentsRepository {
  final TransactionRepository _transactionRepository;
  final NotificationRepository _notificationRepository;

  MockPaymentsRepository(this._transactionRepository, this._notificationRepository);

  @override
  Future<List<BeneficiaryModel>> getBeneficiaries() async {
    // TODO(api): GET /beneficiaries
    await Future.delayed(const Duration(milliseconds: 500));
    return List.from(DummyPaymentsData.dummyBeneficiaries);
  }

  @override
  Future<List<BeneficiaryModel>> searchBeneficiaries(String query) async {
    // TODO(api): GET /beneficiaries/search
    await Future.delayed(const Duration(milliseconds: 300));
    PaymentsLogger.logSearchBeneficiary(query);
    if (query.isEmpty) {
      return List.from(DummyPaymentsData.dummyBeneficiaries);
    }
    return DummyPaymentsData.dummyBeneficiaries
        .where((b) => b.name.toLowerCase().contains(query.toLowerCase()) || b.upiId.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  @override
  Future<List<RecentPaymentModel>> getRecentPayments() async {
    // TODO(api): GET /payments/recent
    await Future.delayed(const Duration(milliseconds: 400));
    return List.from(DummyPaymentsData.dummyRecentPayments);
  }

  @override
  Future<List<PaymentMethodModel>> getPaymentMethods() async {
    // TODO(api): GET /payments/methods
    await Future.delayed(const Duration(milliseconds: 300));
    return List.from(DummyPaymentsData.dummyPaymentMethods);
  }

  @override
  Future<bool> verifyUPI(String upi) async {
    // TODO(api): POST /payments/resolve-upi
    await Future.delayed(const Duration(milliseconds: 600));
    return upi.contains('@') && upi.length > 5;
  }

  @override
  Future<TransferResponseModel> sendMoney(TransferRequestModel request) async {
    // TODO(api): POST /payments
    PaymentsLogger.logPaymentProcessing(request.amount);
    await Future.delayed(const Duration(milliseconds: 1000));

    final randomId = 'PAY-${100 + Random().nextInt(900)}';
    final randomUTR = 'UTR${100000 + Random().nextInt(900000)}${100000 + Random().nextInt(900000)}';
    final category = request.category ?? (request.recipientType == 'Merchant' ? 'QR Payment' : 'UPI Transfer');
    final methodLabel = request.methodId == 'wallet' ? 'Payout Wallet' : 'Bank Account';

    // DEMO TEST SCENARIOS ONLY (as documented in Phase 4 requirements):
    if (request.amount == 100.0) {
      PaymentsLogger.logPaymentFailed('Demo mode: simulated transaction failure');
      
      // Dispatch failure notification
      await _notificationRepository.addNotification(
        NotificationModel(
          id: 'NOT-${DateTime.now().millisecondsSinceEpoch}',
          title: 'Payment Failed',
          description: 'Payment of ₹${request.amount.toStringAsFixed(0)} to ${request.recipientName} failed.',
          category: 'Payment',
          time: 'Just now',
          isRead: false,
          actionRoute: 'transaction_details',
          relatedEntityId: randomId,
          relatedTransactionId: randomId,
        ),
      );

      return TransferResponseModel(
        success: false,
        transactionId: randomId,
        utrNumber: '',
        status: 'FAILED',
        date: 'Today, Just Now',
      );
    }

    if (request.amount == 200.0) {
      PaymentsLogger.log('Demo mode: simulated transaction pending');

      // Create transaction record
      final tx = TransactionModel(
        id: randomId,
        title: request.recipientName,
        upiId: request.upiId,
        type: 'DEBIT',
        category: category,
        amount: request.amount,
        date: 'Today, Just Now',
        status: 'PENDING',
        paymentMethod: methodLabel,
        utr: randomUTR,
        referenceNumber: 'REF${Random().nextInt(900000) + 100000}',
      );
      await _transactionRepository.addTransaction(tx);

      // Dispatch pending notification
      await _notificationRepository.addNotification(
        NotificationModel(
          id: 'NOT-${DateTime.now().millisecondsSinceEpoch}',
          title: 'Payment Processing',
          description: 'Your payment of ₹${request.amount.toStringAsFixed(0)} to ${request.recipientName} is still processing.',
          category: 'Payment',
          time: 'Just now',
          isRead: false,
          actionRoute: 'transaction_details',
          relatedEntityId: randomId,
          relatedTransactionId: randomId,
        ),
      );

      return TransferResponseModel(
        success: false,
        transactionId: randomId,
        utrNumber: randomUTR,
        status: 'PENDING',
        date: 'Today, Just Now',
      );
    }

    // Success outcome
    final newPayment = RecentPaymentModel(
      id: randomId,
      recipientName: request.recipientName,
      upiId: request.upiId,
      amount: request.amount,
      status: 'SUCCESS',
      date: 'Today, Just Now',
    );
    DummyPaymentsData.dummyRecentPayments.insert(0, newPayment);
    PaymentsLogger.logPaymentSuccess(randomId, randomUTR);

    // Create transaction record
    final tx = TransactionModel(
      id: randomId,
      title: request.recipientName,
      upiId: request.upiId,
      type: 'DEBIT',
      category: category,
      amount: request.amount,
      date: 'Today, Just Now',
      status: 'SUCCESS',
      paymentMethod: methodLabel,
      utr: randomUTR,
      referenceNumber: 'REF${Random().nextInt(900000) + 100000}',
    );
    await _transactionRepository.addTransaction(tx);

    // Dispatch success notification
    await _notificationRepository.addNotification(
      NotificationModel(
        id: 'NOT-${DateTime.now().millisecondsSinceEpoch}',
        title: 'Payment Successful',
        description: 'Payment of ₹${request.amount.toStringAsFixed(0)} to ${request.recipientName} was successful.',
        category: 'Payment',
        time: 'Just now',
        isRead: false,
        actionRoute: 'transaction_details',
        relatedEntityId: randomId,
        relatedTransactionId: randomId,
      ),
    );

    return TransferResponseModel(
      success: true,
      transactionId: randomId,
      utrNumber: randomUTR,
      status: 'SUCCESS',
      date: 'Today, Just Now',
    );
  }

  @override
  Future<ReceiptModel> getReceipt(String transactionId) async {
    // TODO(api): GET /payments/{id}/receipt
    await Future.delayed(const Duration(milliseconds: 500));
    final matchingTx = DummyPaymentsData.dummyRecentPayments.firstWhere(
      (tx) => tx.id == transactionId,
      orElse: () => RecentPaymentModel(
        id: transactionId,
        recipientName: 'Unknown Receiver',
        upiId: 'receiver@upi',
        amount: 0.0,
        status: 'SUCCESS',
        date: 'Today',
      ),
    );

    return ReceiptModel(
      txnId: matchingTx.id,
      utrNumber: 'UTR${100000000000 + Random().nextInt(900000000000)}',
      refNumber: 'REF${100000000 + Random().nextInt(900000000)}',
      amount: matchingTx.amount,
      date: matchingTx.date,
      method: 'UPI (HDFC Bank Account)',
      receiverName: matchingTx.recipientName,
      receiverUpi: matchingTx.upiId,
      status: matchingTx.status,
      notes: 'Transfer completed successfully.',
    );
  }

  @override
  Future<bool> addBeneficiary(BeneficiaryModel beneficiary) async {
    // TODO(api): POST /beneficiaries
    await Future.delayed(const Duration(milliseconds: 400));
    DummyPaymentsData.dummyBeneficiaries.insert(0, beneficiary);
    return true;
  }

  @override
  Future<bool> deleteBeneficiary(String beneficiaryId) async {
    // TODO(api): DELETE /beneficiaries/{id}
    await Future.delayed(const Duration(milliseconds: 400));
    DummyPaymentsData.dummyBeneficiaries.removeWhere((b) => b.id == beneficiaryId);
    return true;
  }
}
