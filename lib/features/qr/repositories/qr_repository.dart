import 'package:payout/features/qr/models/qr_models.dart';
import 'package:payout/features/qr/dummy/dummy_qr_data.dart';
import 'package:payout/features/qr/services/qr_logger.dart';

abstract class QrRepository {
  Future<ScanResultModel> scanQR(String barcodePayload);
  Future<MerchantModel?> getMerchant(String merchantId);
  Future<PersonalQRModel> getMyQR();
  Future<List<QRHistoryModel>> getRecentScans();
  Future<bool> saveRecentScan(QRHistoryModel historyItem);
}

class MockQrRepository implements QrRepository {
  @override
  Future<ScanResultModel> scanQR(String barcodePayload) async {
    // TODO: Connect QR verification/parsing API endpoint
    await Future.delayed(const Duration(milliseconds: 1000));
    QrLogger.logQRScanned(barcodePayload);
    
    // Simulate invalid payloads for demo testing
    if (barcodePayload == 'INVALID_TEST') {
      return const ScanResultModel(
        success: false,
        payload: '',
        errorMessage: 'Invalid QR code code signature.',
      );
    }
    return ScanResultModel(success: true, payload: barcodePayload);
  }

  @override
  Future<MerchantModel?> getMerchant(String merchantId) async {
    // TODO: Connect merchant lookup API endpoint
    await Future.delayed(const Duration(milliseconds: 600));
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
    // TODO: Connect personal VPA QR generation API endpoint
    await Future.delayed(const Duration(milliseconds: 400));
    return const PersonalQRModel(
      upiId: 'rahulsharma@okaxis',
      qrCodeUrl: 'https://api.qrserver.com/v1/create-qr-code/?size=250x250&data=upi://pay?pa=rahulsharma@okaxis',
      userName: 'Rahul Sharma',
    );
  }

  @override
  Future<List<QRHistoryModel>> getRecentScans() async {
    // TODO: Connect recent scans history API endpoint
    await Future.delayed(const Duration(milliseconds: 400));
    return List.from(DummyQrData.dummyHistory);
  }

  @override
  Future<bool> saveRecentScan(QRHistoryModel historyItem) async {
    // TODO: Connect save scan history API endpoint
    await Future.delayed(const Duration(milliseconds: 300));
    DummyQrData.dummyHistory.insert(0, historyItem);
    return true;
  }
}
