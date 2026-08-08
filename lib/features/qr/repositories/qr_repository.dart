import 'package:payout/features/qr/models/qr_models.dart';
import 'package:payout/features/qr/dummy/dummy_qr_data.dart';
import 'package:payout/features/qr/services/qr_logger.dart';

abstract class QrRepository {
  Future<ScanResultModel> scanQR(String barcodePayload);
  Future<MerchantModel?> getMerchant(String merchantId);
  Future<PersonalQRModel> getMyQR();
  Future<List<QRHistoryModel>> getRecentScans();
  Future<bool> saveRecentScan(QRHistoryModel historyItem);
  Future<QRResolutionResult> resolveQR(String payload);
}

class MockQrRepository implements QrRepository {
  @override
  Future<ScanResultModel> scanQR(String barcodePayload) async {
    // TODO(api): POST /qr/scan
    await Future.delayed(const Duration(milliseconds: 600));
    QrLogger.logQRScanned(barcodePayload);
    
    if (barcodePayload == DummyQrData.invalidPayload) {
      return const ScanResultModel(
        success: false,
        payload: '',
        errorMessage: 'Invalid QR code signature.',
      );
    }
    return ScanResultModel(success: true, payload: barcodePayload);
  }

  @override
  Future<QRResolutionResult> resolveQR(String payload) async {
    // TODO(api): POST /qr/resolve
    await Future.delayed(const Duration(milliseconds: 600));
    QrLogger.logQRScanned(payload);

    if (payload == DummyQrData.invalidPayload || payload.contains('INVALID')) {
      return QRResolutionResult(
        type: QRType.invalid,
        name: '',
        upiId: '',
        category: '',
        isVerified: false,
        errorMessage: 'The scanned QR code signature could not be verified.',
        qrPayload: payload,
      );
    }

    if (payload == DummyQrData.expiredPayload || payload.contains('EXPIRED')) {
      return QRResolutionResult(
        type: QRType.expired,
        name: '',
        upiId: '',
        category: '',
        isVerified: false,
        isExpired: true,
        errorMessage: 'This QR code has expired. Please ask the merchant to regenerate.',
        qrPayload: payload,
      );
    }

    if (payload == DummyQrData.unsupportedPayload || payload.contains('UNSUPPORTED')) {
      return QRResolutionResult(
        type: QRType.unsupported,
        name: '',
        upiId: '',
        category: '',
        isVerified: false,
        errorMessage: 'This QR format is not supported by Payout UPI.',
        qrPayload: payload,
      );
    }

    if (payload == DummyQrData.validPersonalPayload || payload.contains('rahul@upi')) {
      return QRResolutionResult(
        type: QRType.personal,
        name: 'Rahul Sharma',
        upiId: 'rahul@upi',
        category: 'Personal UPI',
        isVerified: true,
        qrPayload: payload,
      );
    }

    // Default to SRJ Foods (Merchant)
    return QRResolutionResult(
      type: QRType.merchant,
      name: 'SRJ Foods',
      upiId: 'srjfoods@upi',
      category: 'Food & Dining',
      isVerified: true,
      qrPayload: payload,
    );
  }

  @override
  Future<MerchantModel?> getMerchant(String merchantId) async {
    // TODO(api): GET /merchants/{merchantId}
    await Future.delayed(const Duration(milliseconds: 400));
    final index = DummyQrData.dummyMerchants.indexWhere((m) => m.id == merchantId);
    if (index != -1) {
      final merchant = DummyQrData.dummyMerchants[index];
      QrLogger.logMerchantFound(merchant.id, merchant.name);
      return merchant;
    }
    return null;
  }

  @override
  Future<PersonalQRModel> getMyQR() async {
    // TODO(api): GET /qr/my-qr
    await Future.delayed(const Duration(milliseconds: 300));
    return const PersonalQRModel(
      upiId: 'rahulsharma@payout',
      qrCodeUrl: 'https://api.qrserver.com/v1/create-qr-code/?size=250x250&data=upi://pay?pa=rahulsharma@payout',
      userName: 'Rahul Sharma',
    );
  }

  @override
  Future<List<QRHistoryModel>> getRecentScans() async {
    // TODO(api): GET /qr/recent-scans
    await Future.delayed(const Duration(milliseconds: 300));
    return List.from(DummyQrData.dummyHistory);
  }

  @override
  Future<bool> saveRecentScan(QRHistoryModel historyItem) async {
    // TODO(api): POST /qr/recent-scans
    await Future.delayed(const Duration(milliseconds: 200));
    DummyQrData.dummyHistory.insert(0, historyItem);
    return true;
  }
}
