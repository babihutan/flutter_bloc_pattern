import 'person.dart';

abstract class PersonCommand {}

class IncrementPersonPointsByOne extends PersonCommand {}

class DecrementPersonPointsByOne extends PersonCommand {}

class ChangePersonPoints extends PersonCommand {
  final int pointChange;
  ChangePersonPoints({this.pointChange});
}

class TogglePersonColor extends PersonCommand {}

class SetCurrentPerson extends PersonCommand {
  final Person person;
  SetCurrentPerson({this.person});
}

