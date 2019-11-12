// ignore: must_be_immutable
import 'package:osam/domain/state/base_state.dart';

// ignore: must_be_immutable
class Counter extends BaseState {
  var count = 0;
  void increment(int number) => count = count + number;

  @override
  Map<String, Object> get namedProps => {'count': count};
}
