import 'package:equatable/equatable.dart';

// Uses to compare two objects and calculate "good" hash
class ComparableWrapper extends Equatable {
  final Object property;

  ComparableWrapper(this.property);

  @override
  List<Object> get props => [property];
}
