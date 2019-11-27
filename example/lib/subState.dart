// ignore: must_be_immutable
import 'package:hive/hive.dart';
import 'package:osam/domain/state/base_state.dart';

part 'subState.g.dart';

@HiveType()
// ignore: must_be_immutable
class SubState extends BaseState<SubState> {
  @HiveField(0)
  int count = 0;

  void increment(int number) {
    count += number;
  }

  @override
  List<Object> get props => [count];
}
