import 'package:color_picker/core/logger.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('3024에서 1과 자기 자신을 제외한 약수 구하기', () {
    const num = 3024;
    const mid = num / 2;
    final result = <int>[];
    for (var i = 3; i <= mid; i++) {
      if (num % i == 0) {
        result.add(i);
      }
    }
    equals(result ==
        [3, 4, 6, 7, 8, 9, 12, 14, 16, 18, 21, 24, 27, 28, 36, 42, 48, 54, 56, 63, 72, 84,
          108, 112, 126, 144, 168, 189, 216, 252, 336, 378, 432, 504, 756, 1008, 1512]);
  });
}
