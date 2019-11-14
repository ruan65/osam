// ignore: must_be_immutable
import 'package:osam/domain/state/base_state.dart';

// ignore: must_be_immutable
class Counter extends BaseState {
  var count = 0;
  void increment(int number) => count += number;

  @override
  List<Object> get props => [count];
}
