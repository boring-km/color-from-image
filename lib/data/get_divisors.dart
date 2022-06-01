import 'dart:collection';

class GetDivisors {
  static const limitPixelSize = 500;
  static const minimumPixelLevel = 8;

  static List<int> by(int num) {
    final mid = num / 2;
    final tempSet = HashSet<int>();
    for (var i = 3; i <= mid; i++) {
      if (num % i == 0 && i < limitPixelSize) {
        tempSet.add(i - 1);
      }
    }

    if (tempSet.length < minimumPixelLevel) {
      tempSet.addAll(by(num - 1));
    }
    return <int>[...tempSet]..sort();
  }
}
