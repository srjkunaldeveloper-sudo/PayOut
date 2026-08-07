class RetryPolicy {
  final int maxRetries;
  final Duration delay;

  const RetryPolicy({this.maxRetries = 3, this.delay = const Duration(seconds: 2)});
}
