// ignore: must_be_immutable
import 'package:example/subState.dart';
import 'package:hive/hive.dart';
import 'package:osam/domain/state/base_state.dart';

part 'state.g.dart';

@HiveType()
// ignore: must_be_immutable
class AppState extends BaseState<AppState> {
  @HiveField(0)
  int count = 0;

  @HiveField(1)
  var list = [];

  @HiveField(2)
  SubState subState = SubState();

  void increment(int number) {
    count += number;
    list.add(number);
    subState.increment(1);
  }

  @override
  List<Object> get props => [count];
}
