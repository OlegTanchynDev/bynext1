class Ticker {
  Stream<int> tick({int period = 1}) {
    return Stream.periodic(Duration(seconds: period));
  }
}