class GetDivisors {
  static List<int> by(int num) {
    final mid = num / 2;
    final result = <int>[];
    for (var i = 3; i <= mid; i++) {
      if (num % i == 0 && i < 500) {
        result.add(i - 1);
      }
    }

    return result;
  }
}
