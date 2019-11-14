// ignore: must_be_immutable
import 'package:osam/domain/state/base_state.dart';

import 'model.dart';

// ignore: must_be_immutable
class Counter extends BaseState {
  final count = <int, Model>{};
  void increment(int number) {
    count[number] = Model(number)..number = number;
    print(count);
  }

  @override
  List<Object> get props => [count];
}
