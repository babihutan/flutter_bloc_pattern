import 'person.dart';

// PersonCommand allows us to increment or decrement person points,
// to set a current person, or to toggle their avatar color.
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

