part of 'local_cubit.dart';

class LocalState {}

class InitialState extends LocalState {
  final String local;

  InitialState(this.local);
}

class English extends LocalState {
  final String local;

  English(this.local);
}

class Vietnamese extends LocalState {
  final String local;
  final double convertedValue;

  Vietnamese(this.local, this.convertedValue);
}
