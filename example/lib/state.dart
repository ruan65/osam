// ignore: must_be_immutable
import 'package:osam/domain/state/base_state.dart';

// ignore: must_be_immutable
class Counter extends BaseState {
  var count = <int>[];
  void increment(int number) => count.add(1);

  @override
  List<Object> get props => [count];
}
