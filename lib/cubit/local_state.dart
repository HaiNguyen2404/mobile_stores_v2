class LocalState {
  String local;
  LocalState({required this.local});
}

class English extends LocalState {
  double currencyValue;

  English({
    required super.local,
    required this.currencyValue,
  });
}

class Vietnamese extends LocalState {
  double currencyValue;

  Vietnamese({
    required super.local,
    required this.currencyValue,
  });
}
