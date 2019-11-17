import 'package:osam/domain/state/base_state.dart';

// ignore: must_be_immutable
class Model extends BaseState {
  final Object key;
  int number = 1;

  Model(this.key);

  void increment() => number++;

  @override
  List<Object> get props => [number];
}
