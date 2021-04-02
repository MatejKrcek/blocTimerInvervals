class Ticker {
  Stream<int> tick({required int ticks}) {
    return Stream<int>.periodic(
        const Duration(seconds: 1), (x) => ticks - x % (ticks + 1));
  }
}
