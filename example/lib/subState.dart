// ignore: must_be_immutable
import 'package:hive/hive.dart';
import 'package:osam/domain/state/base_state.dart';

part 'subState.g.dart';

// ignore: must_be_immutable
@HiveType()
class SubState extends BaseState<SubState> {
  @HiveField(0)
  int count = 0;

  void increment(int number) {
    count += number;
  }

  @override
  List<Object> get props => [count];
}
