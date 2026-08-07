class PinLockManager {
  static Future<bool> verifyPIN(String pin) async {
    return pin == '0000' || pin.length == 4;
  }
}
