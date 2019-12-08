import 'package:equatable/equatable.dart';

// Uses to compare two objects and calculate "good" hash
class ComparableWrapper<P> extends Equatable {
  final P property;

  ComparableWrapper(this.property);

  @override
  List<P> get props => [property];
}
