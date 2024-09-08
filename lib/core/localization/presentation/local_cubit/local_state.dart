part of 'local_cubit.dart';

class LocalState {}

class InitialState extends LocalState {}

class English extends LocalState {
  final String local;

  English(this.local);
}

class Vietnamese extends LocalState {
  final String local;
  final double convertedValue;

  Vietnamese(this.local, this.convertedValue);
}
