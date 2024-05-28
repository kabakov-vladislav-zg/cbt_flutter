class Dispenser<T, P> {
  Dispenser(
    this.func,
    [bool Function(P, P)? isSame]
  ) : isSame = isSame ?? _isSame<P>;

  final Future<T> Function(P) func;
  final bool Function(P, P) isSame;
  final List<(P, Future<T>)> store = [];

  static bool _isSame<P>(P p1, P p2) => p1 == p2;

  Future<T> call(P param) async {
    final index = store.indexWhere((elem) => isSame(elem.$1, param));
    switch (index) {
      case -1:
        final result = func(param);
        store.add((param, result));
        return result;
      default:
        return store[index].$2;
    }
  }
}