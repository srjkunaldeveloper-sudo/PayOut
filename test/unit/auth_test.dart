import 'package:flutter_test/flutter_test.dart';
import '../mock/mock_test_utils.dart';

void main() {
  test('Mock user helper matches dummy mock values', () {
    final mockUser = MockTestUtils.getMockUserData();
    expect(mockUser['name'], 'John Doe');
  });
}
