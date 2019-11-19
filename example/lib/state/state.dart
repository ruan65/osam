// ignore: must_be_immutable
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

  void increment(int number) {
    count += number;
    list.add(number);
  }

  @override
  List<Object> get props => [count];
}
