import 'package:color_picker/data/get_divisors.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('3024에서 1과 자기 자신을 제외한 약수 구하기', () {
    const num = 3024;

    final actualResult = GetDivisors.by(num);

    final expected = [2, 3, 5, 6, 7, 8, 11, 13, 15, 17, 20, 23, 26, 27, 35, 41, 47, 53, 55, 62, 71, 83,
      107, 111, 125, 143, 167, 188, 215, 251, 335, 377, 431, 503, 755, 1007, 1511];
    expect(actualResult, expected);
  });
}
