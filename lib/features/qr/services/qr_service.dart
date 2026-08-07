class QrService {
  static Map<String, String> parseUPIUri(String uri) {
    // Parse deep-link query params from upi://pay?pa=address&pn=name
    final Map<String, String> params = {};
    try {
      final uriObj = Uri.parse(uri);
      if (uriObj.scheme == 'upi' && uriObj.host == 'pay') {
        params.addAll(uriObj.queryParameters);
      }
    } catch (_) {
      // Return empty map on parsing exceptions
    }
    return params;
  }
}
