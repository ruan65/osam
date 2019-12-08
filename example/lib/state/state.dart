// ignore: must_be_immutable

import 'package:osam/domain/state/base_state.dart';

// ignore: must_be_immutable
class AppState extends BaseState<AppState> {
  var counter = 0;

  void increment() => this.counter++;

  @override
  List<Object> get props => [counter];
}
