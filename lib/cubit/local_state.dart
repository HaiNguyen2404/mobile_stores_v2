class LocalState {
  String local;
  LocalState({required this.local});
}

class English extends LocalState {
  English({required super.local});
}

class Vietnamese extends LocalState {
  final double currencyValue;

  Vietnamese({
    required super.local,
    required this.currencyValue,
  });
}
