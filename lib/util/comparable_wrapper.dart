import 'package:equatable/equatable.dart';

class ComparableWrapper extends Equatable {
  final Object property;

  ComparableWrapper(this.property);

  @override
  List<Object> get props => [property];
}
