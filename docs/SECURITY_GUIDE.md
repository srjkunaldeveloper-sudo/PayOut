# Security Configuration Guide

This guide highlights the local security modules configured inside Payout.

---

## 🔒 Implemented Guards

### 1. Token Safety Interceptor
- **Location:** `lib/core/network/auth_interceptor.dart`
- Automatically appends token keys securely to requests headers.

### 2. Encryption Helper
- **Location:** `lib/core/security/encryption_helper.dart`
- Used to sanitize local secure data configurations.

### 3. Biometric Checks Stub
- **Location:** `lib/core/security/biometric_manager.dart`
- Facilitates face or fingerprint unlock verification bindings.
