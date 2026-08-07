class EncryptionHelper {
  static String encrypt(String text) {
    // Stub implementation for backend handoff integration
    return 'encrypted_$text';
  }

  static String decrypt(String text) {
    return text.replaceAll('encrypted_', '');
  }
}
