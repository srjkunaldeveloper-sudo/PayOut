# API Integration Guide

This guide provides step-by-step instructions for backend engineers to replace the demo mock repositories in the **Payout** application with production API implementations.

---

## 1. Architecture Overview

The Payout application follows a Clean Layered Architecture:

```
┌─────────────────────────────────────────────────────────────┐
│                     Presentation Layer                      │
│            (Flutter Widgets, State, Screens)                │
└──────────────────────────────┬──────────────────────────────┘
                               │ Calls
                               ▼
┌─────────────────────────────────────────────────────────────┐
│                 Domain Services / Validators                │
│    (Pure Business Logic, Calculation Engines, Validators)   │
└──────────────────────────────┬──────────────────────────────┘
                               │ Calls
                               ▼
┌─────────────────────────────────────────────────────────────┐
│                    Repository Interface                     │
│                (e.g., PaymentsRepository)                   │
└──────────────┬───────────────────────────────┬──────────────┘
               │ Current                       │ Future
               ▼                               ▼
┌──────────────────────────────┐ ┌────────────────────────────┐
│    MockPaymentsRepository    │ │   ApiPaymentsRepository    │
│      (Reads Dummy Data)      │ │   (Calls DioClient/API)    │
└──────────────────────────────┘ └─────────────┬──────────────┘
                                               │
                                               ▼
                                 ┌────────────────────────────┐
                                 │      Dio HTTP Client       │
                                 │  (Auth & Log Interceptors) │
                                 └────────────────────────────┘
```

---

## 2. Step-by-Step Mock → API Replacement Process

### Step 1: Implement the Domain Repository Interface
Create a new file `lib/features/<feature>/repositories/api_<feature>_repository.dart` implementing the domain contract.

#### Practical Example: `ApiPaymentsRepository`

```dart
import 'package:payout/core/network/api_client.dart';
import 'package:payout/core/network/api_response.dart';
import 'package:payout/core/network/network_exception.dart';
import 'package:payout/features/payments/models/payment_models.dart';
import 'package:payout/features/payments/repositories/payments_repository.dart';

class ApiPaymentsRepository implements PaymentsRepository {
  final ApiClient _apiClient;

  ApiPaymentsRepository({ApiClient? apiClient})
      : _apiClient = apiClient ?? ApiClient();

  @override
  Future<List<BeneficiaryModel>> getBeneficiaries() async {
    try {
      final response = await _apiClient.get('/beneficiaries');
      if (response.statusCode == 200 && response.data != null) {
        final List list = response.data['data'] ?? [];
        return list.map((json) => BeneficiaryModel.fromJson(json)).toList();
      }
      throw NetworkException.fromStatusCode(response.statusCode, 'Failed to fetch beneficiaries');
    } catch (e) {
      throw NetworkException(e.toString());
    }
  }

  @override
  Future<PaymentExecutionResult> executePayment({
    required String recipientName,
    required String recipientDetail,
    required String recipientType,
    required double amount,
    required String methodId,
    required String note,
  }) async {
    final payload = {
      'recipientName': recipientName,
      'recipientDetail': recipientDetail,
      'recipientType': recipientType,
      'amount': amount,
      'methodId': methodId,
      'note': note,
    };

    final response = await _apiClient.post('/payments/transfer', data: payload);
    if (response.statusCode == 200 && response.data != null) {
      return PaymentExecutionResult.fromJson(response.data['data']);
    }
    throw NetworkException.fromStatusCode(response.statusCode, 'Payment execution failed');
  }

  // Implement remaining interface methods...
}
```

### Step 2: Register the API Repository in `AppDependencies`
In `lib/core/di/app_dependencies.dart`, update repository initialization according to `AppConfig.repositoryMode`:

```dart
paymentsRepository = AppConfig.repositoryMode == RepositoryMode.api
    ? ApiPaymentsRepository()
    : MockPaymentsRepository(transactionRepository, notificationRepository);
```

### Step 3: Switch the Central Environment Mode
In `lib/core/config/app_config.dart`:

```dart
class AppConfig {
  static const RepositoryMode repositoryMode = RepositoryMode.api;
  static const String apiBaseUrl = 'https://api.yourdomain.com/v1';
}
```

---

## 3. Files That Change vs. Files That Remain Untouched

| Layer | Files Changed | Files Untouched |
| :--- | :--- | :--- |
| **Data Layer** | `api_payments_repository.dart` (NEW), `app_dependencies.dart` (MODIFIED) | `dummy_payments_data.dart` (Retained for offline testing) |
| **Domain Layer** | None | `payment_models.dart`, `payments_repository.dart`, `payments_validator.dart` |
| **Presentation Layer** | **NONE** | `payment_screen.dart`, `mpin_verification_screen.dart`, `payment_processing_screen.dart`, `payment_success_screen.dart` |

---

## 4. Error & Status Code Mapping Standard

The network layer provides `NetworkException.fromStatusCode` to map HTTP errors:

| HTTP Status | Exception Category | Recommended UI Action |
| :--- | :--- | :--- |
| `200 / 201` | Success | Normal render & navigation |
| `400 / 422` | `validationError` | Render field error message or snackbar alert |
| `401` | `unauthorized` | Trigger token refresh or redirect to login |
| `403` | `forbidden` | Display permission denied dialog |
| `404` | `notFound` | Show empty placeholder or not found screen |
| `500..504` | `serverError` | Render retry screen |

---

## 5. Security & PII Protection Guidelines

1. **Zero Sensitive Logging:** Never log MPIN, OTP, CVV, passwords, full PAN, full Aadhaar, or Bearer tokens in console loggers.
2. **Network Interceptor:** `LoggingInterceptor` automatically strips `Authorization`, `Cookie`, and credential headers.
3. **Storage:** Store access tokens and session credentials strictly inside `TokenManager` / encrypted secure storage.
