// ignore: must_be_immutable
import 'package:osam/domain/state/base_state.dart';

// ignore: must_be_immutable
class AppState extends BaseState<AppState> {
  var count = <int>[];
  void increment(int number) => count.add(number);

  @override
  List<Object> get props => [count];
}
